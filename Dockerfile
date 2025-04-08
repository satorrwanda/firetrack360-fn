# Use a lightweight Nginx base image
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the Flutter web build output
COPY build/web /usr/share/nginx/html

# Optional: Copy custom nginx config (see below)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 4000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
