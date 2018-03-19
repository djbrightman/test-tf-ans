resource "aws_security_group" "web" {
  name        = "vpc_web"
  description = "Allow incoming connections."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "WPublicSG"
  }
}

resource "aws_instance" "ansible-host" {
  ami                         = "${lookup(var.amis, var.aws_region)}"
  availability_zone           = "eu-west-1a"
  instance_type               = "t2.micro"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${aws_subnet.eu-west-1a-public.id}"
  associate_public_ip_address = true

  tags {
    Name = "ansible-host"
  }
}

resource "aws_instance" "node" {
  count                       = 2
  ami                         = "${lookup(var.amis, var.aws_region)}"
  availability_zone           = "eu-west-1a"
  instance_type               = "t2.micro"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${aws_subnet.eu-west-1a-public.id}"
  associate_public_ip_address = true

  tags {
    Name = "node-0${count.index + 1}"
  }
}
