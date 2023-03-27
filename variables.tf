
variable "region" {}
variable "main_vpc_cidr" {}

variable "public_subnets" {
  type = map(any)
}

variable "private_subnets" {
  type = map(any)
}
