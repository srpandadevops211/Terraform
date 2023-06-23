resource "aws_instance" "web" {
  ami           = "ami-09988af04120b3591"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
