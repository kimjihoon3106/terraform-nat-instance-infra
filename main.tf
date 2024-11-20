module "vpc" {
  source = "./vpc"
  cidr_block = "10.0.0.0/16"
  cidr_block_public_a = "10.0.0.0/24"
  cidr_block_public_b = "10.0.1.0/24"
  cidr_block_private_a = "10.0.10.0/24"
  cidr_block_private_b = "10.0.11.0/24"
  region = "ap-northeast-2"
  prefix = var.prefix
}

module "ec2" {
    source = "./ec2"
    vpc_id = module.vpc.vpc_id
    prefix = var.prefix
    instance_type = "t3.micro"
    public_subnet_a_id = module.vpc.public_subnet_a_id
    public_subnet_b_id = module.vpc.public_subnet_b_id
    private_subnet_a_id = module.vpc.private_subnet_a_id
    private_subnet_b_id = module.vpc.private_subnet_b_id
    al2023_ami = data.aws_ami.al2023_ami

    depends_on = [ module.vpc ]
  
}

module "nat_instance_route" {
    source = "./nat_instance_route"
    private_route_table_b_id = module.vpc.private_route_table_b_id
    nat_instance_network_interface_id = module.ec2.nat_instance_network_interface_id

    depends_on = [
        module.ec2,
        module.vpc
        ]
}