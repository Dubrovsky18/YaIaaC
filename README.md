# Task

В этом задании вам предстоит поработать с утилитами IaaC, про которые мы говорили на лекции.

### [Что нужно сделать](https://tracker.yandex.ru/pages/my?skipPromo=1#chto-nuzhno-sdelat)Что нужно сделать

1. С помощью terraform создать в Яндекс Облаке две виртуалки (2 ядра, 4 гигабайта ОЗУ):
    1. Мастер системы управления конфигурациями,
    2. Клиент/миньон системы управления конфигурациями,
2. Выбрать систему управления конфигурациями и с ее помощью настроить nginx, который раздает статическую картинку с китом.

### [Ожидаемый результат](https://tracker.yandex.ru/pages/my?skipPromo=1#ozhidaemyj-rezultat)Ожидаемый результат

- С миньона должна раздаваться статическая картинка
- Все настройки должны быть произведены не вручную, а с помощью системы управления конфигурациями
- Бонусом будет написать конфигурации так, чтобы их было легко масштабировать, например, на 100 виртуалок (сами виртуалки заводить и масштабировать не нужно!)
- Вы можете выбрать любую (или любые, если нужно несколько) системы: ansible, chef, puppet, salt, etc.

В качестве решения нужно приложить получившиеся файлы IaaC и текстовое описание проделанной работы.

# Terraform

https://github.com/Dubrovsky18/YaIaaC

## 1. Создание рабочих станций

Используем terraform. Для начала нужно обратиться к документации

https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart

https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs

Регистрируем нашего `providers.tf`

[data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACCUlEQVR4AeyWA+wcQRhHa9u2EdQ+1e3sVlPtMW3YOHVQu1ER1ratoLbtdmdrG/lPf4ev5mmqJO9833vrTSWlDOHWxWQPu1ma3ieLDwGauAleGpo5kvPb2VQFyDCWhRAfvk2tJuAD+7FpGqgMIOZ11UVxhQFAF8v9rW8X4vxkhlilTufakr8cYGhihUcTXbF/XPAyoUcjbtZsZRGHY9Usu33VrugDPny2ycduVP0ZcatW6zJCPBDiJ0Da7av3xBpAvAETOb+e51tyh2NlB0gvAUnELYDwMHHPo4tenMu0NK9JkxXVIdpG0h8GeJnVCMMORhHwAd08jjklbLZVIyB6C+RPBRCDB8s0bt3qiWG3ogoI0u66HZIjQP5yAGG0upfDo1njsce/VhJAeNubFRCxRlkAgYiW2NFGKQsggtcFSJ7EGmCzrZ4aVUCg1Y38XfULxbFGZkCWEkXAechZcFZUAaFNwMQpj2616N7ueh0Id/9kwGOI+3C+iK4j0QeQCK9Xd2ltVjA0y4334hsBKcHV7XKtLEgz4hVAvMJ+MS54lfQwazjev/goYIfDsaYm/TdRAcRNDxM9fO1ulQ3eN9hsaxrTf5IVQJvlgNHBLBb8rZIA2gf+2oD/AXTP8FxVAEWU8DCxQFnAhwuT1RjCQwoCvnEHpSKA4PxiTrqDUhLwbsgtqCivZ/Kk6AEA1jXCixlx4SgAAAAASUVORK5CYII=](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACCUlEQVR4AeyWA+wcQRhHa9u2EdQ+1e3sVlPtMW3YOHVQu1ER1ratoLbtdmdrG/lPf4ev5mmqJO9833vrTSWlDOHWxWQPu1ma3ieLDwGauAleGpo5kvPb2VQFyDCWhRAfvk2tJuAD+7FpGqgMIOZ11UVxhQFAF8v9rW8X4vxkhlilTufakr8cYGhihUcTXbF/XPAyoUcjbtZsZRGHY9Usu33VrugDPny2ycduVP0ZcatW6zJCPBDiJ0Da7av3xBpAvAETOb+e51tyh2NlB0gvAUnELYDwMHHPo4tenMu0NK9JkxXVIdpG0h8GeJnVCMMORhHwAd08jjklbLZVIyB6C+RPBRCDB8s0bt3qiWG3ogoI0u66HZIjQP5yAGG0upfDo1njsce/VhJAeNubFRCxRlkAgYiW2NFGKQsggtcFSJ7EGmCzrZ4aVUCg1Y38XfULxbFGZkCWEkXAechZcFZUAaFNwMQpj2616N7ueh0Id/9kwGOI+3C+iK4j0QeQCK9Xd2ltVjA0y4334hsBKcHV7XKtLEgz4hVAvMJ+MS54lfQwazjev/goYIfDsaYm/TdRAcRNDxM9fO1ulQ3eN9hsaxrTf5IVQJvlgNHBLBb8rZIA2gf+2oD/AXTP8FxVAEWU8DCxQFnAhwuT1RjCQwoCvnEHpSKA4PxiTrqDUhLwbsgtqCivZ/Kk6AEA1jXCixlx4SgAAAAASUVORK5CYII=)

