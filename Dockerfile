FROM node:16-alpine

# Install real git
RUN apk update && apk add git

WORKDIR /app
COPY package.json ./

# Create a fake "git" wrapper that intercepts and kills the "git config core.hooksPath" command
RUN echo '#!/bin/sh' > /usr/local/bin/git && \
    echo 'if [ "$1" = "config" ] && [ "$2" = "core.hooksPath" ]; then exit 0; fi' >> /usr/local/bin/git && \
    echo 'exec /usr/bin/git "$@"' >> /usr/local/bin/git && \
    chmod +x /usr/local/bin/git

# Run install 
RUN npm install --omit=dev --legacy-peer-deps

COPY . .
EXPOSE 3000
CMD ["npm", "start"]
