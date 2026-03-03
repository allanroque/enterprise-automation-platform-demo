## Configurando o AAP para o lab 01 – 4 RHEL na AWS

### 1. Execution Environment

1. No seu ambiente de build (ex.: `ansible-builder`):
   - Aponte para o diretório `execution-environment/` deste repositório.
   - Use `execution-environment.yml` como definição do EE.
2. Publique a imagem em um registry acessível pelo AAP.
3. No AAP, cadastre esse EE em **Execution Environments**.

### 2. Credential Type – Terraform backend configuration

1. Em **Credential Types**, crie um tipo customizado baseado no exemplo de `terraform-aap` (ou na documentação oficial AAP/HashiCorp).
2. O campo principal deve mapear para uma variável de ambiente, por exemplo `TF_BACKEND_CONFIG_FILE`.
3. No formulário, o usuário colará o conteúdo do backend S3 (formato igual ao arquivo `docs/sample-terraform-backend-credential`).

### 3. Credential – Backend Terraform

1. Em **Credentials**, crie uma credencial usando o Credential Type acima.
2. No campo de conteúdo, cole um backend S3 válido:
   - `bucket`, `key`, `region`, `access_key`, `secret_key`.

### 4. Project

1. Em **Projects**, crie um novo Project apontando para o repositório Git deste lab.
2. Sincronize o Project para garantir que o código esteja disponível.

### 5. Job Templates

#### Provisionamento

- **Name**: `01 – Provisionar 4 RHEL na AWS`
- **Inventory**: um inventário mínimo (pode ser apenas `localhost`).
- **Project**: o Project criado acima.
- **Execution Environment**: o EE customizado deste lab.
- **Playbook**: `use-cases/01-provision-aws-rhel/playbooks/provision_linux.yml`
- **Credentials**:
  - Credencial AWS (separada, se necessário, para o provider);
  - Credencial de backend Terraform.
- **Extra Vars (opcional)**:
  - `aws_region`, `instance_count`, `instance_types`, `key_name`, `tags_common`, se quiser sobrescrever os defaults do `variables.tf` ou de `vars/vars.yml`.

#### Destroy

Crie um Job Template similar apontando para:

- **Playbook**: `use-cases/01-provision-aws-rhel/playbooks/destroy.yml`

### 6. (Próximos passos)

- Habilitar um **inventory source** do tipo “Terraform state” usando o estado gerado por este lab.
- Criar novos labs em `use-cases/02-...`, `03-...`, etc., reutilizando este mesmo EE.

