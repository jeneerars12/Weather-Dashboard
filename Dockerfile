FROM nginx:alpine
COPY ["Live Weather Forecast Application.html", "/usr/share/nginx/html/index.html"]
EXPOSE 80
