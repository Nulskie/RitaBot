FROM node:16-alpine
RUN apk update && apk add git

# Force git to use HTTPS instead of SSH/Git protocols for everything
RUN git config --global url."https://github.com/".insteadOf git://github.com/
RUN git config --global url."https://github.com/".insteadOf ssh://git@github.com/

WORKDIR /app
COPY package.json ./

# Initialize a git repo in the app so hooks don't panic
RUN git init

# Install packages with ALL protections turned off, completely ignoring scripts
RUN npm install --omit=dev --ignore-scripts --no-audit --no-fund --legacy-peer-deps

COPY . .
EXPOSE 3000
CMD ["npm", "start"]
