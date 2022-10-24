# jgi-user-meeting-aws-accounts
Using terraform to automatically provision AWS accounts
* JGI Required IAM Permissions: https://blast.ncbi.nlm.nih.gov/doc/elastic-blast/iam-policy.html
  * for Elastic-BLAST execution, AWS Batch and CloudWatch
* JGI Required EC2 instance
  * SRAtoolkit, awscli, python3.10-venv, numpy, ncbi-blast+, and elastic-blast (v0.2.6)

## 1. Install Terraform (1.2.0+ required):
### Mac OS X
```
$ brew install terraform
$ brew update
$ brew upgrade terraform
$ terraform --version
```

## 2. AWS credentials setup
To use your IAM credentials to authenticate the Terraform AWS provider, set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
```
$ export AWS_ACCESS_KEY_ID=
$ export AWS_SECRET_ACCESS_KEY=
```



## 3. Create a new EC2 under the current root account
#### Validation, Plan, and Review
```
$ make init
$ make validate
```
```
$ make plan
```

#### Create a new EC2
```
$ make apply
```

#### View the public IP of EC2
```
$ make output
```

#### You can also run above steps in on line
```
$ make all
```

## 4. EC2 login
* Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
* Choose Region -> __US West(Oregon) us-west-2__
* In the navigation pane, choose Instances.
* Select the instance (__demo-eblast-workshop__) and choose Connect.
* Choose EC2 Instance Connect (the default username is Ubuntu).


After login, you can find the reqired tools and scripts at `/home/ubuntu/tools` and `/home/ubuntu/scripts`. There is 217GB NVME SSD mounted on `/home/ubuntu/nvme_ssd`

```
ubuntu@ip-172-31-49-23:~$ ls
nvme_ssd  scripts  tools

ubuntu@ip-172-31-49-23:~$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        194G  2.4G  192G   2% /
devtmpfs         3.9G     0  3.9G   0% /dev
tmpfs            3.9G     0  3.9G   0% /dev/shm
tmpfs            781M  840K  781M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
tmpfs            3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/loop0        26M   26M     0 100% /snap/amazon-ssm-agent/5656
/dev/loop2        68M   68M     0 100% /snap/lxd/22753
/dev/loop1        56M   56M     0 100% /snap/core18/2409
/dev/nvme0n1p15  105M  5.2M  100M   5% /boot/efi
/dev/loop3        47M   47M     0 100% /snap/snapd/16292
/dev/loop4        62M   62M     0 100% /snap/core20/1518
/dev/nvme1n1     217G   61M  206G   1% /home/ubuntu/nvme_ssd
tmpfs            781M     0  781M   0% /run/user/1000
```



