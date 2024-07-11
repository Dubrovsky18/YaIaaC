module "salt_slave_1" {
  source = "./modules/salt_minion"
  name = "slave-1"
}

module "salt_slave_2" {
  source = "./modules/salt_minion"
  name = "slave-2"
}