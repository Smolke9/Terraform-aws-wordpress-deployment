output "wordpress_url" {
  value = "http://${aws_instance.wordpress.public_ip}"
}
