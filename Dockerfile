FROM node:16-alpine AS build

WORKDIR /app

COPY . .

RUN npm install && npm run build

###################################################

FROM nginx:alpine

RUN adduser -D reactuser

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx /tmp/nginx
RUN chown -R reactuser:reactuser /var/cache/nginx /var/run /var/log/nginx /tmp/nginx

RUN rm /etc/nginx/nginx.conf

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R reactuser:reactuser /usr/share/nginx/html /etc/nginx/nginx.conf

EXPOSE 80

USER reactuser

CMD ["nginx", "-g", "pid /tmp/nginx/nginx.pid; daemon off;"]
