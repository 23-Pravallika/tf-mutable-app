locals {
  SSH_USER      = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_USR"]
  SSH_PASSWD    = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_PASS"]
  INSTANCE_IPS  = concat(aws_spot_instance_request.spot.*.private_ip, aws_instance.on_demand.*.private_ip)
  INSTANCE_IDS  = concat(aws_spot_instance_request.spot.*.spot_instance_id, aws_instance.on_demand.*.id) 
}


