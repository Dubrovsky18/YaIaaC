terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.122.0"
    }
  }
}


provider "yandex" {
  service_account_key_file = "authorized_key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}
