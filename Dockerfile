FROM node:16-alpine
RUN apk update && apk add git
WORKDIR /app
COPY package.json ./
RUN git init && npm install --omit=dev --ignore-scripts
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
