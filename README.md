TERRAFORM MAIN POINTS

key_name   = "deployer-key"

security_groups = ["aws_vpc_security_group_ingress_rule.allow_tls_ipv4.name"]
end la NAME dene mi ID deto ha error

user_data = base64encode(<<-EOF


file provisioner made connections var click kelyavar tyacha block disto
password jagi private_key ghala

remote-exec
inline == to give command direct
scripts== to give bash scripts start with #!/bin/bash
remote exec changes in script detect karat nahi—gaurav

Data Blocks for Existing Resources: Data blocks are primarily used to fetch information about resources that already exist outside of your current Terraform configuration or resources created in previous runs.

terraform apply -lock=false                                                —for debug

T plan do not create new statefile

T plan do not create new statefile

  key        = "path/to/your/${terraform.workspace}/terraform.tfstate"

locals for  fixed values within a module, and

 variables for parameters you expect to change based on deployment conditions or user input.

variable "users_age" {
  type = map(number)  # Define variable type as  map with number 
  default = {   
    "gaurav" = 20,         # separate pairs with commas
    "saurav" = 19 
  }
}
string{"ajit1, aj2, wina}  alphanumeric
number
bool
list——list(string) / list(number)
map——map(string)  / map(number)
set ==list but no duplicate value   —-set(string) / set(number)
objects 
tuple—-can use string, number, bool all datatype in combine with tuple


SUMMERY OF RUNTIME VARIABLE 
1) Command Line (-var, -var-file)=
terraform apply -var="instance_type=t2.micro" ####LASTLA  -var= "x=y"
2) *.auto.tfvars
3) terraform.tfvars
4) *.tfvar        (dev.tfvar)
5) Environment Variables (export TF_VAR_instance_type=t2.micro)####export la no symbol

realtime we dont use registry modules
we use manually created own modules

calling variable value use 2nd method best practice
1) instance_type = "${var.instance_types[0]}"
                 # change index number if list isthere
2) instance_type = var.instance_types[0]

terra ask variable only if not given in .tf file

list use for giveng multiple SG to ec2

terraform init add 2 files
terraform.lock.hcl               ,   .terraform

+   =add
-    = delete
~   = update value

Output blocks DEF=used to extract and display useful information about resources managed by Terraform.
-Resource Information Retrieval: Capture essential data like public IP addresses, DNS names, and resource IDs for further automation or configuration.
-Outputs used in  CI/CD Pipelines
eg1-public IP of an EC2 instance for use in security group rules.
eg2-Sharing VPC IDs or subnet IDs with other Terraform configurations or external tools.
output "           "{
value= "${aws_instance.ec2.ATTRIBUTE}        # attribute from registry 
 }

terraform secret handling
Environment Variables
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"

terraform console
var.instance_type            ####this u gave which value u want, it gave var value below
Querying Variables: You can access variable values directly by referencing them, e.g., var.variable_name.


terraform validate command checks the SYNTAX and internal consistency of Terraform configuration files

terraform fmt—give proper readability and INDENTATION

1) manual create ssh 
ssh-keygen -t rsa
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "####PASTE HERE PUB KEY DATA"
}
———————————
2)  create pvt key via terra
# THIS IS PVT KEY RESOURCE
resource "tls_private_key" "rsa-4096-example" {}


#WE NEED TO STORE ABOVE PVT KEY
resource "local_file" "foo" {}
#THIS IS PUBLIC KEY
resource "aws_key_pair" "deployer" {}


aws_security_group
—GIVE VPC ID
####INGRESS SG
—from_port         = 443
  to_port           = 443
SAME PORTNUMBER  RANGE SO ONLY THAT PORT OPEN
—- cidr_ipv4         = aws_vpc.main.cidr_block
GIVE HERE 0.0.0.0/0 OR WHICH IP RANGE U WANT TO OPEN PORT
######DO NOT CHANGE EGRESS

security_groups: Use this when launching instances in EC2-Classic or the default VPC.
vpc_security_group_ids:   launching instances in a non-default VPC.

terraform taint aws_instance.myinstance

it will mark this ec2 as tainted mean damaged and recreate it again when u teraform apply command agin 

use this in dev stage mostly

Undo: Use terraform untaint <resource_name>

user_data = base64encode(<<-EOF   ####remember line
    #!/bin/bash    
    sudo apt-get update -y
    sudo apt-get install apache2 -y
    sudo systemctl start apache2 
  EOF
-user_data ENABLE AUTOMATIC CONFIGURATION of EC2 instances
-Runs on First Boot only
####must be in Base64 encoding
-Limitations: If there are errors in the user_data script, they may not be immediately visible; you may need to check logs (e.g., /var/log/cloud-init.log) on the instance for troubleshooting.

user_data = file("${path.module}/script.sh")
user_data = file("script.sh")
ABOVE BOTH CODELINES SAME

file provisioner =
failure of provisioneer mark resource as tainted automatically so again terra apply will delete ec2 and again run provisioner so use carefully—gaurav



remote exec— 1)for runnig command after resource created
                               2) can be used multiple time

user data—1) run script while booting of ec2
                        2) can be used 1 time on boostrap ec2
-Automatically install software packages (e.g., web servers like Nginx or Apache) on newly created instances.
-run custom scripts that perform complex configurations

inline == to give command direct
inline[
"sudo apt-get update -y"
]   
OR
scripts="./shell.sh"           #####to give bash scripts start with #!/bin/bash
remote exec changes in script detect karat nahi—gaurav.so terraform also tell use provisioner last option

terraform import 
manage manually created infra as code
disaster recovery
1——-resource "aws_instance" "example" {}
2——--terraform import aws_instance.example i-1234567890abcdef0
3——Verify State: After importing, run terraform plan
-single resource import

terraform import block—
add a resource both to the configuration file and to Terraform state in a single process.
ideal for automating multiple imports as part of a larger infrastructure codebase.
1—-import {
  to = "aws_instance.example_ec2"
  id = "i-0abcd1234efgh5678"  # Replace with your EC2 instance ID
}
2———-RESOURCE BLOCKS
resource "aws_instance" "example_ec2" {}
3———-terraform plan -generate-config-out=ImportResources.tf
4 Review the Generated Configuration: ImportResources.tf
5 copy code into main.tf from ImportResources.tf if u want
6 Deleting ImportResources.tf after verification and running terraform apply ensures that your infrastructure remains consistent without duplicating resource definitions
7 terraform apply -auto-approve

locals for  fixed values within a module, and
 variables for parameters you expect to change based on deployment conditions or user input.

map—-we use key-value of tags in realtime

${terraform.workspace}: Automatically uses the workspace name (dev or prod)


