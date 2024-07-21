resource "yandex_compute_instance" "mon" {
  name        = "mon"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.ssd_mon.id
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

resource "yandex_compute_disk" "ssd_mon" {
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = "fd8ncabquaiv1n49h9in"
  size = 20

  labels = {
    environment = "monitoring"
  }
}

output "ip-mon-public" {
    value = yandex_compute_instance.mon.network_interface.0.nat_ip_address
}

output "ip-mon-private" {
    value = yandex_compute_instance.mon.network_interface.0.ip_address
}