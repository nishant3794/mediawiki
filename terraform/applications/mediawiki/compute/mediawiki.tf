module "mediawiki-user-data" {
  source                    = "../../../modules/user_data"
  app                       = "mediawiki"
}

module "mediawiki-launch-configuration" {
  source                    = "../../../modules/launch-config"
  name                      = "mediawiki-lc"
  image_id                  = data.aws_ami.mediawiki.id
  instance_type             = "t2.micro"
  iam_instance_profile      = data.aws_iam_role.mediawiki.id
  key_name                  = "mediawiki-key"
  security_groups           = [data.aws_security_group.mediawiki.id]
  associate_public_ip_address = "false"
  user_data                 = module.mediawiki-user-data.user-data
  placement_tenancy         = "default"
  root_volume_size          = "15"
  root_volume_type          = "gp2"
  root_delete_on_termination = "true"
}


module "mediawiki-asg" {
  source                    = "../../../modules/asg"
  name                      = "mediawiki-asg"
  min_size                  = "2"
  max_size                  = "4"
  default_cooldown          = "300"
  launch_configuration      = module.mediawiki-launch-configuration.lc-id
  health_check_grace_period = "0"
  health_check_type         = "EC2"
  desired_capacity          = "2"
  subnets                   = data.aws_subnet_ids.private.ids
  target_group_arns         = [data.aws_lb_target_group.mediawiki.id]
  termination_policies      = ["default"]
  suspended_processes       = []
  tag_name                  = "mediawiki-app"
  tag_BaseAmi               = data.aws_ami.mediawiki.id
}

module "mediawiki-asg-policy-up" {
  source                    = "../../../modules/asg_policy"
  adjustment_type		    = "ChangeInCapacity"
  autoscaling_group_name	= module.mediawiki-asg.asg-name
  comparison_operator		= "GreaterThanOrEqualToThreshold"
  metric_name			    = "CPUUtilization"
  period			        = 120
  scaling_adjustment		= 1
  threshold			        = 30
  treat_missing_data	    = "breaching"
  name				        = "mediawiki-asg-policy-up"
}

module "mediawiki-asg-policy-down" {
  source                    = "../../../modules/asg_policy"
  adjustment_type		    = "ChangeInCapacity"
  autoscaling_group_name	= module.mediawiki-asg.asg-name
  comparison_operator		= "GreaterThanOrEqualToThreshold"
  metric_name			    = "CPUUtilization"
  period			        = 120
  scaling_adjustment		= -1
  threshold			        = 30
  treat_missing_data	    = "breaching"
  name				        = "mediawiki-asg-policy-down"
}