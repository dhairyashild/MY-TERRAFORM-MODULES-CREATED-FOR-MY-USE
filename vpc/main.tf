1) tags made he kayam thev 
         "${var.projectname}-${var.environment}-private-data-az2"    ="${var.projectname}-${var.env}-resource_shortform"
          ${   } =  interpolation karay he 2 lagat only

2) mi kay add kelay he search karay 3# use kara khalche
                                                 ###
############## sequence to create whole vpc --ONLY REMEMBER THIS NO NOTEBOOK OR OTHER NOTES ###################################################################################
1 vpc
cidr_block           = var.vpc-cidr
tag
# use data source to get all AZ use for real code not in interview . use direct "ap-south-1"/2/3 for interview
data "aws_availability_zones" "available_zones" {}

2 subnet pub + pvt
vpc_id = aws_vpc.vpc.id
cidr_block              = var.public-sub-az1-cidr
availability_zone       = data.aws_availability_zones.available_zones.names[0]
map_public_ip_on_launch = true  / flase  --->Bydefault FALSE so as per public subnet true and pvt false  
### u add this above line     ### only string la " " mde liha   ### boolean / single number/ data fetch karat asel trihi lagat nhi " "
tags 

3 route table  2 banava pub and pvt
-pub rt with                 gateway_id = aws_internet_gateway.gw.id
-pvt rt with                 gateway_id = aws_nat_gateway.example.id

  a)ipv6 block comment out kara  
  b)vpc_id = aws_vpc.example.id          #change
  c) route {
    cidr_block = "10.0.1.0/24"          #####  "0.0.0.0/0" kara for both nat amd igw          
    gateway_id = aws_internet_gateway.example.id  /  gateway_id = aws_nat_gateway.example.id  #change 1st for pub/ 2nd for pvt RT 
           }

4 subnet rt association he rt.tf mdech tak khali
5 igw                        var RT mde add kara id
6 nat                        var RT mde add kara id
-resource "aws_eip" "lb"                           -banava
resource "aws_eip" "lb" {
#  instance = aws_instance.web.id                   ### comment out we want dont connect it to ec2
  domain   = "vpc"
}

-resource "aws_nat_gateway" "example"              -banava
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id               ### no change-- kay hay kay ki
  subnet_id     = aws_subnet.example.id            ### change

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.example]
}


################################################################################################################33






# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr     ### give this in variable or direct here           
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.projectname}-vpc"
  }
}





# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}




# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = var.public-sub-az1-cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.projectname}-${var.environment}-public-az1"
  }
}



# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = var.app-private-sub-az1-cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.projectname}-${var.environment}-private-app-az1"
  }
}



# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"                                 # add this--to go on internet
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.projectname}-${var.environment}-public-rt"
  }
}



resource "aws_route_table" "pvt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                      # change to all 0
    gateway_id = aws_nat_gateway.example.id       # change here add nat gateway above internet gateway
  }

  tags = {
    Name = "${local.env}-pvt-rt"
  }
}







# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id           ### change if need
  route_table_id = aws_route_table.public_route_table.id     ### change if need
}




# associate pvt subnet az1 to "pvt route table"
resource "aws_route_table_association" "pvt_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.pvt_subnet_az1.id           ### change if need
  route_table_id = aws_route_table.pvt_route_table.id     ### change if need
}





# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id                 ### change if need

  tags = {
    Name = "${var.projectname}-igw"
  }
}






resource "aws_eip" "lb" {
  domain   = "vpc"
}




resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.pub-1a.id

  tags = {
    Name = "${local.env}-nat"
  }
  depends_on = [aws_internet_gateway.gw]
}

