# Description
This is terraform code that will build a playground environment for development environment. 

## Modules
### IAM Identity Center
A module that allows a user to set up SSO and create users, groups, and permission sets.

### EKS
A module that will configure an EKS cluster and the required IAM role and permissions.

### Spot Fleet
A module to configure spot fleets and acceptable spot server types that can be used with the EKS module. A future enhancement will be to also leverage Karpenter to help with autoscaling.

### VPC
A module that will configure the VPC and subnets (based on the amount of AZs in that region). Also has an option to configure a NAT gateway.

