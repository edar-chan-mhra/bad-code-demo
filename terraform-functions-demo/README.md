# Terraform Functions Demo

This project demonstrates various Terraform built-in functions without creating any real resources. All examples use `locals` for processing and `outputs` for displaying the results.

## How to Run

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

2.  **Run a Plan**:
    ```bash
    terraform plan
    ```
    This will show you all the calculated outputs based on the functions in `main.tf`.

3.  **Apply (Optional)**:
    Since there are no resources, you can safely apply this to save the outputs to a local state file:
    ```bash
    terraform apply -auto-approve
    ```

## Functions Covered

- **String**: `upper`, `lower`, `trim`, `join`, `split`, `replace`, `substr`, `format`.
- **Numeric**: `abs`, `ceil`, `floor`, `max`, `min`, `pow`, `signum`.
- **Collection**: `element`, `lookup`, `keys`, `values`, `distinct`, `merge`, `zipmap`.
- **Encoding**: `jsonencode`, `base64encode`.
- **Logic / Date**: `can`, `try`, `coalesce`, `timestamp`, `formatdate`.
