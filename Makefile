.PHONY: init fmt validate plan apply show list output
all: fmt init validate plan apply show output list

init:
	terraform init

fmt:
	terraform fmt --recursive

validate:
	terraform validate

plan:
	terraform plan -out=main_plan

apply:
	terraform apply "main_plan"

show:
	terraform show

list:
	terraform state list

destroy:
	terraform destroy

output:
	terraform output RESOURCE_DETAILS
