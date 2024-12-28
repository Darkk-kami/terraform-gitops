# Generate Nginx config file using template with dynamic domain variable
resource "local_file" "nginx_config" {
  filename = "${path.module}/../../dependencies/nginx/nginx.conf"
  content  = templatefile("${path.module}/../../templates/nginx.conf.tpl", {
    domain = var.domain
  })
}

# Generate Grafana config file using template with dynamic domain variable
resource "local_file" "grafana_ini" {
  filename = "${path.module}/../../dependencies/grafana/grafana.ini"
  content  = templatefile("${path.module}/../../templates/grafana.ini.tpl", {
    domain = var.domain
  })
}

# Generate Frontend env file for deployment with dynamic domain variable
resource "local_file" "frontend_var" {
  filename = "${path.module}/../../dependencies/env/.frontend-env"
  content  = templatefile("${path.module}/../../templates/frontend-env.tpl", {
    domain = var.domain
  })
}

# Generate backend env file for deployment with dynamic domain variable
resource "local_file" "backend_var" {
  filename = "${path.module}/../../dependencies/env/.backend-env"
  content  = templatefile("${path.module}/../../templates/backend-env.tpl", {
    domain = var.domain
  })
}

# Generate docker compose file
resource "local_file" "docker_compose" {
  filename = "${path.module}/../../dependencies/docker-compose.yaml"
  content  = templatefile("${path.module}/../../templates/docker-compose.tpl", {
    domain = var.domain
  })
}




