resource "aws_instance" "wordpress" {
  ami           = "ami-0f5ee92e2d63afc18"   # Ubuntu 22.04 ap-south-1
  instance_type = "t2.micro"
  key_name      = "your-keypair-name"

  security_groups = [aws_security_group.wp_sg.name]

  user_data = file("userdata.sh")

  tags = {
    Name = "Terraform-WordPress"
  }
}
