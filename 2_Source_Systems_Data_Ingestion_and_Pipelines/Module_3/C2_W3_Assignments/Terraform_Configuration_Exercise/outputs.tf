output database_hostname {
    description = "database hostname"
    value = aws_db_instance.my_database.address

}

output database_username {
    description = "database username"
    value = aws_db_instance.my_database.username 

}

output database_password {
    description = "database password sensitive"
    value = aws_db_instance.my_database.password
    sensitive = true

}

output database_port {
    value = aws_db_instance.my_database.port 

}