provider "aws" {
  #region     = var.aws_region
}

#data "aws_route53_zone" "selected" {
#  name         = var.aws_route53_zone_name
#  #private_zone = false
#}

module "vpc" {
  source = "app.terraform.io/radammcorp/vpc/aws"
  #aws_region = var.aws_region
  no_of_subnets = var.no_of_subnets
  aws_vpc_cidr_block   = var.aws_vpc_cidr_block
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id  
  aws_vpc_instance_tenancy = var.aws_vpc_instance_tenancy
}

module "sg-elb" {
  source = "app.terraform.io/radammcorp/sg/aws"
  #aws_region = var.aws_region
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id    
  aws_vpc_id = module.vpc.aws_vpc_id
  name   = "sgelb"
  description = "security group for load balancer"

  ingress_with_cidr_blocks = [
      {
        rule = "https-443-tcp"
        cidr_blocks = "0.0.0.0/0"
      },  
      {
        rule = "http-80-tcp"
        cidr_blocks = "0.0.0.0/0"
      },         
  ]
}

module "sg-app" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    name   = "sgapp"   
    description = "security group for application"

    computed_ingress_with_source_security_group_id = [
        {
          rule = "http-8080-tcp"
          source_security_group_id = module.sg-elb.security_group_id
        }        
      ]
    number_of_computed_ingress_with_source_security_group_id = 1
      
  }

module "sg-db" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    name   = "sgdb"   
    description = "security group for database"
    computed_ingress_with_source_security_group_id = [
        {
          rule = "mysql-tcp"
          source_security_group_id = module.sg-elb.security_group_id
        }       
      ]
    number_of_computed_ingress_with_source_security_group_id = 1  
}  

module "sg-cache" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    name   = "sgcache"   
    description = "security group for cache"
    computed_ingress_with_source_security_group_id = [
        {
          rule = "memcached-tcp"
          source_security_group_id = module.sg-elb.security_group_id
        }       
      ]
    number_of_computed_ingress_with_source_security_group_id = 1      
} 

module "sg-message" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    name   = "sgmessage"   
    description = "security group for messaging"
    computed_ingress_with_source_security_group_id = [
        {
          rule = "rabbitmq-5672-tcp"
          source_security_group_id = module.sg-elb.security_group_id
        }        
      ]
    number_of_computed_ingress_with_source_security_group_id = 1      
} 

module "ec2key" {
  source = "app.terraform.io/radammcorp/ec2-key/aws"
	key_name   = var.key_name
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id   
}


/*

module "elb" {
  source = "app.terraform.io/radammcorp/elb/aws"
  #aws_region = var.aws_region
  aws_subnet_ids = module.vpc.aws_subnet_ids 
  aws_security_group_elb_id = module.sg.aws_security_group_elb_id
  lb_ssl_id = "1234"  
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id    
}

#module "route53" {
#  source = "app.terraform.io/radammcorp/route53/aws"
#  aws_region = var.aws_region
#  app_env   = var.app_env
#  app_name  = var.app_name  
#  app_id   = var.app_id  
#  aws_route53_zone_id = data.aws_route53_zone.selected.zone_id
#  aws_route53_record_name = var.aws_route53_record_name

#  # Adding to "dulastack." needs to be revied with service owner 
#  #aws_elb_dns_name = var.aws_elb_dns_name == "" ? "dummy-elb.us-east-1.elb.amazonaws.com" : "dualstack.${var.aws_elb_dns_name}"
#  aws_elb_dns_name = module.elb.aws_elb_dns_name #"dualstack.${module.elb.aws_elb_dns_name}"

#  # Passing defalut us-east-1 zone id to avoid apply error, logic needs to change later 
#  #aws_elb_zone_id = var.aws_elb_zone_id == "" ? "Z35SXDOTRQ7X7K" : var.aws_elb_zone_id
#  aws_elb_zone_id = module.elb.aws_elb_zone_id


#  repave_strategy = var.repave_strategy 
#  aws_route53_zone_name = var.aws_route53_zone_name
#  aws_vpc_id = module.vpc.aws_vpc_id
#}

*/




