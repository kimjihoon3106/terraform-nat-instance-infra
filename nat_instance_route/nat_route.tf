resource "aws_route" "nat_instance_route" {
  route_table_id = var.private_route_table_b_id
  destination_cidr_block = "0.0.0.0/0"
  

  network_interface_id = var.nat_instance_network_interface_id
}