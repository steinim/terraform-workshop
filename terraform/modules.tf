module "lb" {
    source = "./lb"
    vpc_id = "${aws_vpc.main.id}"
    subnet1 = "${aws_subnet.subnet1.id}"
    subnet2 = "${aws_subnet.subnet2.id}"
}
