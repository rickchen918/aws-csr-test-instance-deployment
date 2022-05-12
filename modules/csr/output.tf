output "eip" {
    value = aws_eip.default.public_ip
}

output "private_ip" {
    value = aws_eip.default.private_ip
}