```yaml
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.122.0"
    }
  }
}

locals {
  project = var.folder_id
  region  = var.cloud_id
}

provider "yandex" {
  service_account_key_file = "authorized_key.json" 
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  zone                     = "ru-central1-a"
}
```

Насчет folder_id и cloud_id - Можно записать их в переменные, чтобы они не светились. 

```bash
export TF_VAR_folder_id="****"
export TF_VAR_cloud_id="*****"
```

Или добавить эти значения в `varibles.tf`

```
variable "cloud_id" {
  type        = "string"
  description = "your cloud id"
  default =  "****"
}

variable "folder_id" {
  type        = "string"
  description = "your folder id"
  default  = "****"
}
```

Регистрируем нашу сеть `vps.tf`

```yaml
resource "yandex_vpc_network" "kit_network" {
  name = "kit-network"
}

resource "yandex_vpc_subnet" "kit_subnet" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.kit_network.id}"
  v4_cidr_blocks = ["10.250.240.0/24"]
}
```

Прописываем команду 

```bash
terraform init
```

Мы проинициализировали нашу папку с `terraform`, а теперь начинаем создавать наши машины

`host_master.tf`

```yaml
resource "yandex_compute_instance" "master" {
  name        = "master"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.ssd_master.id
  }

  network_interface {
    index  = 0
    subnet_id = "${yandex_vpc_subnet.kit_subnet.id}"
    nat = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ec2-user\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
    enable-oslogin = false
    serial-port-enable = 1
    ssh-keys = "ec2-user:${file("~/.ssh/id_rsa.pub")}"

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
  #     "echo 'interface: ${self.network_interface.0.ip_address}' > /etc/salt/master.d/network.conf",
  #     "echo 'ret_port: 4506' >> /etc/salt/master.d/network.conf",
  #     "echo 'publish_port: 4505' >> /etc/salt/master.d/network.conf",
  #     "sudo salt-key",
  #     "sudo systemctl restart salt-master"
  #     ]
  #     }
}

resource "yandex_compute_disk" "ssd_master" {
  type = "network-ssd"
  zone = "ru-central1-a"
  size = 20
  image_id = "fd8qiisldh8geahpgicl"

  labels = {
    environment = "saltstack"
  }
}

output "ip-master-public" {
    value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

output "ip-master-privat" {
    value = yandex_compute_instance.master.network_interface.0.ip_address
}
```

`host_slave.tf`

```yaml
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
    index = 1
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
```

> Машины уже создались, просто показываю, как выводиться общий интерфейс и ip адреса, которые я прописал в `output`
> 

![Screenshot 2024-07-10 at 12.47.21 AM.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/000c5287-ef44-498c-b5fa-0a1b16456042/1a451012-8687-493d-91a5-e1241a06c538/Screenshot_2024-07-10_at_12.47.21_AM.png)

> Установить `saltstack` в `terraform` можно сразу через provisioner. Я покажу как устанавливать в ручную saltstack.
> 

```
provisioner "local-exec" {
  command = ""
}
provisioner "local-exec" {
	inline = ["",
	""
	]
} 
```

> Также есть возможность установить saltstack на машины через ansible
> 

## 2. Масштабирования

В Terraform можно использовать модели и создать несколько машин, меняя в них только название. Например в корневой директории файл

`main_host_slaves.tf`

```bash
module "salt_slave_1" {
  source = "./modules/salt_minion"
  name = "slave-1"
}

module "salt_slave_2" {
  source = "./modules/salt_minion"
  name = "slave-2"
}
```

