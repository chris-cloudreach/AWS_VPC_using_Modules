#you must create security grup before creating instance
# PUBLIC INSTANCE SECURITY GRP


resource "aws_security_group" "my_app_sg" {
  name        = "my_app_sg"
  description = "Allow access to my server"
  vpc_id      = "${module.module_network.my_vpc_id}" 

  #inbound rules
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp" #ssh always use tcp
    cidr_blocks      = ["86.15.241.215/32"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  #outbound rules
  egress {
      # this also connects to private servers
    description = "Allow access to the world"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "my_app_sg"
  }
}

#PRIVATE INSTANCE SECURITY GROUP
resource "aws_security_group" "my_app_sg_PRIVATE" {
  name        = "my_app_sg_PRIVATE"
  description = "Allow access to my private server only from public server"
  vpc_id      = aws_vpc.main.id

  #inbound rules
  ingress {
    description      = "SSH from my public server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp" #ssh always use tcp
    security_groups = [aws_security_group.my_app_sg.id]
    
  }


  tags = {
    Name = "my_app_sg_PRIVATE"
  }
}


#CREATE EC2 INSTANCE 
data "aws_ami" "my_aws_ami" {
  

  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }
  owners = ["137112412989"]
  most_recent = true
  
 
}

resource "aws_instance" "my_first_private_a_server" {
  ami = data.aws_ami.my_aws_ami.id
  instance_type = "t2.micro"
  key_name = "ta-lab-key"
  subnet_id = aws_subnet.private_a_cidr.id
  vpc_security_group_ids = [aws_security_group.my_app_sg_PRIVATE.id]
  tags = {
    Name = "my_first_private_a_server"
  }

}

resource "aws_instance" "my_first_public_a_server" {
  ami = data.aws_ami.my_aws_ami.id
  instance_type = "t2.micro"
  key_name = "ta-lab-key"
  subnet_id = aws_subnet.public_a_cidr.id
  vpc_security_group_ids = [aws_security_group.my_app_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "my_first_public_a_server"
  }

}