variable "naem" {
  type = string
}
variable "vpc_id" {
  type = number
}
variable "port" {
  type = string
}
variable "cidr_blocks" {
  type = list(string)
}
