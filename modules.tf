module "global" {
  source = "./modules/terraform-aws-global"
  env    = var.env
  lob    = var.lob

  providers = {
    aws = aws.us-east-1
  }
}

module "regional_us_east_1" {
  source                = "./modules/terraform-aws-regional"
  appid                 = var.appid
  env                   = var.env
  green_instances       = var.green_instances
  instance_profile_name = module.global.instance_profile_name
  lob                   = var.lob
  tags                  = var.tags

  providers = {
    aws = aws.us-east-1
  }
}
