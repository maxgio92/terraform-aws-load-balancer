# terraform-aws-load-balancer

Terraform module that manages AWS load balancer.

This module creates:

- Application load balancer
- LB default target group
- LB listeners
- Security group


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_tags | The default tags to apply to the resoures | map | `<map>` | no |
| internal | If true, the load balancer will be internal | string | `"true"` | no |
| listeners | A list of map of plain listener definitions. The map must contain 'port' and 'protocol'.   For HTTPS listeners, use instead 'tls_listeners'. | list(map(string)) | `<list>` | no |
| prefix\_name | The prefix for the name of the resources | string | `"my"` | no |
| security\_group\_private\_rules | A list of maps containing security group private rules.   Each map must contain 'port' and 'source', where the source must be a   security group ID allowed to communicate with the LB. | list(map(string)) | `<list>` | no |
| security\_group\_public\_rules | A list of maps containing security group public rules.   Each map must contain 'port' and 'source', where the source must be a   CIDR block alowed to communicate with the LB. | list(map(string)) | `<list>` | no |
| subnet\_ids | The subnets where the load balancer will be placed | list(string) | n/a | yes |
| tls\_listeners | A list of map of HTTPS listener definitions. The map must contain 'port' and 'certificate_arn'. | list(map(string)) | `<list>` | no |
| default\_target\_group\_healthcheck\_path | The destination for the health check request of the detault target group | string | `"/"` | no |
| default\_target\_group\_healthcheck\_response\_codes | The HTTP codes to use when checking for a successful response from a target of the detault target group | string | `"200"` | no |
| default\_tags | The default tags to apply to the resources | map(string) | `{Terraform="true"}` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | The DNS name of the Load Balancer |
| lb\_arn | The ARN of the Load Balancer |
| plain\_listener\_arns | The ARN of the plain listeners of the Load Balancer |
| security\_group\_id | The ID of the security group of the Load Balancer |
| tls\_listener\_arns | The ARN of the TLS listeners of the Load Balancer |
| zone\_id | The canonical hosted zone ID of the Load Balancer |
| default\_target\_group\_arn | The ARN of the default target group created |

