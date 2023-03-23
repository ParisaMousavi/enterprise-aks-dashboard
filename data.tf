data "template_file" "dashboard" {
  template = file("${path.module}/dashboard-tmplate/dashboard-tmplate.json")
  vars = {}
}

data "template_file" "usage" {
  template = file("${path.module}/queries/usage.json")
  vars = {}
}