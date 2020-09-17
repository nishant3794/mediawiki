variable "app" { }
data "template_file" "prod" {
  template = "${file("${path.module}/service/${var.app}/userdata.sh.tpl")}"
}
output "user-data" { value = "${data.template_file.prod.rendered}" }