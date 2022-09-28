/*
 In order to connect to AWS. Terraform has to successfully authenticate. 
 It is done with the help of Programmatic API Keys (i.e) Access Key and Secret.
 Either you should save these Keys as Environment variables (or) save it as a AWS Config profile (AWS CLI).
 $ export AWS_ACCESS_KEY_ID=AK************IEVXQ
 $ export AWS_SECRET_ACCESS_KEY=gbaIbK*********************iwN0dGfS
*/

/*
Some of the Terraform blocks (elements) and their purpose is given below

providers – the provider name aws, google, azure etc
resources – a specific resource with in the provide such as aws_instance for aws
variable – to declare input variables
output – to declare output variables which would be retained the Terraform state file
local – to assign value to an expression, these are local temporary variables work with in a module
module – A module is a container for multiple resources that are used together.
data – To Collect data from the remote provider and save it as a data source
*/

provider "aws" {
    # profile    = "default"
    region = "us-east-2"
    access_key = ""
    secret_key = ""
}

resource "aws_security_group" "web-sg" {
  name = "web-sg-01"
  // To Allow HTTP Transport
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev0-web-01" {
    ami = "ami-091261c03c52eabeb"
    instance_type = "t3.micro"
    vpc_security_group_ids = ["aws_security_group.web-sg.id"]
    user_data = <<-EOF
                #!/bin/bash
                echo "Jones from terraform" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
      "Name" = "dev0-web-01"
    }
  
}

output "dev0-web-01-ip" {
  value = aws_instance.dev0-web-01.public_ip
}


/*
Execute the command terraform init to initialize
Execute the command terraform plan to check what change would be made( Should always do it) - [ Pre-Validate the change – A pilot run]
If you are happy with the changes it is claiming to make, 
then execute terraform apply to commit and start the build
*/




provider "aws" {
    region = "us-east-2"
    access_key = "AX******"
    secret_key = ""
    #profile = "default"
}

resource "aws_security_group" "web-sg-01" {
    name = "web-sg-01"
    ingress {
        protocol = "tcp"
        from_port = "8080"
        to_port = "8080"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

/* resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
} */

resource "aws_instance" "dev0-web-01" {
    ami = "ami-*****"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["aws_security_group.web-sg-01.id"]
    user_data = <<-EOF
    /* #!/bin/bash */
    /* echo "This is running successfully by terraform" > index.html
    nohup busybox httpd -f -p 8080 & */
        #!/bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    EOF
    tags = {
      "Name" = "dev0-web-01"
    }
}

output "dev0-web-01-pubip" {
    value = "aws_instance.dev0-web-01.public_ip"
  
}