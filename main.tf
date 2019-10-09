# -----------------------------------------------------------------------
# LB
# -----------------------------------------------------------------------

resource "aws_lb" "main" {
  name               = "${var.prefix_name}-lb"
  internal           = var.internal
  load_balancer_type = "application"

  # Workaround for this issue:
  # https://github.com/hashicorp/terraform/issues/13869
  # expected a list, wrap these lists into another lists

  security_groups = [aws_security_group.load_balancers.id]
  subnets         = var.subnet_ids
  enable_http2    = false
  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.prefix_name}-lb"
    },
  )
}

data "aws_subnet" "selected" {
  id = var.subnet_ids[1]
}

# -----------------------------------------------------------------------
# Target group (default)
# -----------------------------------------------------------------------

resource "aws_lb_target_group" "default" {
  port     = var.listeners[count.index]["port"]
  protocol = var.listeners[count.index]["protocol"]
  vpc_id   = data.aws_subnet.selected.vpc_id

  health_check {
    path                = var.default_target_group_healthcheck_path
    matcher             = var.default_target_group_healthcheck_response_codes
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# -----------------------------------------------------------------------
# Listeners
# -----------------------------------------------------------------------

resource "aws_lb_listener" "plain" {
  count = var.listeners_count

  load_balancer_arn = aws_lb.main.arn
  port              = var.listeners[count.index]["port"]
  protocol          = var.listeners[count.index]["protocol"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_listener" "tls" {
  count = var.tls_listeners_count

  load_balancer_arn = aws_lb.main.arn
  port              = var.tls_listeners[count.index]["port"]
  protocol          = "HTTPS"

  certificate_arn = var.tls_listeners[count.index]["certificate_arn"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

# -----------------------------------------------------------------------
# Security groups
# -----------------------------------------------------------------------

resource "aws_security_group" "load_balancers" {
  name        = "${var.prefix_name}-load-balancers"
  description = "Load balancers"

  vpc_id = data.aws_subnet.selected.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.prefix_name}-load-balancers"
    },
  )
}

resource "aws_security_group_rule" "public" {
  count = var.security_group_public_rules_count

  type      = "ingress"
  from_port = var.security_group_public_rules[count.index]["port"]
  to_port   = var.security_group_public_rules[count.index]["port"]
  protocol  = "tcp"

  cidr_blocks = var.security_group_public_rules[count.index]["source"]

  security_group_id = aws_security_group.load_balancers.id
}

resource "aws_security_group_rule" "private" {
  count = var.security_group_private_rules_count

  type      = "ingress"
  from_port = var.security_group_private_rules[count.index]["port"]
  to_port   = var.security_group_private_rules[count.index]["port"]
  protocol  = "tcp"

  source_security_group_id = var.security_group_private_rules[count.index]["source"]

  security_group_id = aws_security_group.load_balancers.id
}

