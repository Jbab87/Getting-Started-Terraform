data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES # EC2 instance
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value) # we reference our datasource
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags                   = local.common_tags


  # Here we are sending some user-data to our instance - this is a script that will run when the instance starts up for the first time
  # we install nginx, start it up, delete the default index.html file and replace it with something else
  #Syntax used is known as Heredoc syntax - a way of specifying a large block of text that shouldn't be interpreted in any way
  #Easy way to specify a script inline  
  # <<EOF  <text> EOF

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value) # we reference our datasource
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags                   = local.common_tags


  # Here we are sending some user-data to our instance - this is a script that will run when the instance starts up for the first time
  # we install nginx, start it up, delete the default index.html file and replace it with something else
  #Syntax used is known as Heredoc syntax - a way of specifying a large block of text that shouldn't be interpreted in any way
  #Easy way to specify a script inline  
  # <<EOF  <text> EOF

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 2</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

}