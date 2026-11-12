# AWS Multi-AZ VPC & Network Infrastructure as Code (Terraform & CloudFormation)

![AWS](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

> **English:** Infrastructure as Code (IaC) templates built with **Terraform** and **AWS CloudFormation** to provision a segmented, Multi-AZ AWS VPC network architecture (Public & Private Subnets, Internet Gateway, NAT Gateway, Route Tables, and least-privilege Security Groups), accompanied by a Linux EC2 hardening bootstrap script.
>
> **Português:** Templates de Infraestrutura como Código (IaC) em **Terraform** e **AWS CloudFormation** para provisionar uma arquitetura de rede VPC Multi-AZ segmentada na AWS (Sub-redes Públicas e Privadas, Internet Gateway, NAT Gateway, Tabelas de Roteamento e Security Groups com privilégio mínimo), acompanhados de script de bootstrap/hardening para instâncias EC2 Linux.

---

## Architecture Overview / Visão Geral da Arquitetura

- **VPC (`10.20.0.0/16`)**: DNS hostnames and resolution enabled.
- **Public Subnets (`10.20.1.0/24`, `10.20.2.0/24`)**: Distributed across two Availability Zones with route to the Internet Gateway (`IGW`).
- **Private Subnets (`10.20.11.0/24`, `10.20.12.0/24`)**: Isolated from inbound internet traffic; outbound access routed through a managed `NAT Gateway`.
- **Security Groups**: Segmented Web/Bastion (`80/443` and restricted `22`) and Internal Application tiers.

---

## Repository Structure / Estrutura do Repositório

| File | Description (EN) | Descrição (PT-BR) |
| :--- | :--- | :--- |
| [`terraform/main.tf`](terraform/main.tf) | Terraform resources for VPC, Subnets, IGW, NAT Gateway, Route Tables, and Security Groups. | Recursos Terraform para VPC, Sub-redes, IGW, NAT Gateway, Route Tables e Security Groups. |
| [`terraform/variables.tf`](terraform/variables.tf) | Parameterized input variables (region, CIDR blocks, environment tags, allowed SSH CIDR). | Variáveis de entrada parametrizadas (região, blocos CIDR, tags de ambiente e CIDR SSH permitido). |
| [`terraform/outputs.tf`](terraform/outputs.tf) | Exports VPC ID, Subnet IDs, and Security Group IDs for downstream modules. | Exporta IDs da VPC, Sub-redes e Security Groups para uso em outros módulos. |
| [`cloudformation/vpc-network-stack.yaml`](cloudformation/vpc-network-stack.yaml) | Native AWS CloudFormation template replicating the Multi-AZ VPC topology. | Template nativo AWS CloudFormation replicando a topologia de rede VPC Multi-AZ. |
| [`scripts/user-data-bootstrap.sh`](scripts/user-data-bootstrap.sh) | EC2 User Data script for automated OS patching, SSH hardening, and NGINX health-check setup. | Script de User Data para atualização automática do SO, hardening de SSH e configuração de health-check no NGINX. |

---

## Deployment Instructions / Instruções de Deploy

### Option 1: Terraform
```bash
cd terraform
terraform init
terraform plan -var="environment=production" -var="admin_ssh_cidr=203.0.113.50/32"
terraform apply
```

### Option 2: AWS CloudFormation (AWS CLI)
```bash
aws cloudformation deploy \
  --template-file cloudformation/vpc-network-stack.yaml \
  --stack-name prod-vpc-network-stack \
  --parameter-overrides EnvironmentName=production VpcCIDR=10.20.0.0/16
```
