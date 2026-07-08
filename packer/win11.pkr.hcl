packer {
    required_plugins {
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
    }
}


source "virtualbox-iso" "windows11-iso" {
  guest_os_type = "Windows11_64"
  iso_url = "../Win11.iso"
  iso_checksum = "sha256:a61adeab895ef5a4db436e0a7011c92a2ff17bb0357f58b13bbc4062e535e7b9"
  
  # Specs
  disk_size = 120000
  memory = 8000
  cpus = 8
  
  # SSH
  ssh_username = "packer"
  ssh_password = "packer"
  ## Windows needs a while to install ...
  ## TODO: 1h is just for debugging purposes. Lower this later for production
  ssh_timeout = "1h"
  shutdown_command = "shutdown /s /t 0"

  # Make Autounattend.xml available
  cd_files = ["Autounattend.xml"]

  boot_wait = "1s"
  boot_command = ["<spacebar>","<spacebar>","<spacebar>","<spacebar>"]

  # Enable Secure Boot (Prerequisit for Windows Installation)
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--firmware", "efi"]
  ]

}

build {
  name    = "learn-packer"
  sources = [
    "source.virtualbox-iso.windows11-iso"
  ]
}
