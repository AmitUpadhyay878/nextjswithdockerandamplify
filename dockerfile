# FROM node:18-alpine AS development
# WORKDIR /app
# ENV HOST=0.0.0.0
# ENV PORT=3000
# ENV NODE_ENV=development
# EXPOSE 3000
# CMD [ "yarn", "dev" ]

# FROM node:18-alpine AS dependencies
# ENV NODE_ENV=production
# WORKDIR /app
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile

# FROM node:18-alpine AS builder
# ENV NODE_ENV=development
# WORKDIR /app
# COPY . .
# RUN yarn install --frozen-lockfile && NODE_ENV=production yarn build

# FROM node:18-alpine AS production
# WORKDIR /app
# ENV HOST=0.0.0.0
# ENV PORT=3000
# ENV NODE_ENV=production
# COPY --chown=node --from=builder /app/next.config.js ./
# COPY --chown=node --from=builder /app/public ./public
# COPY --chown=node --from=builder /app/.next ./.next
# COPY --chown=node --from=builder /app/yarn.lock /app/package.json ./
# COPY --chown=node --from=dependencies /app/node_modules ./node_modules
# USER node
# EXPOSE 3000
# CMD [ "yarn", "start" ]

FROM node:20-alpine AS development
WORKDIR /app
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=development
EXPOSE 3000
CMD [ "npm", "run", "dev" ]

FROM node:20-alpine AS dependencies
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json ./ 
RUN npm ci

FROM node:20-alpine AS builder
ENV NODE_ENV=development
WORKDIR /app
COPY . . 
RUN npm ci && NODE_ENV=production npm run build

FROM node:20-alpine AS production
WORKDIR /app
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production
COPY --chown=node --from=builder /app/next.config.js ./ 
COPY --chown=node --from=builder /app/public ./public
COPY --chown=node --from=builder /app/.next ./.next
COPY --chown=node --from=builder /app/package.json /app/package-lock.json ./ 
COPY --chown=node --from=dependencies /app/node_modules ./node_modules
USER node
EXPOSE 3000
CMD [ "npm", "start" ]
