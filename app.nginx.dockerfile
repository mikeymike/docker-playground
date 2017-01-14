FROM nginx:latest
MAINTAINER Michael Woodward <michael@wearejh.com>

ARG BUILD_ENV=dev
ENV PROD_ENV=prod

RUN rm /etc/nginx/conf.d/default.conf

COPY .docker/nginx/sites /etc/nginx/conf.d

RUN [ "$BUILD_ENV" = "$PROD_ENV" ] \
    && rm /etc/nginx/conf.d/site.dev.conf \
    || rm /etc/nginx/conf.d/site.prod.conf

COPY pub /var/www/pub

CMD ["nginx", "-g", "daemon off;"]