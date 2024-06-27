//
// EC2 Instance
//
resource "aws_instance" "my_instance" {
  ami           = var.ami # Amazon Linux 2 AMI for eu-west-2 region
  instance_type = var.instance_type

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name        = "MyEC2Instance"
    Environment = "Dev"
  }
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

//
// Security group
//
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}