terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.7.2"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "html_server" {
  label           = "html-server"
  region          = "us-east"                                                                                             # Specify the desired region
  image           = "linode/ubuntu20.04"                                                                                  # Linode image to use
  type            = "g6-standard-1"                                                                                       # Plan type
  root_pass       = var.root_password                                                                                     # Root password for the server
  authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMKX/d7xvNGwWKQXLjbGLmK/fMYEIzoMf3AI/lMZhw3 kkatte@blr-mpw6t"] # Use the newly generated public key

  # Provisioner to copy Ansible playbook and HTML file to the Linode instance
  provisioner "file" {
    source      = "install_ngnix.yml"
    destination = "/tmp/install_html.yml"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("linode_kkatte")
      host        = tolist(self.ipv4)[0]
    }
  }

  ### Copy HTML file to instance
  provisioner "file" {
    source      = "Signin[Jenkins].html"
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("linode_kkatte")
      host        = tolist(self.ipv4)[0]
    }
  }

  # Install Ansible and run the playbook on the Linode instance
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y ansible",
      "ansible-playbook /tmp/install_html.yml"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("linode_kkatte")
      host        = tolist(self.ipv4)[0]
    }
  }
}

# Output the public IP address of the Linode instance
output "linode_public_ip" {
  value       = tolist(linode_instance.html_server.ipv4)[0]
  description = "The public IP address of the Linode instance."
}
