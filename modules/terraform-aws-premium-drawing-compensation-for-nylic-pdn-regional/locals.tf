locals {
  green_instances         = lookup(var.green_instances, data.aws_caller_identity.current.account_id, {})
  subnet_ids_by_az        = { for subnet in data.aws_subnet.compute : subnet.availability_zone => subnet.id }
  vpc_cidrs               = data.aws_vpc.current.cidr_block_associations[*].cidr_block
  current_security_groups = local.security_groups[data.aws_caller_identity.current.account_id]

  security_group_ids = {
    for name, sg in module.security_groups :
    name => sg.resources.aws_security_group.id
  }

  security_groups = {
    "813144408162" = {
      vpc_access = {
        description = "Allows access between resources within VPC CIDR"
      }
    }

    "910663996468" = {
      cyberark_instance_access = {
        description = "Cyberark SG to allow few ports for cyberark access"
      }

      guidance_safe_instance_access = {
        description = "SG for Guidance Safe Application"
      }

      vpc_access = {
        description = "Allows access between resources within VPC CIDR"
      }
    }
  }

  cyberark_cidrs = [
    "10.41.16.148/32",
    "10.41.24.199/32",
    "10.6.0.0/19",
    "10.7.0.0/19",
    "10.73.17.67/32",
    "10.73.24.117/32",
  ]

  cyberark_rdp_cidrs = [
    "10.162.32.230/32",
    "10.162.32.231/32",
    "10.184.6.0/24",
    "10.186.29.0/24",
    "10.188.29.0/24",
    "10.41.16.143/32",
    "10.41.16.144/32",
    "10.41.16.145/32",
    "10.41.16.148/32",
    "10.41.16.53/32",
    "10.41.16.55/32",
    "10.41.20.47/32",
    "10.41.20.48/32",
    "10.41.24.198/32",
    "10.41.24.199/32",
    "10.41.28.41/32",
    "10.6.0.0/19",
    "10.7.0.0/19",
    "10.73.16.103/32",
    "10.73.17.38/32",
    "10.73.17.59/32",
    "10.73.17.60/32",
    "10.73.17.61/32",
    "10.73.17.67/32",
    "10.73.20.100/32",
    "10.73.20.99/32",
    "10.73.24.116/32",
    "10.73.24.117/32",
    "10.73.28.21/32",
    "10.73.32.19/32",
    "10.73.32.30/32",
    "10.73.36.33/32",
  ]

  internal_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]

  cyberark_ingress_rules = {
    rdp = {
      protocol    = "tcp"
      from_port   = 3389
      to_port     = 3389
      description = "CyberArk RDP"
      cidrs       = local.cyberark_rdp_cidrs
    }

    rpc = {
      protocol    = "tcp"
      from_port   = 135
      to_port     = 135
      description = "CyberArk RPC endpoint mapper"
      cidrs       = local.cyberark_cidrs
    }

    rpc-high = {
      protocol    = "tcp"
      from_port   = 1024
      to_port     = 65535
      description = "CyberArk dynamic RPC ports"
      cidrs       = local.cyberark_cidrs
    }

    smb = {
      protocol    = "tcp"
      from_port   = 445
      to_port     = 445
      description = "CyberArk SMB"
      cidrs       = local.cyberark_cidrs
    }
  }

  guidance_safe_ingress_rules = {
    app-4445 = {
      protocol    = "tcp"
      from_port   = 4445
      to_port     = 4445
      description = "Guidance Safe application port 4445"
      cidrs       = local.internal_cidrs
    }

    app-8443 = {
      protocol    = "tcp"
      from_port   = 8443
      to_port     = 8443
      description = "Guidance Safe application port 8443"
      cidrs       = local.internal_cidrs
    }
  }

  vpc_access_ingress_rules = {
    all-traffic = {
      protocol    = "-1"
      from_port   = null
      to_port     = null
      description = "All traffic within VPC CIDR"
      cidrs       = local.vpc_cidrs
    }
  }

  cyberark_ingress = merge([
    for key, rule in local.cyberark_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  guidance_safe_ingress = merge([
    for key, rule in local.guidance_safe_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  vpc_access_ingress = merge([
    for key, rule in local.vpc_access_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)
}
