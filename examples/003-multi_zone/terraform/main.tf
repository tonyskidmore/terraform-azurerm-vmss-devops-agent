terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.4.3"
    }
    http = {
      source  = "hashicorp/http"
      version = "~>3.2.1"
    }
  }
  required_version = ">= 1.1.0"
}

data "http" "example" {
  url = "https://checkpoint-api.hashicorp.com/v1/check/terraform"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

resource "random_uuid" "example" {
  lifecycle {
    precondition {
      condition     = contains([200], data.http.example.status_code)
      error_message = "Status code invalid"
    }
  }
}
