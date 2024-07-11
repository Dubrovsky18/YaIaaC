terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.122.0"
    }
  }
}

resource "yandex_compute_instance" "salt_slave" {
  name        = var.name
  platform_id = var.platform_id
  zone        = var.zone
  
  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = var.disk_type
      size     = var.disk_size
    }
  }

  network_interface {
    index    = 1
    subnet_id = "${yandex_vpc_subnet.kit_subnet.id}"
    nat      = true
  }

  metadata = {
    enable-oslogin     = true
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
  #     "echo 'id: ${self.network_interface.0.ip_address}' > /etc/salt/minion.d/id.conf",
  #     "sudo sed -i 's/#master: salt/master: ${yandex_compute_instance.master.network_interface.0.ip_address}/' /etc/salt/minion",
  #     "sudo sed -i 's/#master_port: 4506/master_port: 4506/' /etc/salt/minion",
  #     "sudo sed -i 's/#user: root/user: root/' /etc/salt/minion",
  #     "sudo salt-key",
  #     "sudo systemctl restart salt-minion"
  #   ]
  # }
}


output "ip-slave-public" {
  value ="${yandex_compute_instance.salt_slave.network_interface.0.nat_ip_address}"
}

output "ip-slave-private" {
  value = "${yandex_compute_instance.salt_slave.network_interface.0.ip_address}"
}