Создаем папку modules/salt_minion

И прописываем основные правила создания машины

```bash
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
```

Также прописываем наши `variables.tf`

```bash
variable "name" {
  description = "The name of the instance."
  type        = string
  default = "slave-1"
}

variable "platform_id" {
  description = "The platform ID of the instance."
  type        = string
  default     = "standard-v1"
}

variable "zone" {
  description = "The zone of the instance."
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "The number of CPU cores."
  type        = number
  default     = 2
}

variable "memory" {
  description = "The amount of memory in GB."
  type        = number
  default     = 4
}

variable "image_id" {
  description = "The ID of the boot disk."
  type        = string
  default = "fd8qiisldh8geahpgicl"
}

variable "disk_type" {
  description = "The type of the boot disk."
  type        = string
  default = "network-ssd"
}

variable "disk_size" {
  description = "The size of the boot disk."
  type        = string
  default = "20"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key."
  type        = string
  default = "~/.ssh/id_rsa.pub"
}
```

И нужно указать модулям -  в какой сети им быть

```bash
resource "yandex_vpc_network" "kit_network" {
  name = "kit-network"
}

resource "yandex_vpc_subnet" "kit_subnet" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.kit_network.id}"
  v4_cidr_blocks = ["10.250.240.0/24"]
}
```

После этого мы инициализируем наш terraform и можем создавать 100 ВМ с одинаковыми характеристиками

```bash
  # module.salt_slave_1.yandex_compute_instance.salt_slave will be created
  + resource "yandex_compute_instance" "salt_slave" {
  ...
  # module.salt_slave_2.yandex_compute_instance.salt_slave will be created
  + resource "yandex_compute_instance" "salt_slave" {
  ...
```

# SaltStack

## 1. Начинаем установку

Заходим на страничку с документацией

https://docs.saltproject.io/salt/install-guide/en/latest/

Первым установим ключи и  url с репозиторием. После мы обновимся

```bash
sudo curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main" | sudo tee /etc/apt/sources.list.d/salt.list
sudo apt-get update && sudo apt-get upgrade
```

Дальше выполняем на `master` установку необходимых компонентов и активизируем `daemons` (**службы)**

```bash
sudo apt-get install salt-master salt-ssh salt-syndic salt-cloud salt-api
sudo systemctl enable salt-master --now
sudo systemctl enable salt-syndic --now
sudo systemctl enable salt-api --now
```

Тоже самое (только `salt-master` → `salt-minion`) повторяем на агенте

```bash
sudo apt-get install salt-minion salt-ssh salt-syndic salt-cloud salt-api
sudo systemctl enable salt-minion --now
sudo systemctl enable salt-syndic --now
sudo systemctl enable salt-api --now
```

### На `Master`

Настроим конфигурации сети для мастера

`/etc/salt/master.d/network.conf`

```bash
# The network interface to bind to
interface: <IP MASTER>
# The Request/Reply port
ret_port: 4506
# The port minions bind to for commands, aka the publish port
publish_port: 4505
```

Генерируем наши ключи

```bash
salt-key
```

Перезапустим нашу службу

```bash
sudo systemctl restart salt-master
```

### На `Minion`

Устанавливаем конфиги для установки связи с мастером

```bash
echo "master: <IP MASTER>" > /etc/salt/minion.d/master.conf
```

Инициализируем нашего агента (выбираем ему название)

```bash
echo "id: <NAME-AGENT>" > /etc/salt/minion.d/id.conf
```

Вставим (раскомментируем) необходимые строки для конфигурации

```bash
sudo vim /etc/salt/minion
```

```bash
master: <IP MASTER>
master_port: 4506
user: root
```

Генерируем ключи

```bash
salt-key
```

Перезапустим нашу службу

```bash
sudo systemctl restart salt-minion
```

### На `Master`

Проверяем что мастер получил ключи агента

```bash
 salt-key -L
```

```bash
Accepted Keys:
<NAME-AGENT>
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

Если какой-то ключи не применился, можно попробовать его применить

```bash
# Для всех
salt-key -A
# Для определенного
salt-key -a <NAME-AGENT>
```

Проверим связь с агентами

```bash
# Для всех
sudo salt '*' test.ping
# Для определнного 
sudo salt <NAME-AGENT> test.ping
```

Если получили положительный ответ → Мы настроили наш **saltstack**

```bash
slave:
    True
