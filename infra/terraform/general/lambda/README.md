Lambda authorizer:
- index.js is the authorizer handler.
- For production, run `npm install` in this folder to include dependencies and then zip the folder contents:
  npm install
  zip -r lambda_authorizer.zip index.js node_modules package.json
- Terraform expects the zip file at: infra/terraform/lambda/lambda_authorizer.zip
