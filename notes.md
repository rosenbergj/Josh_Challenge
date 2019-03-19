### To deploy (new or updates):

`time aws cloudformation deploy --capabilities CAPABILITY_IAM --parameter-overrides MyPhoneNumber="+1xxxyyyzzzz" --template-file cloudformation-template/cf.yaml  --stack-name single-page-static-site-serverless`

### To examine:

`aws cloudformation describe-stack-events --stack-name single-page-static-site-serverless | jq -C . | less -R`

### To delete:

`aws cloudformation delete-stack --stack-name single-page-static-site-serverless`

### To cleanup:

1. Delete S3 bucket serving the site (could be automated with bucket contents deletion lambda)
2. Delete S3 bucket for CodePipeline
3. Remove CNAME on nice FQDN and wait out the TTL (seriously, it actually won't deploy without this)

