resource "null_resource" "app" {
 //   triggers = {ver = var.APP_VERSION} // Whenever these is a change in the versio only during that time it will run.
    triggers = {timestamp = timestamp()} // This will run all the time
  count = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT

  provisioner "remote-exec" {
       connection {
          type     = "ssh"
          user     = local.SSH_USER
          password = local.SSH_PASSWD
          host     = element(local.INSTANCE_IPS, count.index)
  }
    inline = [
      "ansible-pull -U https://github.com/23-Pravallika/Ansible.git robo-pull.yml -e MONGODB_ENDPOINT=${data.terraform_remote_state.db.outputs.DOCDB_ENDPOINT} -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION}"
    ]
  }
}



