variable "input_val" {
  type = string
}

resource "terraform_data" "module_resource" {
  input = var.input_val
}

output "processed_val" {
  value = upper(terraform_data.module_resource.output)
}
