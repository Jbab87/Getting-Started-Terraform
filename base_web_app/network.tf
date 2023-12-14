##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

##################################################################################
# DATA (Datasource configuration block) of type "aws_ssm_parameter" - a systems manager parameter
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
# (same name label can be used for different resource types - an be helpful for grouping similar resources)
# You CANNOT have 2 instances of the same resource type with the same name label in the same configuration
##################################################################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = var.aws_vpc_cdir_block
  enable_dns_hostnames = var.aws_vpc_enable_dns_hostnames_value
  tags                 = local.common_tags
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.aws.aws_vpc_public_subnets_cdir_block[0]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch_bool_val
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = local.common_tags

}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.aws.aws_vpc_public_subnets_cdir_block[1]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch_bool_val
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags                    = local.common_tags

}


# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "app_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.app.id
}


# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags


  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #Now that we have a LB - our instances should only accept traffic from
    # addresses within the VPC
    cidr_blocks = [var.aws_vpc_cdir_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Nginx security group - we creae an additional security group for our
#LB so it also allows port 80 traffic (used for HTTP connection) from anywhere
resource "aws_security_group" "alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags


  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


 