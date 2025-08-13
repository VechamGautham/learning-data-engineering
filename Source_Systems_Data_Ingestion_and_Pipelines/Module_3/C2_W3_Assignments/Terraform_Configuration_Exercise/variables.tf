variable vpc_id {
    description = "the id of the vpc where the rds resources will be created"
    type = string 

}

variable db_username {
    description = " the username of the rds resource"
    type = string 
    default = hello_world 


}

variable db_password {
    description = "the password to access rds "
    type = string

}

