resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "main_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-north-1a"
}

resource "aws_internet_gateway" "main_internet_gateway"{
    vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "main_route_table"{
    vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "main_route" {
  route_table_id = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_route_table_association" "main_route_table_association" {
  subnet_id = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_security_group" "main_security_group" {
  name = "main_sg"
  description = "security group for EC2"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#générer une clé ssh 
resource "aws_key_pair" "main_key_pair" {
  key_name = "main_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "main_server"{
  instance_type = "t3.micro"
  ami = "ami-07c8c1b18ca66bb07"
  key_name = aws_key_pair.main_key_pair.id
  vpc_security_group_ids = [aws_security_group.main_security_group.id]
  subnet_id = aws_subnet.main_subnet.id
  user_data = file("script.sh")
  root_block_device {
    volume_size = 10
  }
}