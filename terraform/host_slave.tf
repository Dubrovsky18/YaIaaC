resource "yandex_compute_instance" "slave" {
  name        = "slave"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.ssd_slave.id
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

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg",
  #     "echo 'deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main' | sudo tee /etc/apt/sources.list.d/salt.list",
  #     "sudo apt-get update && sudo apt-get upgrade'",
  #     "sudo apt-get install salt-master salt-ssh salt-syndic salt-cloud salt-api",
  #     "sudo systemctl enable salt-master --now",
  #     "sudo systemctl enable salt-syndic --now",
  #     "sudo systemctl enable salt-api --now",
  #     "echo 'master: ${yandex_compute_instance.master.network_interface.0.ip_address}' > /etc/salt/minion.d/master.conf",
  #     "echo 'id: ${yandex_compute_instance.slave.network_interface.0.ip_address}' > /etc/salt/minion.d/id.conf",
  #     "sudo sed -i 's/#master: salt/master: ${yandex_compute_instance.master.network_interface.0.ip_address}/' /etc/salt/minion",
  #     "sudo sed -i 's/#master_port: 4506/master_port: 4506/' /etc/salt/minion",
  #     "sudo sed -i 's/#user: root/user: root/' /etc/salt/minion",
  #     "sudo salt-key",
  #     "sudo systemctl restart salt-minion"
  #   ]
  # }
}

resource "yandex_compute_disk" "ssd_slave" {
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = "fd8qiisldh8geahpgicl"
  size = 17

  labels = {
    environment = "saltstack"
  }
}

output "ip-slave-public" {
    value = yandex_compute_instance.slave.network_interface.0.nat_ip_address
}

output "ip-slave-private" {
    value = yandex_compute_instance.slave.network_interface.0.ip_address
}