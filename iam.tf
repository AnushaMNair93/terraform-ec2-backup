resource "aws_iam_role" "ec2_role" {
  name = "ec2_backup_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name = "ec2_s3_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_instance" "my_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name        = "MyEC2Instance"
    Environment = "Development"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y aws-cli",
      "echo '0 2 * * * ~/backup-script.sh' | crontab -"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "backup-script.sh"
    destination = "~/backup-script.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
