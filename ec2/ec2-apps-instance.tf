resource "aws_instance" "apps-instance-ec2" {
  ami                    = "${lookup(var.EC2_AMI, var.AWS_REGION)}"
  instance_type          = "t2.micro"
  key_name               = "devops-key"
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  subnet_id              = "${var.staging-public-subnet-a}"

  tags = {
    Name        = "apps-instance"
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }
  user_data     = <<EOF 
    #!/bin/bash
    echo "Install Docker dependencies"
    sudo apt update
    sudo apt install apt-transport-https curl postgresql-client git gnupg-agent ca-certificates software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce docker-compose-plugin docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER
    docker version   
  EOF

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  volume_tags = {
    Name        = "apps-instance-vol"
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }


}

resource "aws_eip" "apps-instance-ec2-eip" {
  instance = aws_instance.apps-instance-ec2.id

  tags = {
    Name        = "apps-instance-eip"
    Init        = "terraform"
    recipe      = "${var.IAC_REPO_BRANCH}"
  }
}

resource "aws_eip_association" "apps-instance-ec2-assoc" {
  instance_id   = aws_instance.apps-instance-ec2.id
  allocation_id = aws_eip.apps-instance-ec2-eip.id
}
