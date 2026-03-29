init:
	cd environments/dev && terraform init

plan:
	cd environments/dev && terraform plan

apply:
	cd environments/dev && terraform apply -auto-approve

destroy:
	cd environments/dev && terraform destroy -auto-approve