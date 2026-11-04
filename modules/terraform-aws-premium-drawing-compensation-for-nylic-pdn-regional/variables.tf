variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build by environment."

  type = map(map(object({
    availability_zone   = string
    name                = string
    root_volume_size    = number
    security_groups     = list(string)
    strategic_ami_build = string
    strategic_os_type   = string
    private_ip          = optional(string)

    additional_volumes = map(object({
      device_name = string
      size        = number
      snapshot_id = optional(string)
    }))
  })))
}

variable "instance_profile_name" {
  description = "Name of the instance profile, provided by the global module."
  type        = string
}

variable "lob" {
  description = "Line of Business."
  type        = string
}

variable "tags" {
  description = "Application-specific tags merged on top of mandatory governance tags."
  type        = map(string)
}
