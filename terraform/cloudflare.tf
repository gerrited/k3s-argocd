# Generates a 64-character secret for the tunnel.
# Using `random_password` means the result is treated as sensitive and, thus,
# not displayed in console output. Refer to: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
# resource "random_password" "tunnel_secret" {
#   length = 64
# }

# # Creates a new locally-managed tunnel
# resource "cloudflare_tunnel" "auto_tunnel" {
#   account_id = var.cloudflare_account_id
#   name       = "cluster"
#   secret     = base64sha256(random_password.tunnel_secret.result)
# }

# Creates the CNAME record that routes argocd.${var.cloudflare_zone} to the tunnel.
resource "cloudflare_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = "argocd"
  value   = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "daily-workout" {
  zone_id = var.cloudflare_zone_id
  name    = "daily-workout"
  value   = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "burry" {
  zone_id = var.cloudflare_zone_id
  name    = "l"
  value   = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "faas" {
  zone_id = var.cloudflare_zone_id
  name    = "faas"
  value   = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "k3s" {
  zone_id = var.cloudflare_zone_id
  name    = "k3s"
  value   = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

# Creates the configuration for the tunnel.
resource "cloudflare_tunnel_config" "auto_tunnel" {
  tunnel_id  = var.cloudflare_tunnel_id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.k3s.hostname
      service  = "http://dotnet-webapi:80"
    }
    ingress_rule {
      hostname = cloudflare_record.faas.hostname
      service  = "http://gateway-external.openfaas.svc.cluster.local:8080"
    }
    ingress_rule {
      hostname = cloudflare_record.argocd.hostname
      service  = "http://argocd-server.argocd.svc.cluster.local:80"
    }
    ingress_rule {
      hostname = cloudflare_record.daily-workout.hostname
      service  = "http://daily-workout:80"
    }
    ingress_rule {
      hostname = cloudflare_record.burry.hostname
      service  = "http://burry:80"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# # Creates an Access application to control who can connect.
# resource "cloudflare_access_application" "http_app" {
#   zone_id          = var.cloudflare_zone_id
#   name             = "Access application for http_app.${var.cloudflare_zone}"
#   domain           = "http_app.${var.cloudflare_zone}"
#   session_duration = "1h"
# }

# # Creates an Access policy for the application.
# resource "cloudflare_access_policy" "http_policy" {
#   application_id = cloudflare_access_application.http_app.id
#   zone_id        = var.cloudflare_zone_id
#   name           = "Example policy for http_app.${var.cloudflare_zone}"
#   precedence     = "1"
#   decision       = "allow"
#   include {
#     email = [var.cloudflare_email]
#   }
# }