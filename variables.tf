variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
  default     = "APP-1386"
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build, by AWS Account."

  type = map(map(object({
    availability_zone   = string
    name                = string
    root_volume_size    = number
    security_groups     = list(string)
    strategic_ami_build = string
    strategic_os_type   = string

    additional_volumes = map(object({
      device_name = string
      size        = number
      snapshot_id = optional(string)
    }))
  })))

  default = {
    "813144408162" = { # nyl-securityc4e-qa
      securityc4e_qa_guidance_safe_node_i_1 = {
        availability_zone   = "us-east-1a"
        name                = "securityc4e-qa-guidance-safe-node-i-1-green"
        root_volume_size    = 250
        security_groups     = ["vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdf = {
            device_name = "/dev/sdf"
            size        = 4096
          }
        }
      }

      securityc4e_qa_guidance_safe_node_i_2 = {
        availability_zone   = "us-east-1b"
        name                = "securityc4e-qa-guidance-safe-node-i-2-green"
        root_volume_size    = 250
        security_groups     = ["vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdf = {
            device_name = "/dev/sdf"
            size        = 4096
          }
        }
      }
    }

    "910663996468" = { # nyl-securityc4e-prod
      securityc4e_prod_guidance_safe_node_i_1 = {
        availability_zone   = "us-east-1b"
        name                = "securityc4e-prod-guidance-safe-node-i-1-green"
        root_volume_size    = 250
        security_groups     = ["cyberark_instance_access", "guidance_safe_instance_access", "vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdf = {
            device_name = "/dev/sdf"
            size        = 4096
          }
        }
      }

      securityc4e_prod_guidance_safe_node_i_2 = {
        availability_zone   = "us-east-1a"
        name                = "securityc4e-prod-guidance-safe-node-i-2-green"
        root_volume_size    = 250
        security_groups     = ["cyberark_instance_access", "guidance_safe_instance_access", "vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdf = {
            device_name = "/dev/sdf"
            size        = 4096
          }
        }
      }
    }
  }
}

variable "lob" {
  description = "Line of Business."
  type        = string
  default     = "securityc4e"
}

variable "tags" {
  description = "Application-specific tags merged on top of mandatory governance tags."
  type        = map(string)
}
