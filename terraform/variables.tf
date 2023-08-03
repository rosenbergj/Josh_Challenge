variable "fqdn" {
  type        = string
  description = "FQDN of the site we're building"
}
variable "phonenumber" {
  type        = string
  description = "Phone number to notify in +1xxxyyyzzzz format"
  default = "+12155551212"
}
