data "aws_vpc" "main" {
  id = var.vpc_id
}

### START CODE HERE ### (~ 12 lines of code)

# Create a data source for the public subnet 
# using the corresponding variable
data "aws_subnet" "public_subnet" {
  id = var.public_subnet_id
}

# Create a data source for the private subnet in
# the AZ A using the corresponding variable
data "aws_subnet" "private_subnet_a" {
  id = var.private_subnet_a_id
}

# Create a data source for the private subnet in
# the AZ B using the corresponding variable
data "aws_subnet" "private_subnet_b" {
  id = var.private_subnet_b_id
}

### END CODE HERE ###

resource "aws_security_group" "bastion_host" {
  vpc_id = data.aws_vpc.main.id
  name   = "${var.project}-bastion-host-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections (Linux)"
  }
  # eventhough secruity groups are statefull(automatic outbound) its only works if its created in the aws console in terraform both inbound and outbound has to be specified 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }

  tags = {
    Name = "${var.project}-bastion-host-sg"
  }
}

resource "aws_security_group" "database" {
  vpc_id = data.aws_vpc.main.id
  name   = "${var.project}-database-sg"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    # the security group is in list to support any additional sg to connect to the database or other resources 
    security_groups = [aws_security_group.bastion_host.id]
    description     = "Allow incoming connections from the bastion host sg"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }

  tags = {
    Name = "${var.project}-database-sg"
  }
}
