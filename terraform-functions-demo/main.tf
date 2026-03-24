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

# Legacy null resource commonly used for triggers
resource "null_resource" "demo_trigger" {
  triggers = {
    now = timestamp()
  }
}

# Randomizers (useful for unique naming)
# These generate values and store them in state, but don't touch any cloud provider.
resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

output "resource_outputs" {
  value = {
    pet_name     = random_pet.server_name.id
    stored_input = terraform_data.demo_data.output
  }
}
