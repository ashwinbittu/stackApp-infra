output "aws_vpc_id" {
  value = module.vpc.aws_vpc_id
}

output "aws_subnet_ids" {
  value = module.vpc.aws_subnet_ids
}

output "aws_gw_id" {
  value = module.vpc.aws_gw_id
}

output "aws_security_group_instances_id" {
  value = module.sg-elb.aws_security_group_instances_id
}

/*
output "aws_security_group_elb_id" {
  value = module.sg.aws_security_group_elb_id
}

output "aws_elb_name" {
  value = module.elb.aws_elb_name
}

output "aws_elb_dns_name" {
  value = module.elb.aws_elb_dns_name
}

output "aws_elb_zone_id" {
  value = module.elb.aws_elb_zone_id
}

output "aws_ec2_keypair_name" {
  value = module.ec2key.aws_ec2_keypair_name
}

output "aws_route53_zone_id" {
  value = module.route53.aws_route53_zone_id
}

output "aws_route53_zone_nsservers" {
  value = module.route53.aws_route53_zone_nsservers
}*/

