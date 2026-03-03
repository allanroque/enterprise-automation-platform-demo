## Use-case 01 – Provisionar 4 RHEL na AWS

Este diretório contém o primeiro lab/demo do repositório, que provisiona instâncias **RHEL na AWS** (VPC, security group, EC2 e buckets S3) usando **Terraform** orquestrado via **Ansible Automation Platform (AAP)**.

### Estrutura

```text
use-cases/01-provision-aws-rhel/
├── README.md
├── vars/
│   └── vars.yml
├── playbooks/
│   ├── provision_linux.yml
│   └── destroy.yml
└── terraform/
    ├── main.tf
    ├── provider.tf
    ├── variables.tf
    └── outputs.tf
```

### Pré-requisitos gerais

- Conta AWS com permissões para:
  - Criar instâncias EC2;
  - Criar/usar bucket S3 para estado do Terraform.
- Acesso ao **registry.redhat.io** para buildar o Execution Environment.
- **Ansible Automation Platform** (AAP) 2.5+.

### Backend do Terraform (S3)

O `backend "s3" {}` em `terraform/provider.tf` é configurado via um arquivo externo, injetado pela AAP através de um **Credential Type** específico de backend Terraform.

Exemplo de conteúdo (placeholders) está em `docs/sample-terraform-backend-credential` na raiz do repositório.

### Execução via AAP

1. **Execution Environment**
   - Construa um EE a partir de `execution-environment/` na raiz do repositório.
   - Esse EE inclui:
     - Collections `amazon.aws` e `cloud.terraform`;
     - Binário `terraform` no PATH.

2. **Credential Type + Credential**
   - Crie um **Credential Type** do tipo “Terraform backend configuration” (conforme documentação AAP/terraform-aap).
   - Crie uma **Credential** usando esse tipo, colando o conteúdo do backend S3 (similar ao exemplo de `docs/sample-terraform-backend-credential`).

3. **Project**
   - Crie um Project no AAP apontando para este repositório Git.

4. **Job Template**
   - Playbook: `use-cases/01-provision-aws-rhel/playbooks/provision_linux.yml`
   - Inventory: pode ser “localhost” ou um inventário vazio, já que o play roda em `localhost`.
   - Execution Environment: selecione o EE customizado que você construiu.
   - Credentials:
     - Credenciais AWS (se necessárias para o EE acessar a AWS);
     - Credential de backend Terraform criada acima.

Quando o Job Template é executado, o módulo `cloud.terraform.terraform` irá:

- Rodar `terraform init` (com `force_init: true`);
- Aplicar o plano (`state: present`);
- Usar o backend S3 via arquivo apontado pela variável de ambiente `TF_BACKEND_CONFIG_FILE`, definida pela Credential.

### Execução local (opcional)

Você também pode testar localmente (fora da AAP), desde que tenha:

- Terraform instalado;
- Credenciais AWS configuradas (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, etc.);
- Ansible e coleção `cloud.terraform` instalados.

Passos básicos:

```bash
cd use-cases/01-provision-aws-rhel

# Opcional: terraform init/plan/apply direto
cd terraform
terraform init
terraform apply

# Via Ansible
cd ..
ansible-playbook playbooks/provision_linux.yml
```

> Atenção: se você não configurar o backend S3 via variável `TF_BACKEND_CONFIG_FILE`, o Terraform usará o backend padrão local (estado em disco) quando rodar fora do AAP.

