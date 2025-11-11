Terraform notes:

1. You must create the lambda zip file before running terraform apply:
   - see infra/terraform/lambda/README.md for instructions to build the nodejs authorizer
   - file path: infra/terraform/lambda/lambda_authorizer.zip

2. Provide AWS credentials to the environment:
   export AWS_ACCESS_KEY_ID=...
   export AWS_SECRET_ACCESS_KEY=...
   export AWS_REGION=us-east-1

3. Initialize and apply:
   terraform init
   terraform apply -auto-approve

4. Replace placeholders (JWT secret, ECR repository in Helm values, etc.)
