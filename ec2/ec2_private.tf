resource "aws_security_group" "private_instance_sg" {
  name = "${var.prefix}-private_instance-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
}

resource "aws_instance" "private_instance_a" {
  ami = var.al2023_ami.id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_a_id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  user_data = <<EOF
  #!/bin/bash
  sudo yum update
  sudo yum install -y httpd
  sudo systemtl enable --now httpd
  sudo systemctl start httpd
  EOF

  key_name = "skill"

  tags = {
      "Name" = "private_instance_a"
    }
}

resource "aws_instance" "private_instance_b" {
  ami = var.al2023_ami.id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_b_id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  key_name = "skill"

  user_data = <<EOF
  #!/bin/bash
  sudo yum update
  sudo yum install -y httpd
  sudo systemtl enable --now httpd
  sudo systemctl start httpd
  EOF

  tags = {
      "Name" = "private_instance_b"
    }
}