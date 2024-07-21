resource "yandex_compute_instance" "nginx2" {
  name        = "nginx2"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.ssd_nginx2.id
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
  #   command = "apt-get install nginx && wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz && tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz  && wget https://github.com/sysulq/nginx-vts-exporter/releases/download/v0.10.8/nginx-vtx-exporter_0.10.8_linux_amd64.tar.gz && tar xvfz nginx-vtx-exporter_0.10.8_linux_amd64.tar.gz && cp node_exporter-1.8.2.linux-amd64/node_exporter nginx-vtx-exporter_0.10.8_linux_amd64/nginx-vts-exporter /usr/local/bin"
  # }
}

resource "yandex_compute_disk" "ssd_nginx2" {
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = "fd8ncabquaiv1n49h9in"
  size = 20

  labels = {
    environment = "monitoring"
  }
}

output "ip-nginx2-public" {
    value = yandex_compute_instance.nginx2.network_interface.0.nat_ip_address
}

output "ip-nginx2-private" {
    value = yandex_compute_instance.nginx2.network_interface.0.ip_address
}