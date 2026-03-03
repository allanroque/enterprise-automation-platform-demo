# Enterprise Automation Platform Demo

Repositório de labs e demos usando **Ansible Automation Platform (AAP)** para orquestrar automações de infraestrutura e configuração.

O primeiro caso de uso provisiona **4 instâncias RHEL na AWS** usando **Terraform** acionado por **Ansible** (via coleção `cloud.terraform`) e executado dentro do AAP.

## Estrutura (alto nível)

```text
enterprise-automation-platform-demo/
├── README.md
├── ansible.cfg
├── .gitignore
├── execution-environment/
├── use-cases/
│   └── 01-provision-aws-rhel/
└── docs/
```

## Caso de uso 01 – Provisionar 4 RHEL na AWS

Diretório: `use-cases/01-provision-aws-rhel/`

Este caso de uso demonstra:

- Provisionamento de 4 instâncias **RHEL** na AWS com **Terraform**;
- Orquestração via **Ansible** usando o módulo `cloud.terraform.terraform`;
- Execução dentro do **Ansible Automation Platform** usando um **Execution Environment** customizado com Terraform.

### Como começar

1. Configure o **Execution Environment** a partir de `execution-environment/`;
2. Configure o backend de estado do Terraform (S3) conforme exemplo em `docs/sample-terraform-backend-credential`;
3. No AAP, crie:
   - Um **Credential Type** para o backend Terraform;
   - Uma **Credential** baseada nesse tipo;
   - Um **Project** apontando para este repositório;
   - Um **Job Template** usando o playbook `use-cases/01-provision-aws-rhel/playbooks/provision.yml`.

Para detalhes específicos do caso de uso, veja o `README.md` em `use-cases/01-provision-aws-rhel/`.

