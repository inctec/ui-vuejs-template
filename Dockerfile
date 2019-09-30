# This image is based on the oficial nodejs docker image
FROM node:12 AS builder

# RUN echo “@edge http://nl.alpinelinux.org/alpine/edge/main” >> /etc/apk/repositories
# packages required for bcrypt
RUN apt-get install \
        python \
        g++ \
        make \
        bash \
        coreutils 

RUN npm i -g npm
COPY package*.json ./
RUN npm ci
COPY ./ ./
RUN npm run-script build

FROM nginx:1.16-alpine AS prod
COPY --from=builder dist /usr/share/nginx/html
EXPOSE 443
EXPOSE 80
RUN mkdir /etc/nginx/ssl
RUN ls -a /etc/nginx/ssl

