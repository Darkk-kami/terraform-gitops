[web]
${join("\n", [for ip in split(",", private_ips) : "${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible.pem"])}

