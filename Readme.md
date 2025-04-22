
## Thousands (or more) of automated dash.js clients.


Several ways to run automated dash.js clients using headless chromium or chrome:
1. bash script on localhost
1. terraform for AWS EC2 instances
1. terraform for Fargate in AWS
1. terraform for Cloud Run in Gcloud
1. javascript node.js with puppeteer and docker

Also included is a player that uses the dash.js client from 
[this qualabs repo](https://github.com/montevideo-tech/cmcd-analyzer/tree/feature/cmcd-v2-demuxed/analyzer-dashboard/public), 
which has some support for CMCDv2.

Lastly, `post_process` dir contains python scripts for some preliminary analysis of both request and response mode log files.


