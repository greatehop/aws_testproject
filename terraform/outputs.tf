output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "The public IP address of the web server"
}


//### The Ansible inventory file
//resource "local_file" "AnsibleInventory" {
//  content = templatefile("inventory.tmpl",  {
//    bastion-ip = aws_eip.eip-bastion.public_ip})
// filename = "inventory"
//}