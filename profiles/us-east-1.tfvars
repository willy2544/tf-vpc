main_vpc_cidr   = "10.0.0.0/16"
public_subnets = {
    "public_subnet_a"  = "10.0.0.0/19"
    "public_subnet_b"  = "10.0.32.0/19"
    "public_subnet_c"  = "10.0.64.0/19"
    "public_subnet_d"  = "10.0.96.0/19"
}
private_subnets = {
    "private_subnet_a" = "10.0.128.0/19"
    "private_subnet_b" = "10.0.160.0/19"
    "private_subnet_c" = "10.0.192.0/19"
    "private_subnet_d" = "10.0.224.0/19"
}
region = "us-east-1"