# creates Spot instance
resource "aws_spot_instance_request" "spot" {
  count         = var.SPOT_INSTANCE_COUNT
  ami           = data.aws_ami.my_ami.id
  instance_type = var.INSTANCE_TYPE
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.allow-app.id]
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID, count.index)
  
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-spot"
  }
}

resource "aws_instance" "on_demand" {
  count         = var.OD_INSTANCE_COUNT  
  ami           = data.aws_ami.my_ami.id
  instance_type = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.allow-app.id]
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID, count.index)

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-on-demand"
  }
}

# creates the tag for instances
resource "aws_ec2_tag" "tags" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT  
  resource_id = local.INSTANCE_IDS
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}



