provider "aws" {
    region = "eu-central-1"
    profile = "terraform-user"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
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


resource "aws_instance" "web_server" {
  ami           = "ami-085131ff43045c877" 
  instance_type = "t2.micro"  
  key_name      = "smile"  

  vpc_security_group_ids = [aws_security_group.web_sg.id]


  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              docker run -d -p 80:80 ghcr.io/YOUR_GITHUB_USERNAME/YOUR_APP:latest
              EOF

  tags = {
    Name = "Terraform-Web-Server"
  }
}