```

## 2. Создадим template для установки nginx

Если у вас есть несколько состояний, которые вы хотите применять к разным minion, вы можете использовать топ файл для организации этих состояний.

1. **Создайте топ файл**:
    
    ```bash
    sudo vim /srv/salt/top.sls
    ```
    
    `top.sls`
    
    ```bash
    base:
    # Или можно использовать '*' - применять для всех
    # несколько агентов можно перечислять через запятую
      '<NAME-AGENT':
        - nginx
    ```
    
2. Создадим папку где будут лежать наши конфигурационные файлы для nginx и непосредственно сам template
    
    ```bash
    sudo mkdir -p /srv/salt/nginx
    ```
    
    `/srv/salt/nginx.sls`
    
    ```bash
    # Установка nginx
    nginx:
      pkg:
        - installed
    
    # Запуск службы
      service:
        - running
        - enable: True
    
    # Запуск службы
    nginx_service:
      service.running:
        - name: nginx
        - enable: True
        - watch:
          - pkg: nginx
          - file: /etc/nginx/nginx.conf
          - file: /var/www/html/index.html
    
    # Отправка файла /etc/nginx/nginx.conf на удаленный хост
    /etc/nginx/nginx.conf:
      file.managed:
        - source: salt://nginx/nginx.conf # путь к файлу на мастер-хосте
        - user: root
        - group: root
        - mode: 644
    
    # Отправка файла index.html на удаленный хост
    /var/www/html/index.html:
      file.managed:
        - source: salt://nginx/index.html # путь к файлу на мастер-хосте
        - user: www-data
        - group: www-data
        - mode: 644
    ```
    
    `/srv/salt/nginx/nginx.conf` 
    
    ```bash
    user www-data;
    worker_processes auto;
    pid /run/nginx.pid;
    include /etc/nginx/modules-enabled/*.conf;
     
    events {
            worker_connections 512;
    }
     
    http {
     
            sendfile on;
            tcp_nopush on;
            tcp_nodelay on;
            keepalive_timeout 65;
            types_hash_max_size 2048;
     
            include /etc/nginx/mime.types;
            default_type application/octet-stream;
     
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
            ssl_prefer_server_ciphers on;
     
            access_log /var/log/nginx/access.log;
            error_log /var/log/nginx/error.log;
     
            gzip on;
     
            include /etc/nginx/conf.d/*.conf;
            include /etc/nginx/sites-enabled/*;
    }
    ```
    
    `/srv/salt/nginx/index.html`
    
    ```bash
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>
    <img src="https://i.ibb.co/bHL2DT9/static-image.png" alt="static-image" border="0">
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>
    
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    ```
    

Примените состояние ко всем minion:

```bash
# Если вы хотите применить состояние только к определённому minion, замените '*' на имя minion.
sudo salt '*' state.apply nginx
```

Результат работы:

![Screenshot 2024-07-10 at 12.37.20 AM.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/000c5287-ef44-498c-b5fa-0a1b16456042/9daad754-3a59-44a2-999a-bdd2a1b6cdcf/Screenshot_2024-07-10_at_12.37.20_AM.png)

![Screenshot 2024-07-10 at 12.37.06 AM.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/000c5287-ef44-498c-b5fa-0a1b16456042/0375b99c-eac1-4e08-addd-7bd86701e483/Screenshot_2024-07-10_at_12.37.06_AM.png)

![Screenshot 2024-07-11 at 1.55.26 AM.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/000c5287-ef44-498c-b5fa-0a1b16456042/072162dd-44d4-479b-b326-d1c4049d146b/Screenshot_2024-07-11_at_1.55.26_AM.png)

Почитав BestPractics для SaltStack рекомендуется делать все конфигурации в /srv/salt

Поэтому для просты я сделал link в домашнюю директорию. Также стоит дать права для работа с файлами

```bash
ln -s /srv/salt/ .
```

# Puppet

## 1: Установка Puppet Master

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install puppetserver
```

Настроем параметры Puppet Server:

Откройте файл `/etc/default/puppetserver` и настройте параметры памяти. Например:

```bash
JAVA_ARGS="-Xms512m -Xmx512m"
```

Разрешаем доступ к порту в брандмауэре:

Порт 8140 (для Puppet) открыты:

```bash
sudo ufw allow 8140
```

Настройка `puppet.conf` на Puppet Master

`/etc/puppetlabs/puppet/puppet.conf`

```
[main]
certname = <HOSTNAME-MASTER>
server = <HOSTNAME-MASTER>

[master]
dns_alt_names = puppet,<HOSTNAME-MASTER>

```

Включаем Puppet Server:

```bash
sudo systemctl enable puppetserver --now
```

## 2.  Установка Puppet Agent на агентском сервере (Slave)

Установим Puppet Agent:

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install puppet-agent
```

Настройка Puppet Agent

 `/etc/puppetlabs/puppet/puppet.conf`

```
[main]
certname = <HOSTNAME-AGENT> 
server = <HOSTNAME-MASTER> 
environment = production
runinterval = 1h
```

Включаем Puppet Agent:

```bash
sudo systemctl enable puppet --now
```

## 3: Подписание сертификатов

Запустите Puppet Agent вручную для инициалиции запроса сертификата:

```bash
sudo /opt/puppetlabs/bin/puppet agent --test
```

```bash
Info: Creating a new RSA SSL key for fhmr3jqrruvnph42jevc.auto.internal
Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for fhmr3jqrruvnph42jevc.auto.internal
Info: Certificate Request fingerprint (SHA256): EF:AE:49:5C:5E:C2:43:9C:BF:67:F9:56:94:46:D3:FB:F8:18:5B:8C:2E:91:32:1E:88:1F:3C:30:69:A6:E6:4D
Info: Certificate for fhmr3jqrruvnph42jevc.auto.internal has not been signed yet
Couldn't fetch certificate from CA server; you might still need to sign this agent's certificate (fhmr3jqrruvnph42jevc.auto.internal).
Exiting now because the waitforcert setting is set to 0.
```

Подпишим сертификат на мастере. Проверяем список ожидающих сертификатов:

```bash
sudo /usr/bin/puppetserver ca list
```

```bash
Requested Certificates:
    fhmr3jqrruvnph42jevc.auto.internal       (SHA256)  EF:AE:49:5C:5E:C2:43:9C:BF:67:F9:56:94:46:D3:FB:F8:18:5B:8C:2E:91:32:1E:88:1F:3C:30:69:A6:E6:4D
```

Подписываем сертификат:

```bash
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname <HOSTNAME>
```

## 4: Проверка подключения

Запустим Puppet Agent снова для проверки подключения:

```bash
sudo /opt/puppetlabs/bin/puppet agent --test
```

```bash
Info: Using environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Notice: /File[/var/cache/puppet/lib/puppet]/ensure: created
Notice: /File[/var/cache/puppet/lib/puppet/provider]/ensure: created
Notice: /File[/var/cache/puppet/lib/puppet/provider/mailalias]/ensure: created
Notice: /File[/var/cache/puppet/lib/puppet/provider/mailalias/aliases.rb]/ensure: defined content as '{sha256}36f6b8f04daace6c200261e9009424a45276cb880d5a48c2d186890ed32ffd47'
Notice: /File[/var/cache/puppet/lib/puppet/type]/ensure: created
Notice: /File[/var/cache/puppet/lib/puppet/type/mailalias.rb]/ensure: defined content as '{sha256}dddd3956b653e978ea3d19ac5da486cc20fc856e909e9c6af64b12f6c83a3424'
Notice: Requesting catalog from fhmqqnhodvq0299opvdb.auto.internal:8140 (127.0.1.1)
Notice: Catalog compiled by fhmqqnhodvq0299opvdb.auto.internal
Info: Caching catalog for fhmqqnhodvq0299opvdb.auto.internal
Info: Applying configuration version '1720591039'
Info: Creating state file /var/cache/puppet/state/state.yaml
Notice: Applied catalog in 0.02 seconds
```

Если все прошло успешно, агент должен подключиться к мастеру и применить конфигурации.

# Ansible

Вариант маштабирования можно использовать ansible.

### Файлы роли `salt_master`

### `roles/salt_master/tasks/main.yml`

```yaml
---
- name: Add SaltStack GPG key
  ansible.builtin.apt_key:
    url: https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
    keyring: /etc/apt/keyrings/salt-archive-keyring-2023.gpg
  become: true

- name: Add SaltStack repository
  ansible.builtin.apt_repository:
    repo: "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main"
    state: present
    filename: salt.list
  become: true

- name: Update apt cache
  apt:
    update_cache: yes
  become: true

- name: Install Salt Master components
  apt:
    name:
      - salt-master
      - salt-ssh
      - salt-syndic
      - salt-cloud
      - salt-api
    state: present
  become: true

- name: Enable and start Salt Master services
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
  loop:
    - salt-master
    - salt-syndic
    - salt-api
  become: true

- name: Configure Salt Master network settings
  ansible.builtin.template:
    src: network.conf.j2
    dest: /etc/salt/master.d/network.conf
  become: true

- name: Restart Salt Master service
  systemd:
    name: salt-master
    state: restarted
  become: true

```

### `roles/salt_master/templates/network.conf.j2`

```
# The network interface to bind to
interface: {{ master_ip }}
# The Request/Reply port
ret_port: 4506
# The port minions bind to for commands, aka the publish port
publish_port: 4505
```

### `roles/salt_master/vars/main.yml`

```yaml
master_ip: "{{ ansible_default_ipv4.address }}"
```

### Файлы роли `salt_minion`

### `roles/salt_minion/tasks/main.yml`

```yaml
---
- name: Add SaltStack GPG key
  ansible.builtin.apt_key:
    url: https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
    keyring: /etc/apt/keyrings/salt-archive-keyring-2023.gpg
  become: true

- name: Add SaltStack repository
  ansible.builtin.apt_repository:
    repo: "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main"
    state: present
    filename: salt.list
  become: true

- name: Upgrade all packages
  apt:
    upgrade: dist
  become: true

- name: Install Salt Minion components
  apt:
    name:
      - salt-minion
      - salt-ssh
      - salt-syndic
      - salt-cloud
      - salt-api
    state: present
  become: true

- name: Enable and start Salt Minion services
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
  loop:
    - salt-minion
    - salt-syndic
    - salt-api
  become: true

- name: Configure Salt Minion master settings
  ansible.builtin.template:
    src: master.conf.j2
    dest: /etc/salt/minion.d/master.conf
  become: true

- name: Set Minion ID
  ansible.builtin.template:
    src: id.conf.j2
    dest: /etc/salt/minion.d/id.conf
  become: true

- name: Restart Salt Minion service
  ansible.builtin.systemd:
    name: salt-minion
    state: restarted
  become: true

```

### `roles/salt_minion/templates/master.conf.j2`

```
master: {{ master_ip }}
```

### `roles/salt_minion/templates/id.conf.j2`

```
id: {{ minion_id }}
```

### `roles/salt_minion/vars/main.yml`

```yaml
master_ip: "{{ hostvars[groups['masters'][0]]['local_ip'] }}"
minion_id: "{{ inventory_hostname }}"
```

### `playbook.yml`

```yaml
---
- name : Install Masters
  hosts: masters
  become: yes
  roles:
    - salt_master

- name: Install minions
  hosts: minions
  become: yes
  roles:
    - salt_minion
```

### Запуск Ansible playbook

1. Настроен `inventory` файл, который определяет мастер и миньон узлы.
    
    **`inventory`**
    
    ```
    [masters]
    master ansible_host=62.84.116.79 local_ip=10.250.240.12
    
    [minions]
    slave1 ansible_host=51.250.95.33 local_ip=10.250.240.18
    # можно дальши писать - столько сколько у вас minions
    ```
    
2. `ansible.cfg`

```
[defaults]
inventory = inventory 
remote_user= ec2-user
host_key_checking = False
transport=smart
```

1. Запустим `playbook`:

```bash
ansible-playbook playbook.yml
```

Я запускал с такой комбинацией

```bash
ansible-playbook playbook.yml --check --diff
```

Этот playbook установит SaltStack и настроит необходимые компоненты как на мастере, так и на миньоне. После нашего playbook - получаем такую картину

```bash
PLAY RECAP ******************************************************************************************************************************
master                     : ok=8    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
slave1                     : ok=9    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```