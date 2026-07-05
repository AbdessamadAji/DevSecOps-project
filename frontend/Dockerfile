FROM nginx:1.31.2

# Create directories and give permissions to nginx user (UID 101)
RUN mkdir -p /tmp/nginx \
    /var/cache/nginx \
    /var/run && \
    chown -R 101:101 /tmp/nginx /var/cache/nginx /var/run /usr/share/nginx/html /etc/nginx

COPY dist/ /usr/share/nginx/html/

USER 101:101

EXPOSE 8080  # we can't use 80 because we can't change permissions

CMD ["nginx", "-g", "daemon off;"]
