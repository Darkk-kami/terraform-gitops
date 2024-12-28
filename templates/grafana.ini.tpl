[server]
protocol = http
http_port = 3000

serve_from_sub_path = true

domain = ${domain}
enforce_domain = true
root_url = https://${domain}/grafana/
cert_file = /etc/grafana/cert.pem
cert_key = /etc/grafana/privkey.pem