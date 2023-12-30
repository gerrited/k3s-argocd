# The configuration for the `remote` backend.
terraform {
    backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "k3s-g11s"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
        name = "k3s"
    }
    }
}

# An example resource that does nothing.
resource "null_resource" "example" {
    triggers = {
    value = "A example resource that does nothing!"
    }
}