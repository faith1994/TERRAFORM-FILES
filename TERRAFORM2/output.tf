/*output = ip address
description = i want to get the eip address for my public server
value = aws_instance.ec2_webserver.public_ip*/

output  "ip-ddress" {
description = "i want to get the eip address for my private server"
value = aws_instance.ec2_webserver2.private_ip
}