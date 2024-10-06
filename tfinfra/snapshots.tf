resource "aws_ebs_volume" "ebs1" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "Hello Reshma"
  }
}

resource "aws_ebs_snapshot" "ebs_snapshot" {
  volume_id = aws_ebs_volume.ebs1.id

  tags = {
    Name = "Hello_snap"
  }
}
