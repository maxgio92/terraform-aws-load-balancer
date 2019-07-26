output "lb_arn" {
  value       = "${aws_lb.main.arn}"
  description = "The ARN of the Load Balancer"
}

output "dns_name" {
  value       = "${aws_lb.main.dns_name}"
  description = "The DNS name of the Load Balancer"
}

output "zone_id" {
  value       = "${aws_lb.main.zone_id}"
  description = "The canonical hosted zone ID of the Load Balancer"
}

output "security_group_id" {
  value       = "${aws_security_group.load_balancers.id}"
  description = "The ID of the security group of the Load Balancer"
}

output "plain_listener_arns" {
  value       = "${aws_lb_listener.plain.*.arn}"
  description = "The ARN of the plain listeners of the Load Balancer"
}

output "tls_listener_arns" {
  value       = "${aws_lb_listener.tls.*.arn}"
  description = "The ARN of the TLS listeners of the Load Balancer"
}

output "default_target_group_arn" {
  value       = "${aws_lb_target_group.default.arn}"
  description = "The ARN of the default target group created"
}
