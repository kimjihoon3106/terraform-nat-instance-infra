resource "aws_security_group" "public_instance_sg" {
  name = "${var.prefix}-public-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
}

resource "aws_instance" "bastion" {
  ami = var.al2023_ami.id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_a_id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  key_name = "skill"

  tags = {
      "Name" = "bastion"
    }
}

resource "aws_instance" "nat_instance" {
  ami = var.al2023_ami.id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_b_id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  key_name = "skill"

  source_dest_check = false

  tags = {
      "Name" = "nat_instance"
    }
}