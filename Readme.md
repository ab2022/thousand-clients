
## Thousands (or more) of automated dash.js or shaka player clients.


Several ways to run automated DASH clients using headless chromium or chrome, and related utilities.
- apline container with headless chrome
  - Dockerfile for a small-ish container for running chrome with minimal dependencies
- bash script on localhost
  - runs on recent Ubuntus and similar
- terraform for AWS EC2 instances
- terraform for Fargate in AWS
- terraform for Compute Engine in Gcloud
- terraform for Cloud Run in Gcloud
- javascript node.js container with puppeteer and docker
  - Dockerfile for automated chrome driven by puppeteer javascript library
- player
  - a hosted html player that uses the dash.js client from [this qualabs repo](https://github.com/montevideo-tech/cmcd-analyzer/tree/feature/cmcd-v2-demuxed/analyzer-dashboard/public), which has some support for CMCDv2.
- post process
  - python scripts for some preliminary analysis of both request and response mode log files.


