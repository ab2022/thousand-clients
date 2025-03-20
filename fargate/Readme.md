
## Terraform workflow to deploy containers in ECS with Fargate

Will deploy the container built in `..js/` to a serverless env in AWS ECS.

Creating the ECR and pushing the docker container to the repo is not covered.

Replace the container image with your ECR and image name in
`aws_ecs_task_definition`. Then run the normal steps:

```
terrafrom init
terrafrom plan -out dashworld
terrafrom apply "dashworld"
```

AWS credentials and profile need to be provided.
Number of instances can be edited in the `aws_ecs_service` resource.


