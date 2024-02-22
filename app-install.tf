resource "null_resource" "app" {
  count = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT

  provisioner "remote-exec" {
       connection {
          type     = "ssh"
          user     = local.SSH_USER
          password = local.SSH_PASSWD
          host     = local.INSTANCE_IPS
  }
    inline = [
      "ansible-pull -U https://github.com/23-Pravallika/Ansible.git robo-pull.yml -e ENV=dev -e COMPONENT=cart -e APP_VERSION=${var.APP_VERSION}"
    ]
  }
}



