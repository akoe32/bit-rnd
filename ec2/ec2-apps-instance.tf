resource "aws_instance" "apps-instance-ec2" {
  ami                    = "${lookup(var.EC2_AMI, var.AWS_REGION)}"
  instance_type          = ${var.EC2_INSTANCE_TYPE}
  key_name               = ${var.EC2_KEY_NAME}
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [aws_security_group.teleport-ec2-sg.id]
  subnet_id              = "subnet-06289404de3c2053a"
  user_data              = <<EOF 
  #!/bin/bash
  echo "Install Docker dependencies"
  sudo apt update
  sudo apt install apt-transport-https curl postgresql-client git gnupg-agent ca-certificates software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt install docker-ce docker-compose-plugin docker-ce-cli containerd.io -y
  sudo usermod -aG docker $USER
  docker version


  ####clone gitlab repository####
  echo "service preparation"
  echo "machine gitlab.com login ${var.APPS_GITLAB_USER} password ${var.APPS_GITLAB_TOKEN}"> ~/.netrc
  docker login -u ${var.APPS_GITLAB_USER} -p ${var.APPS_GITLAB_TOKEN}
  mkdir -p /home/ubuntu/projects
  export DB_HOST=${var.APPS_DB_HOST} && \
         DB_PASS=${var.APPS_DB_PASS} && \
         DB_NAME=${var.APPS_DB_NAME} && \
         DB_USER=${var.APPS_DB_USER} && \
         DB_PORT=${var.APPS_DB_PORT} && \
         OWM_API_KEY=${var.APPS_OWM_API_KEY} && \
         OWM_LOCATION=${var.APPS_OWM_LOCATION} && \
         OWM_UNITS=${var.APPS_OWM_UNITS} && \
  cd /home/ubuntu/projects && git clone https://gitlab.com/akooe32/bit-rnd.git && cd bit-rnd/apps
  docker compose up -d
    
  EOF

  tags = {
    Name        = "${var.EC2_INSTANCE_NAME}"
    Environment = "${var.EC2_ENV}"
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = ${var.EC2_VOLUME_SIZE}
    delete_on_termination = true
  }

  volume_tags = {
    Name        = "${var.EC2_INSTANCE_NAME}-vol"
    Environment = ${var.EC2_ENV}
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }


}

resource "aws_eip" "apps-instance-ec2-eip" {
  instance = aws_instance.apps-instance-ec2.id

  tags = {
    Name        = "${var.EC2_INSTANCE_NAME}-eip"
    Environment = ${var.EC2_ENV}
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }
}

resource "aws_eip_association" "apps-instance-ec2-assoc" {
  instance_id   = aws_instance.apps-instance-ec2.id
  allocation_id = aws_eip.apps-instance-ec2-eip.id
}
