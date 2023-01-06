# terraform-aws-vpc-peering-multi-account

Terraform module to create a peering connection between any two VPCs existing in different AWS accounts.

This module supports performing this action from a 3rd account (e.g. a "root" account) by specifying the roles to assume for each member account.

**IMPORTANT:** AWS allows a multi-account VPC Peering Connection to be deleted from either the requester's or accepter's side.
However, Terraform only allows the VPC Peering Connection to be deleted from the requester's side by removing the corresponding `aws_vpc_peering_connection` resource from your configuration.
---
## How to use this template
1. Generate the new repository based on this template.
2. Edit the files from the root as you need
   1. main.tf
   2. versions.tf
   3. variables.tf
   4. outputs.tf
3. Generate at least one example, like the one in ````examples/complete ````
4. Update the [Usage section](#usage).
5. Install [pre-commit](#how-to-use-pre-commit)
6. Generate the [terraform-docs](#terraform-docs)
7. Create a new PR, and merge the PR once that passes all the checks.
8. [Release a new version of the module](#release-a-new-version-with-the-github-cli).
9.  Remove this section from the new module.


## Usage
```terraform
module "vpc_peering_cross_account" {
  source = "../"
}
```


## Install and configure the tools
````shell
brew install jq
brew install terraform-docs
brew install gh
brew install pre-commit
brew install tfsec
brew install checkov
brew install tflint

gh auth login
````
## How to use pre-commit
```shell
# in the root of the module
pre-commit install
pre-commit run -a
```
## How to document
### Terraform Docs
```shell
# In the root of the module
terraform-docs markdown table --output-file README.md .
```
Note: the terraform-docs is generated with the GitHub Action ```` .github/workflows/tfdocs````, but you will have to
update your branch since it is updated in the PR.
## Release a new version with the GitHub cli
The version number must have the format vX.Y.Z or X.Y.Z
```shell
gh release create v0.0.5 --target main
```

<!-- BEGIN_TF_DOCS -->
# Examples
## Complete
```hcl
module "vpc_peering_cross_account" {
  source = "../"

  requester_aws_assume_role_arn             = "arn:aws:iam::XXXXXXXX:role/cross-account-vpc-peering-test"
  requester_region                          = "us-east-2"
  requester_vpc_id                          = "vpc-xxxxxxxx"
  requester_allow_remote_vpc_dns_resolution = true

  accepter_aws_assume_role_arn             = "arn:aws:iam::YYYYYYYY:role/cross-account-vpc-peering-test"
  accepter_region                          = "us-east-2"
  accepter_vpc_id                          = "vpc-yyyyyyyy"
  accepter_allow_remote_vpc_dns_resolution = true

  tags = var.tags
}
```

The `arn:aws:iam::XXXXXXXX:role/cross-account-vpc-peering-test` requester IAM Role should have the following Trust Policy:

<details><summary>Show Trust Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXX:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

</details>
<br/>

and the following IAM Policy attached to it:

__NOTE:__ the policy specifies the permissions to create (with `terraform plan/apply`) and delete (with `terraform destroy`) all the required resources in the requester AWS account

<details><summary>Show IAM Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "arn:aws:ec2:*:XXXXXXXX:route-table/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeVpcs",
        "ec2:ModifyVpcPeeringConnectionOptions",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AcceptVpcPeeringConnection",
        "ec2:DeleteVpcPeeringConnection",
        "ec2:CreateVpcPeeringConnection",
        "ec2:RejectVpcPeeringConnection"
      ],
      "Resource": [
        "arn:aws:ec2:*:XXXXXXXX:vpc-peering-connection/*",
        "arn:aws:ec2:*:XXXXXXXX:vpc/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteTags",
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:XXXXXXXX:vpc-peering-connection/*"
    }
  ]
}
```

</details>

where `XXXXXXXX` is the requester AWS account ID.

<br/>

The `arn:aws:iam::YYYYYYYY:role/cross-account-vpc-peering-test` accepter IAM Role should have the following Trust Policy:

<details><summary>Show Trust Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXX:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

</details>

__NOTE__: The accepter Trust Policy is the same as the requester Trust Policy since it defines who can assume the IAM Role.
In the requester case, the requester account ID itself is the trusted entity.
For the accepter, the Trust Policy specifies that the requester account ID `XXXXXXXX` can assume the role in the accepter AWS account `YYYYYYYY`.

and the following IAM Policy attached to it:

__NOTE:__ the policy specifies the permissions to create (with `terraform plan/apply`) and delete (with `terraform destroy`) all the required resources in the accepter AWS account

<details><summary>Show IAM Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "arn:aws:ec2:*:YYYYYYYY:route-table/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeVpcs",
        "ec2:ModifyVpcPeeringConnectionOptions",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AcceptVpcPeeringConnection",
        "ec2:DeleteVpcPeeringConnection",
        "ec2:CreateVpcPeeringConnection",
        "ec2:RejectVpcPeeringConnection"
      ],
      "Resource": [
        "arn:aws:ec2:*:YYYYYYYY:vpc-peering-connection/*",
        "arn:aws:ec2:*:YYYYYYYY:vpc/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteTags",
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:YYYYYYYY:vpc-peering-connection/*"
    }
  ]
}
```

</details>

where `YYYYYYYY` is the accepter AWS account ID.

For more information on IAM policies and permissions for VPC peering, see [Creating and managing VPC peering connections](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_IAM.html#vpcpeeringiam).

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.35.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_secret_name"></a> [requester_aws_assume_role_arn](#input\_secret\_name) | Requester AWS Assume Role ARN | `string` | n/a | yes |
| <a name="input_secret_name"></a> [requester_region](#input\_secret\_name) | Requester AWS region | `string` | n/a | yes |
| <a name="input_secret_name"></a> [requester_vpc_id](#input\_secret\_name) | Requester VPC ID filter | `string` | n/a | yes |
| <a name="input_secret_name"></a> [requester_allow_remote_vpc_dns_resolution](#input\_secret\_name) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `string` | n/a | yes |
| <a name="input_secret_name"></a> [accepter_aws_assume_role_arn](#input\_secret\_name) | Accepter AWS Assume Role ARN | `string` | n/a | yes |
| <a name="input_secret_name"></a> [accepter_region](#input\_secret\_name) | Accepter AWS region | `string` | n/a | yes |
| <a name="input_secret_name"></a> [accepter_vpc_id](#input\_secret\_name) | Accepter VPC ID filter | `string` | n/a | yes |
| <a name="input_secret_name"></a> [accepter_allow_remote_vpc_dns_resolution](#input\_secret\_name) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `string` | n/a | yes |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_name"></a> [requester_connection_id](#output\_secret\_name) | Requester VPC peering connection ID |
| <a name="output_secret_name"></a> [requester_accept_status](#output\_secret\_name) | Requester VPC peering connection request status |
| <a name="output_secret_name"></a> [accepter_connection_id](#output\_secret\_name) | Accepter VPC peering connection ID |
| <a name="output_secret_name"></a> [accepter_accept_status](#output\_secret\_name) | Accepter VPC peering connection request status |

## Resources

- resource.aws_vpc_peering_connection.requester (requester.tf#2)
- resource.aws_route.requester (requester.tf#43)
- resource.aws_vpc_peering_connection_accepter.accepter (accepter.tf#2)
- resource.aws_route.accepter (accepter.tf#32)
<!-- END_TF_DOCS -->
