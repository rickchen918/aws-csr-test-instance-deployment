module "csr" {
    source = "./modules/csr"
    cidr_block = "10.0.0.0/24"
    vpc_name = "test"
    instance_type = "t3.medium"
    key_name = "syd"
    csr_ami_filter = "cisco_CSR-17.03.05-AX*"
}