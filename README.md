# DevOps Exercise — AWS Terraform + .NET 8 Microservice + Azure DevOps CI/CD

This package contains:
- C# (.NET 8) microservice (POST /DevOps) with API Key + JWT checks.
- Updated package dependencies (requested versions).
- Dockerfile for containerization.
- xUnit tests.
- Helm chart for ECS/EKS-compatible deployment (optional).
- Terraform for AWS: VPC, ALB, Target Group, Listener, ECS Fargate (2 tasks), ECR, API Gateway, Lambda authorizer, AutoScaling, IAM roles/policies.
- Azure DevOps pipeline YAML that builds, tests, pushes to ECR, and runs Terraform to deploy to AWS.

**Important:** This is a template. You must replace placeholders (AWS credentials, ARNs, and some values) before deploying.

See `infra/terraform/README_TF.md` for terraform usage notes.
