
## Terraform workflow to deploy a bunch of compute engine instances

Nomally works with:

```
terrafrom init
terrafrom plan -out compeng1
terrafrom apply "compeng1"
```

Credentials, network, and subnetwork should be configured.
Uses the `install.sh` script from the ec2 dir.


