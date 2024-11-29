provider "aws" {

  region = "us-east-2"
}

resource "aws_instance" "intro" {

  ami                    = "ami-0c80e2b6ccb9ad6d1"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-2a"
  key_name               = "dove-key"
  vpc_security_group_ids = ["sg-08271574156eec784"]
  tags = {

    Name    = "dove-instances"
    Project = "dove"
  }
}