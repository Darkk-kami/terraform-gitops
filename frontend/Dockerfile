FROM node:alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./

COPY . /usr/src/app

RUN npm install

FROM node:alpine 

COPY --from=build /usr/src/app /usr/src/app

WORKDIR /usr/src/app

EXPOSE 5173

CMD [ "npm", "run", "dev", "--", "--host" ]