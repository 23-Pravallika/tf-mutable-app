resource "null_resource" "app" {
 //   triggers = {ver = var.APP_VERSION} // Whenever these is a change in the versio only during that time it will run.
    triggers = {always_run = true} // This will run all the time
  count = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT

  provisioner "remote-exec" {
       connection {
          type     = "ssh"
          user     = local.SSH_USER
          password = local.SSH_PASSWD
          host     = element(local.INSTANCE_IPS, count.index)
  }
    inline = [
      "ansible-pull -U https://github.com/23-Pravallika/Ansible.git robo-pull.yml -e ENV=dev -e COMPONENT=cart -e APP_VERSION=${var.APP_VERSION}"
    ]
  }
}



