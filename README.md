# Infrastructure Automation with Terraform & Ansible

## Project Description
This project leverages Terraform to provision cloud infrastructure and Ansible for configuration management, streamlining the deployment of a full-stack application. It emphasizes Infrastructure as Code (IaC) principles and automation, including the deployment of monitoring stacks for comprehensive oversight.

A key feature is automatic DNS management: during each deployment, the infrastructure provisions an IP address and updates the DNS records, ensuring uninterrupted access to the application.

## Getting Started
The following prequisites must be met

1. Terraform installed

2. AWS CLI with necessary permissions for provisioning resources:
    * EC2
    * Networking (VPC, Subnets)
    * DNS (Route 53)
    * IAM: `iam:PassRole`

3. A **Route53 Hosted zone**
   * A domain name for setting up application routing and access.
***
Clone the repository:
```
git clone https://github.com/Darkk-kami/terraform-ansible-docker.git

cd terraform-ansible-docker/dev
```
Configure Terraform
```
terraform init
terraform apply
```

## Applications Routes
* Frontend: `/`
* doc: `/docs` `/redoc`
* Grafana: `/grafana`
* Proxy Manager: `proxy.domain`
* Prometheus: `prometheus.domain`
* Adminer: `db.domain`


## Further Docmentation

For more information on the setup, troubleshooting, and architecture details, please visit the [wiki](https://github.com/Darkk-kami/terraform-ansible-docker/wiki)
or skip to the [Deployment](https://github.com/Darkk-kami/terraform-ansible-docker/wiki/Deployment-Process) Page for a straightforward, easy-to-understand steps of the deployment process.
