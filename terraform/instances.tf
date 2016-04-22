resource "aws_security_group" "instances_sg" {
  name = "allow_for_instances"
  description = "Allow traffic from to instances"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "steinim_as_conf" {
    name = "steinim_web_config"
    image_id = "ami-08111162"
    instance_type = "t2.micro"
    user_data = "${file("../startup.sh")}"
    key_name = "steinims-key"
    security_groups = [ "${aws_security_group.instances_sg.id}" ]
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "steinim_asg" {
    name = "terraform-asg-steinim"
    launch_configuration = "${aws_launch_configuration.steinim_as_conf.name}"
    min_size = 2
    max_size = 2

    lifecycle {
      create_before_destroy = true
    }
}

