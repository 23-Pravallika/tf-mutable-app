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

# creates on Demand instance
resource "aws_instance" "on_demand" {
  count         = var.OD_INSTANCE_COUNT  
  ami           = data.aws_ami.my_ami.id
  instance_type = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.allow-app.id]
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID, count.index)

}

# creates the tag for instances
resource "aws_ec2_tag" "ec2_tags" {
  count       = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}


