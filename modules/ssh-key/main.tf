resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = "${tls_private_key.ssh.private_key_pem}"
  filename = "./private_ssh_key"
}

output "public_ssh_key" {
  value = "${tls_private_key.ssh.public_key_openssh}"
}
