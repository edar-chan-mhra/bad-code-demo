locals {
  # String examples
  string_data = {
    original = "  Hello Terraform World!  "
    prefix   = "v1.0-"
    suffix   = "-dev"
  }

  # Numeric examples
  number_data = [10, -5, 3.14, 2.71]

  # List examples
  list_data = ["apple", "banana", "cherry", "apple"]

  # Map examples
  map_data = {
    name    = "John Doe"
    role    = "Engineer"
    project = "Antigravity"
  }
}

# --- STRING FUNCTIONS ---
output "string_functions" {
  value = {
    upper      = upper(local.string_data.original)
    lower      = lower(local.string_data.original)
    trim       = trim(local.string_data.original, " ")
    trimprefix = trimprefix("v1.0-myapp", local.string_data.prefix)
    trimsuffix = trimsuffix("myapp-dev", local.string_data.suffix)
    join       = join("|", local.list_data)
    split      = split(",", "one,two,three")
    replace    = replace(local.string_data.original, "World", "Cloud")
    substr     = substr(local.string_data.original, 2, 5) # "Hello"
    title      = title("hello from terraform")
    format     = format("The ratio is %.2f", 3.14159)
  }
}

# --- NUMERIC FUNCTIONS ---
output "numeric_functions" {
  value = {
    abs    = abs(local.number_data[1])
    ceil   = ceil(local.number_data[2])
    floor  = floor(local.number_data[3])
    max    = max(10, 20, 5)
    min    = min(1, 0, -1)
    pow    = pow(2, 10)
    signum = signum(local.number_data[1])
  }
}

# --- COLLECTION FUNCTIONS ---
output "collection_functions" {
  value = {
    element   = element(local.list_data, 1) # banana
    lookup    = lookup(local.map_data, "role", "unknown")
    keys      = keys(local.map_data)
    values    = values(local.map_data)
    distinct  = distinct(local.list_data)
    length    = length(local.list_data)
    reverse   = reverse(local.list_data)
    contains  = contains(local.list_data, "cherry")
    index     = index(local.list_data, "cherry")
    flatten   = flatten([["a"], ["b", "c"]])
    merge     = merge(local.map_data, { status = "active" })
    zipmap    = zipmap(["k1", "k2"], ["v1", "v2"])
  }
}

# --- ENCODING & DATE FUNCTIONS ---
output "encoding_and_date_functions" {
  value = {
    jsonencode = jsonencode(local.map_data)
    base64encode = base64encode("Planetary Scale")
    # Date functions (using timestamp() which changes every run)
    current_timestamp = timestamp()
    formatted_date   = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
  }
}

# --- TEST & ERROR HANDLING FUNCTIONS ---
output "logic_and_error_functions" {
  value = {
    can_success  = can(1 / 1)
    can_fail     = can(1 / 0)
    try_success  = try(123, "fallback")
    try_fallback = try(local.map_data["nonexistent"], "default_value")
    coalesce     = coalesce(null, "", "found_me") # returns empty string because it's not null
    coalesce_2   = coalesce(null, "use_this", "ignored")
  }
}

# --- INFRASTRUCTURE-LESS RESOURCES ---

# Modern resource for storing data without infrastructure (TF 1.4+)
resource "terraform_data" "demo_data" {
  input = "This is stored in state but creates nothing."
}

# --- EXAM CONCEPTS: ADVANCED RESOURCES ---

# Exam Concept: count
# Use 'count' for simple identical copies.
resource "terraform_data" "counted_example" {
  count = 2
  input = "Count index: ${count.index}"
}

# Exam Concept: for_each
# Use 'for_each' for distinct resources based on a map or set.
resource "terraform_data" "foreach_example" {
  for_each = toset(["east", "west"])
  input    = "Region: ${each.key}"
}

# Exam Concept: Local Module Call
module "exam_helper" {
  source    = "./modules/exam-demo"
  input_val = "hello from root"
}

# Exam Concept: Lifecycle rules
resource "terraform_data" "lifecycle_demo" {
  input = "change me"

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true  # Warning: This prevents 'terraform destroy'
    ignore_changes        = [input] # Changes to this won't trigger updates
  }
}

# Exam Concept: Provisioners (local-exec)
resource "terraform_data" "provisioner_demo" {
  input = "test"

  provisioner "local-exec" {
    command = "echo 'Resource created at $(date)' > execution_log.txt"
  }

  # Exam Concept: depends_on
  depends_on = [terraform_data.demo_data]
}

# Exam Concept: Dynamic Blocks (often used for nested configuration)
# Demonstration using a local map to pretend we are configuring something complex
locals {
  custom_settings = {
    "setting1" = "value1"
    "setting2" = "value2"
  }
}

resource "terraform_data" "dynamic_block_demo" {
  # dynamic blocks are usually used inside resources that support nested blocks (like aws_security_group ingress)
  # Here we use 'input' just to show syntax logic as terraform_data doesn't have nested blocks.
  input = jsonencode({
    for k, v in local.custom_settings : k => v
  })
}

output "exam_outputs" {
  value = {
    module_output = module.exam_helper.processed_val
    foreach_ids   = [for r in terraform_data.foreach_example : r.id]
    counted_ids   = terraform_data.counted_example[*].id
    sensitive_pw  = var.db_password # This will be marked (sensitive value) in output
  }
  sensitive = true # Exam Concept: sensitve = true is required if output contains sensitive data
}
