output "private_key" {
  value     = aws_key_pair.key_pair
  sensitive = true
}

output "tls_key" {
  value = tls_private_key.ssh_key.private_key_pem
}
