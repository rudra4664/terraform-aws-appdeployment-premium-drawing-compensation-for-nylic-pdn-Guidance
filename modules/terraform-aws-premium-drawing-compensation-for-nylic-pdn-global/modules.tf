module "guidance_safe_green_instance_profile" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-instance-profile-windows"
  version = "1.1.9"
  tf_org  = "NYL-PROD"
  lob     = var.lob
  env     = var.env
  name    = "guidance-safe-green"
}
