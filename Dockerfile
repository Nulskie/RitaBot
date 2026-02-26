FROM node:16-alpine
RUN apk update && apk add git

# Globally tell git to ignore any hooks
RUN git config --global core.hooksPath /dev/null

WORKDIR /app
COPY package.json ./

# Change ownership to the built-in 'node' user so NPM doesn't run as root
RUN chown -R node:node /app
USER node

# Run install as the node user with all safety bypasses
RUN npm install --omit=dev --ignore-scripts --no-audit --no-fund

COPY --chown=node:node . .
EXPOSE 3000
CMD ["npm", "start"]
