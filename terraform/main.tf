
module "network" {
  source      = "./modules/network"
  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
}

module "vm" {
  source            = "./modules/vm"
  project_id        = var.project_id
  region            = var.region
  zone              = var.zone
  instance_name     = "devops-vm"
  machine_type      = "e2-micro"
  boot_disk_size_gb = 20
  network           = module.network.vpc_name
  subnetwork        = module.network.subnet_self_link
  ssh_user          = var.ssh_user
  ssh_public_key    = var.ssh_public_key
  ssh_port          = var.ssh_port
  allowed_ssh_cidr  = var.allowed_ssh_cidr
}
