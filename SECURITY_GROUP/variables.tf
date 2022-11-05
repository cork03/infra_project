variable "naem" {
  type = string
}
variable "vpc_id" {
  type = number
}
variable "description" {
  type = string
  default = "description"
}
variable "project" {
  type = string
}
variable "enviroment" {
  type = string
}
variable "ingress" {
  type = map
}
variable "egress" {
  type = map
}
