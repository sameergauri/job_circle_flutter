FROM nginx:1.9.15-alpine
ADD build/web /usr/share/nginx/html 
EXPOSE 80
# ENTRYPOINT [ "java", "-jar", "JobCircleApi.war"]