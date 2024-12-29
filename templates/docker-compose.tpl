services:

# Application Stack

  frontend:
    image: darkkami/frontend-template
    ports:
      - '5173:5173'
    env_file:
      - ./dependencies/env/.frontend-env
    logging:
      driver: json-file
      options:
        tag: "{{.Name}}"
    networks:
      - app-network

  backend:
    image: darkkami/backend-template
    ports:
      - '8000:8000'
    env_file:
      - ./dependencies/env/.backend-env
    logging:
      driver: json-file
      options:
        tag: "{{.Name}}"
    networks:
      - app-network
    depends_on:
      - database

  database:
    image: postgres
    restart: always
    ports:
      - '5432:5432'
    env_file:
      - ./dependencies/env/.backend-env
    logging:
      driver: json-file
      options:
        tag: "{{.Name}}"
    volumes:
      - db-vol:/var/lib/postgresql/data
    networks:
      - app-network

  adminer:
    image: adminer:latest
    container_name: adminer
    environment:
      ADMINER_DEFAULT_SERVER: database
    restart: always
    ports:
      - '8080:8080'
    networks:
      - app-network

  proxy:
    image: jc21/nginx-proxy-manager
    container_name: proxy
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./dependencies/nginx/nginx.conf:/data/nginx/custom/http_top.conf 
      - /etc/letsencrypt/:/etc/letsencrypt  
    depends_on:
      - frontend 
      - backend   
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  grafana_data:
  db-vol:
    driver: local
