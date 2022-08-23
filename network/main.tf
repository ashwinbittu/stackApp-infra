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
  name   = "sg-elb"
  description = "security group for load balancer"

  ingress_with_cidr_blocks = [
      {
        from_port   = 8080
        to_port     = 8090
        protocol    = "tcp"
        description = "User-service ports"
        cidr_blocks = "10.10.0.0/16"
      },
      {
        rule        = "postgresql-tcp"
        cidr_blocks = "0.0.0.0/0"
      },
    ]


/*  ingress_with_cidr_blocks = [
    {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },    
  ]*/

}

/*

module "sg-app" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    aws_sg_name   = "sg-app"   
    aws_sg_description = "security group for application"
    ingress_with_cidr_blocks = [
        {
            from_port   = 8080
            to_port     = 8080
            protocol    = "tcp"
            security_groups = [module.sg-elb.aws_security_group_instances_id]
        },    
      ]       
  }

module "sg-db" {
  source = "app.terraform.io/radammcorp/sg/aws"
  #aws_region = var.aws_region
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id    
  aws_vpc_id = module.vpc.aws_vpc_id
  aws_sg_name   = "sg-db"  
  aws_sg_description = "security group for db"
  ingress_with_cidr_blocks = [
      {
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = [module.sg-app.aws_security_group_instances_id]
      },    
    ]    
}  

module "sg-cache" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    aws_sg_name   = "sg-cache"    
    aws_sg_description = "security group for cache"
    ingress_with_cidr_blocks = [
        {
            from_port   = 11211
            to_port     = 11211
            protocol    = "tcp"
            security_groups = [module.sg-app.aws_security_group_instances_id]
        },    
      ]     
} 

module "sg-message" {
    source = "app.terraform.io/radammcorp/sg/aws"
    #aws_region = var.aws_region
    app_env   = var.app_env
    app_name   = var.app_name  
    app_id   = var.app_id      
    aws_vpc_id = module.vpc.aws_vpc_id
    aws_sg_name   = "sg-message"    
    aws_sg_description = "security group for message"
    ingress_with_cidr_blocks = [
        {
            from_port   = 5672
            to_port     = 5672
            protocol    = "tcp"
            security_groups = [module.sg-app.aws_security_group_instances_id]
        },    
      ]     
} 

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

module "ec2key" {
  source = "app.terraform.io/radammcorp/ec2-key/aws"
  #aws_region = var.aws_region
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id 
  path_to_public_key = var.path_to_public_key   
}

*/
