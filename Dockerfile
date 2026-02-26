FROM node:16-alpine

RUN apk update && apk add git

# Block Git hooks
RUN echo '#!/bin/sh' > /usr/local/bin/git && \
    echo 'if [ "$1" = "config" ] && [ "$2" = "core.hooksPath" ]; then exit 0; fi' >> /usr/local/bin/git && \
    echo 'exec /usr/bin/git "$@"' >> /usr/local/bin/git && \
    chmod +x /usr/local/bin/git

WORKDIR /app
COPY package.json ./

# Install all packages normally
RUN npm install --legacy-peer-deps

# Create the missing directory and dump a raw CommonJS version of the API into it
RUN mkdir -p node_modules/rita-google-translate-api/dist/cjs && \
    echo 'const translate = require("@vitalets/google-translate-api"); module.exports = translate;' > node_modules/rita-google-translate-api/dist/cjs/index.cjs

COPY . .
EXPOSE 3000
CMD ["npm", "start"]
