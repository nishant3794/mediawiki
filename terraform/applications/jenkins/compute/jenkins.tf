module "jenkins-user-data" {
  source                    = "../../../modules/user_data"
  app                       = "jenkins"
}

module "jenkins-server" {
    source              = "../../../modules/ec2"
    ami                 = data.aws_ami.jenkins.id
    instance_type       = "t2.micro"
    key_name            = "jenkins-mediawiki"
    security_groups     = [data.aws_security_group.jenkins.id]
    subnet_id           = data.aws_subnet.public.id
    associate_public_ip_address = true
    user_data           = module.jenkins-user-data.user-data
    iam_instance_profile = data.aws_iam_instance_profile.jenkins.name
    root_volume_type    = "gp2"
    root_volume_size    = "20"
    root_delete_on_termination = true
    service             = "jenkins"
}

