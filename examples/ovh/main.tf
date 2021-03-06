terraform {
  required_version = ">= 0.12.21"
}

module "ovh" {
  source = "git::https://github.com/ComputeCanada/magic_castle.git//ovh"

  cluster_name = "phoenix"
  domain       = "calculquebec.cloud"
  image        = "CentOS-7-x64-2019-07"
  nb_users     = 10

  instances = {
    mgmt  = { type = "s1-2", count = 1 },
    login = { type = "s1-2", count = 1 },
    node  = [
       { type = "s1-2", count = 1 },
    ]
  }

  storage = {
    type         = "nfs"
    home_size    = 100
    project_size = 50
    scratch_size = 50
  }

  public_keys = [file("~/.ssh/id_rsa.pub")]

  # Shared password, randomly chosen if blank
  guest_passwd = ""

}

output "sudoer_username" {
  value = module.ovh.sudoer_username
}

output "guest_usernames" {
  value = module.ovh.guest_usernames
}

output "guest_passwd" {
  value = module.ovh.guest_passwd
}

output "public_ip" {
  value = module.ovh.ip
}

## Uncomment to register your domain name with CloudFlare
# module "dns" {
#   source           = "git::https://github.com/ComputeCanada/magic_castle.git//dns/cloudflare"
#   name             = module.ovh.cluster_name
#   domain           = module.ovh.domain
#   email            = "you@example.com"
#   public_ip        = module.ovh.ip
#   login_ids        = module.ovh.login_ids
#   rsa_public_key   = module.ovh.rsa_public_key
#   ssh_private_key  = module.openstack.ssh_private_key
#   sudoer_username  = module.ovh.sudoer_username
# }

## Uncomment to register your domain name with Google Cloud
# module "dns" {
#   source           = "git::https://github.com/ComputeCanada/magic_castle.git//dns/gcloud"
#   email            = "you@example.com"
#   project          = "your-project-name"
#   zone_name        = "you-zone-name"
#   name             = module.ovh.cluster_name
#   domain           = module.ovh.domain
#   public_ip        = module.ovh.ip
#   login_ids        = module.ovh.login_ids
#   rsa_public_key   = module.ovh.rsa_public_key
#   ssh_private_key  = module.openstack.ssh_private_key
#   sudoer_username  = module.ovh.sudoer_username
# }

# output "hostnames" {
# 	value = module.dns.hostnames
# }
