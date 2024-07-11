resource "yandex_vpc_network" "kit_network" {
  name = "kit-network"
}

resource "yandex_vpc_subnet" "kit_subnet" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.kit_network.id}"
  v4_cidr_blocks = ["10.250.240.0/24"]
}

