FROM node:22 AS development
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY src/ ./src
CMD ["npm", "run", "dev"]

FROM node:22 AS production-dependencies
WORKDIR /app
COPY package*.json .
RUN npm ci --only=production

FROM grc.io/distroless/node:22 AS production
WORKDIR /app
COPY --from=production-dependencies /app/node_modules ./node_modules
COPY src/ ./src
CMD ["src/index.js"]