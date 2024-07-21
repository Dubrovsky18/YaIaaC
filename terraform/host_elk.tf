resource "yandex_compute_instance" "elk" {
  name        = "elk"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.ssd_elk.id
  }

  network_interface {
    index = 0
    subnet_id = "${yandex_vpc_subnet.kit_subnet.id}"
    nat = true
  }

  metadata = {
    enable-oslogin = false
    serial-port-enable = 1
    ssh-keys = "ec2-user:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nusers:\n  - name: ec2-user\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
  }

  # provisioner "local-exec" {
  # }
}

resource "yandex_compute_disk" "ssd_elk" {
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = "fd8ncabquaiv1n49h9in"
  size = 20

  labels = {
    environment = "elkitoring"
  }
}

output "ip-elk-public" {
    value = yandex_compute_instance.elk.network_interface.0.nat_ip_address
}

output "ip-elk-private" {
    value = yandex_compute_instance.elk.network_interface.0.ip_address
}