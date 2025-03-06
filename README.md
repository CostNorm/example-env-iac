# Example Environment IaC

This project contains Terraform code for testing AWS infrastructure deployment with actual cost implications.
**Warning: Running this example code will incur actual costs in AWS.**

## Prerequisites

### Install AWS CLI

#### For Ubuntu
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt update && sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
rm -rf ./aws
```

#### For macOS
```bash
brew install awscli
```

#### Verify installation:
```bash
aws --version
Ubuntu
```

### Install Terraform

#### For Ubuntu

```bash
sudo apt update && sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
```

#### For macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Verify installation:

```bash
terraform --version
```

## Configure AWS Credentials

Set up AWS CLI configuration:
```bash
aws configure
```

You will need to provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., ap-northeast-2)
- Default output format (json recommended)

## Usage

1. Navigate to the desired environment directory

2. Set up your variables file:
```bash
cp variables.tf.sample variables.tf
```
Then edit `variables.tf` with your specific configuration values

3. Initialize Terraform
```bash
terraform init
```

4. Review the execution plan
```bash
terraform plan
```

5. Apply the infrastructure changes
```bash
terraform apply
```

6. Destroy infrastructure (when needed)
```bash
terraform destroy
```

## Important Notes

- Be aware that using these resources may incur actual AWS costs
- Always destroy unused resources to avoid unnecessary charges
- Never commit AWS credentials to version control
- Ensure sensitive files are properly listed in `.gitignore`
- Review and understand the infrastructure changes before applying them