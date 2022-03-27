// Configure the Yandex.Cloud provider
terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-test-backet"
    region     = "us-east-1"
    key        = "./terraform.tfstate"
    # access_key = TF_VAR_
    # secret_key = var.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  # token     = "YC_TOKEN"
  # cloud_id  = "YC_CLOUD_ID"
  # folder_id = "YC_FOLDER_ID"
  # zone      = "YC_ZONE"
}

locals {
  web_instance_count_map = {
    default = 3
    stage = 1
    prod = 2
  }
}

// Create a new instance
resource "yandex_compute_instance" "vm-1" {
  name = "terraform-netology"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8lbi4hr72am1eb2kmf"
    }
  }

  count = local.web_instance_count_map[terraform.workspace]

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${file("./meta.txt")}"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}



# output "internal_ip_address_vm_1" {
#   value = yandex_compute_instance.vm-1.network_interface.0.ip_address
# }

# output "external_ip_address_vm_1" {
#   value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
# }

locals {
  web_instance_yc = {
    "default" = 3
    "stage" = 1
    "prod" = 2
  }
}

// Create a new instance
resource "yandex_compute_instance" "vm-2" {
  name = "terraform-netology"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8lbi4hr72am1eb2kmf"
    }
  }

  for_each = local.web_instance_yc

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-2" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# output "internal_ip_address_vm_1" {
#   value = yandex_compute_instance.vm-1.network_interface.0.ip_address
# }

# output "external_ip_address_vm_1" {
#   value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
# }