resource "aws_ebs_volume" "ebs" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "Hello Reshma"
  }
}
