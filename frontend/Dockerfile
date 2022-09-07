FROM node:16.4.2-alpine
RUN mkdir -p /usr/src/app
COPY ./frontend-app/* /usr/src/app/
COPY ./frontend-app/src /usr/src/app/src
COPY ./frontend-app/public /usr/src/app/public
WORKDIR /usr/src/app
RUN npm install
RUN npm run build
CMD npm run start