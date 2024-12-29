# ...................................Monitoring Stack .........................................................
services:

# Prometheus stack
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./dependencies/scripts/prometheus.yaml:/etc/prometheus/prometheus.yml
    restart: always
    networks:
      - app-network

  node-exporter:
    image: prom/node-exporter
    container_name: node-exporter
    ports:
      - "9100:9100"
    restart: always
    networks:
      - app-network

  blackbox_exporter:
    image: prom/blackbox-exporter
    container_name: blackbox_exporter
    ports:
      - "9115:9115"
    volumes:
      - ./dependencies/scripts/blackbox.yml:/etc/blackbox_exporter/blackbox.yml
    restart: always
    networks:
      - app-network

# Grafana stack
  grafana:
    image: grafana/grafana
    container_name: grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./dependencies/grafana/grafana.ini:/etc/grafana/grafana.ini
      - ./dependencies/grafana/default.yaml:/etc/grafana/provisioning/dashboards/default.yaml
      - ./dependencies/grafana/datasource.yaml:/etc/grafana/provisioning/datasources/datasources.yaml
      - ./dependencies/grafana/dashboards:/var/lib/grafana/dashboards
      - /etc/letsencrypt/live/${domain}/cert.pem:/etc/grafana/cert.perm
      - /etc/letsencrypt/live/${domain}/privkey.pem:/etc/grafana/privkey.pem 
    restart: always
    depends_on:
      - prometheus
    networks:
      - app-network

  loki:
    image: grafana/loki
    container_name: loki
    volumes:
      - ./dependencies/scripts/loki-config.yaml:/etc/loki/config.yaml
    command: -config.file=/etc/loki/local-config.yaml
    ports:
      - "3100:3100"
    restart: always
    networks:
      - app-network


  promtail:
    image: grafana/promtail
    container_name: promtail
    volumes:
      - /var/log:/var/log
      - /var/lib/docker/containers:/var/lib/docker/containers
      - ./dependencies/scripts/promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
    depends_on:
      - loki
    restart: always
    networks:
      - app-network


  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8081:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    restart: always
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  grafana_data:
  db-vol:
    driver: local