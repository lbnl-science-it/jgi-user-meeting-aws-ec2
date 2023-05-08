################################################
## Define the provider
################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }
  required_version = ">= 1.2.0"
}
################################################


################################################
## Module input
################################################

# Defined in local file: ./variables.tf

################################################


################################################
## Module resource
################################################
resource "aws_security_group" "this" {
  name = var.security_group_name

  #Incoming traffic from Any IP to ports: 22, 80 
  # ingress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outgoing traffic to Any IP
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  # ubuntu 20.04 LTS hvm:ebs-ssd, amd64, ami location us-west-2
  # for more ubuntu AMI: https://cloud-images.ubuntu.com/locator/ec2/
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.this.name]
  tags = {
    Name = var.instance_name
  }
  # root disk
  root_block_device {
    volume_size           = "200"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
  user_data = <<EOF
#! /bin/bash
sudo su ubuntu
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
## #sudo apt install -y python3.8 python3.8-venv python3-distutils awscli parallel ncbi-blast+
## sudo apt install -y python3.10 python3.10-venv python3-distutils awscli parallel ncbi-blast+
## APT cannot install ncbi-blast+ the latest version 2.14.0
sudo apt install -y python3.10 python3.10-venv python3-distutils awscli parallel alien
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.10 1
cd /home/ubuntu
git clone https://github.com/lbnl-science-it/jgi-aws-ami.git
## #### Mount NVME-SSD:
## #### For instance-type "c5ad.xlarge": 4-core cpu, 8-GB ram, 150-GB nvme-ssd, $0.1736/hr
## #### For for instance-type "c5ad.xlarge": 4-core cpu, 8-GB ram, 237-GB nvme-ssd, $0.2016/hr
mkdir nvme_ssd
sudo mkfs -t ext4 /dev/nvme1n1
sudo mount /dev/nvme1n1 nvme_ssd
sudo chown -R ubuntu:ubuntu nvme_ssd
### AWS-CLI Setup:
sudo -u ubuntu aws configure set region ${var.ec2_region}
#sudo -u ubuntu aws configure set aws_access_key_id ${var.key_id}
#sudo -u ubuntu aws configure set aws_secret_access_key ${var.access_key}
echo "export PATH=$PATH:/home/ubuntu/tools/sratoolkit.3.0.0-ubuntu64/bin" >> /home/ubuntu/.bashrc
#echo "export S3URL=s3://elasticblast-${var.s3name}" >> /home/ubuntu/.bashrc
#### ElasticBLAST Setup: https://blast.ncbi.nlm.nih.gov/doc/elastic-blast/quickstart-aws.html
## export S3NAME=${var.s3name}
## export AWS_REGION=${var.ec2_region}
## sed -i "s/YOURNAME/$S3NAME/g" BDQA.ini 
## sed -i "s/YOURREGION/$AWS_REGION/g" BDQA.ini
[ -d .elb-venv ] && rm -fr .elb-venv
python3 -m venv .elb-venv
source .elb-venv/bin/activate
pip install wheel
pip install elastic-blast
cd /home/ubuntu
mkdir tools && cd tools
## Install the latest Blast+ v2.14.0 from source
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.14.0+-2.x86_64.rpm
sudo alien -i ncbi-blast-2.14.0+-2.x86_64.rpm
wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar xvf sratoolkit.tar.gz
curl -o mastiff -L https://github.com/sourmash-bio/mastiff/releases/latest/download/mastiff-client-x86_64-unknown-linux-musl
chmod +x mastiff
cd /home/ubuntu
mkdir scripts && cd scripts
cp /home/ubuntu/jgi-aws-ami/post_process_query.py ./
chmod +x post_process_query.py
## echo "cd /home/ubuntu/jgi_workshop_demo" >> /home/ubuntu/.bashrc
## echo "source /home/ubuntu/jgi_workshop_demo/.elb-venv/bin/activate" >> /home/ubuntu/.bashrc
#### avoid interactive vdb-config
cd /home/ubuntu
mkdir .ncbi && cd .ncbi
cp /home/ubuntu/jgi-aws-ami/user-settings.mkfg ./
rm -rf /home/ubuntu/jgi-aws-ami
sudo chown -R ubuntu:ubuntu /home/ubuntu 
EOF
}

################################################
## Module output
################################################
output "ec2_summary" {
  value = {
    ec2_name      = var.instance_name
    ec2_ami       = var.ami_id
    ec2_type      = aws_instance.this.instance_type
    ec2_id        = aws_instance.this.id
    ec2_public_ip = aws_instance.this.public_ip
    ec2_arn       = aws_instance.this.arn
  }
}
################################################
