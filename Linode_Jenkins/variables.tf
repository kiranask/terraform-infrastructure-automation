variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "root_password" {
  description = "Root password for the Linode instance"
  type        = string
  sensitive   = true
}
