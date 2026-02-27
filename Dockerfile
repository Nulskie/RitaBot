FROM node:16-alpine

RUN apk update && apk add git

# Block Git hooks
RUN echo '#!/bin/sh' > /usr/local/bin/git && \
    echo 'if [ "$1" = "config" ] && [ "$2" = "core.hooksPath" ]; then exit 0; fi' >> /usr/local/bin/git && \
    echo 'exec /usr/bin/git "$@"' >> /usr/local/bin/git && \
    chmod +x /usr/local/bin/git

WORKDIR /app
COPY . .

# 1. Install all deps first (so package-lock is respected)
RUN npm install --legacy-peer-deps

# 2. Force-replace the broken package AFTER full install
RUN npm uninstall rita-google-translate-api --save
RUN npm install @vitalets/google-translate-api@8.0.0 --save

# 3. Patch the source to use the correct package
RUN sed -i 's/require("rita-google-translate-api")/require("@vitalets\/google-translate-api")/g' src/core/translate.js

EXPOSE 3000
CMD ["npm", "start"]
