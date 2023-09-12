output "public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = aws_eip.jenkins_public_ip.public_ip
}
