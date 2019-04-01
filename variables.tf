variable "subnet_ids" {
  type        = "list"
  description = "The subnets where the load balancer will be placed"
}

variable "internal" {
  description = "If true, the load balancer will be internal"
  default     = true
}

# Listeners

variable "listeners_count" {
  default     = 0
  description = "The number of plain listeners"
}

# data structure:
# [
#   {
#      port     = "number"
#      protocol = "TCP/HTTP"
#   },
# ]
variable "listeners" {
  type = "list"

  description = <<EOF
  A list of map of plain listener definitions. The map must contain 'port' and 'protocol'.
  For HTTPS listeners, use instead 'tls_listeners' and 'tls_listeners_count'.
  EOF

  default = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]
}

variable "tls_listeners_count" {
  default     = 0
  description = "The number of HTTPS listeners"
}

# data structure:
# [
#   {
#      port            = "number"
#      certificate_arn = "certificate_arn"
#   },
# ]
variable "tls_listeners" {
  type = "list"

  description = <<EOF
  A list of map of HTTPS listener definitions. The map must contain 'port' and 'certificate_arn'.
  EOF

  default = []
}

# SG Rules

# structure:
#[
#  {
#    port:   "port number"
#    source: "CIDR block"
#  }
#]
variable "security_group_public_rules" {
  default = []

  description = <<EOF
  A list of maps containing security group public rules.
  Each map must contain 'port' and 'source', where the source must be a
  CIDR block alowed to communicate with the LB.
  EOF
}

# Workaround to:
# https://github.com/hashicorp/terraform/issues/17421
variable "security_group_public_rules_count" {
  default     = 0
  description = "The number of SG public rules"
}

# structure:
#[
#  {
#    port:   "port number"
#    source: "source security group id"
#  }
#]
variable "security_group_private_rules" {
  default = []

  description = <<EOF
  A list of maps containing security group private rules.
  Each map must contain 'port' and 'source', where the source must be a
  security group ID allowed to communicate with the LB.
  EOF
}

# Workaround to:
# https://github.com/hashicorp/terraform/issues/17421
variable "security_group_private_rules_count" {
  default     = 0
  description = "The number of SG private rules"
}

variable "prefix_name" {
  description = "The prefix for the name of the resources"
  default     = "my"
}

variable "default_tags" {
  type        = "map"
  description = "The default tags to apply to the resoures"

  default = {
    Terraform = "true"
  }
}
