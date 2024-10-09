#Web Sever EC2
resource "aws_instance" "ecomm-web=server"{
    ami           = "ami-005fc0f236362e99f"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.ecomm-web-sn.id
    key_name      = "resh.pem"
    vpc_security_group_ids = [aws_security_group.ecomm-web-sg.id]
    user_data = file("setup.sh")
      tags = {
      Name = "ecomm-web-server"
      }
    }       


