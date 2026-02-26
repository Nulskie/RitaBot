FROM node:16-alpine

RUN apk update && apk add git

# Block Git hooks
RUN echo '#!/bin/sh' > /usr/local/bin/git && \
    echo 'if [ "$1" = "config" ] && [ "$2" = "core.hooksPath" ]; then exit 0; fi' >> /usr/local/bin/git && \
    echo 'exec /usr/bin/git "$@"' >> /usr/local/bin/git && \
    chmod +x /usr/local/bin/git

WORKDIR /app
COPY . .

# 1. Force uninstall the broken package from the bot's config
RUN npm uninstall rita-google-translate-api --save

# 2. Install the OFFICIAL, working translation package
RUN npm install @vitalets/google-translate-api@8.0.0 --save

# 3. Rewrite RitaBot's source code to use the official package instead of the broken one
RUN sed -i 's/require("rita-google-translate-api")/require("@vitalets/google-translate-api")/g' src/core/translate.js

# Install the rest of the dependencies normally
RUN npm install --legacy-peer-deps

EXPOSE 3000
CMD ["npm", "start"]
