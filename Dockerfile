FROM node:10.13-alpine as builder

# copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /react-ui && mv ./node_modules ./react-ui

WORKDIR /react-ui

COPY . .
# Build the project and copy the files
RUN npm run build


FROM nginx

#!/bin/sh
COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf
ARG REACT_APP_API_URL

ENV REACT_APP_API_URL=$REACT_APP_API_URL
## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /react-ui/build /usr/share/nginx/html

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]