variable "vpc_id" {}
variable "subnet1" {}
variable "subnet2" {}

resource "aws_security_group" "lb_sg" {
  name = "allow_port_80"
  description = "Allow inbound traffic on port 80"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "steinims_lb_sg"
  }

}

# Create a new load balancer
resource "aws_elb" "lb" {
  name = "steinims-terraform-elb"
  subnets = [ "${var.subnet1}","${var.subnet2}" ]
  security_groups = ["${aws_security_group.lb_sg.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/healthcheck.txt"
    interval = 30
  }

  cross_zone_load_balancing = true

  tags {
    Name = "steinims-terraform-elb"
  }
}

output "address" {
    value = "${aws_elb.lb.public_dns}"
}
