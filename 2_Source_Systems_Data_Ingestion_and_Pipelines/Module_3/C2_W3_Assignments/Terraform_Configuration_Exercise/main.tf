data "aws_subnets" "subnet_ids" {
    filter{
        name = "vpc-id"
        values = [var.vpc_id]
    }
}

resource "aws_db_subnet_group" "db_subnet_group" {
    subnet_ids = data.aws_subnets.subnet_ids.ids
}

resource "aws_db_instance" "my_database" {
    username = var.db_username 
    password = var.db_password 
    engine = "mysql"
    port = "3306"
    instance_class = "db.t3.micro"
    allocated_storage = 10 
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name 
}