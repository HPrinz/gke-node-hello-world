FROM node:latest as base
WORKDIR /build
COPY package*.json ./
RUN npm install && npm install -g jest
COPY . .

FROM base as deps
ENV NODE_ENV test
RUN npm test

FROM base AS release
EXPOSE 3000
CMD [ "npm", "start" ]
