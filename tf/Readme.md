
## Standard terraform workflow to deploy a bunch of EC2 instances

Nomally works with:

```
terrafrom init
terrafrom plan -out dashworld_1
terrafrom apply "dashworld_1"
```

AWS credentials need to be provided.
Number of instances can be edited in `main.tf`
and number of clients for each instance can be edited in `install.sh`.


Current config is 100 instances of type c5a.4xlarge with 30 clients each, for a total of 3000 clients.

