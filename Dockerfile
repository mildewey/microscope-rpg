FROM mhart/alpine-node:14 AS build-app
WORKDIR /app
COPY . .
RUN npm install --no-audit --unsafe-perm
RUN npm run build

#=======================

FROM mhart/alpine-node:14 AS build-runtime
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --production --unsafe-perm

#=======================

FROM mhart/alpine-node:slim-12
WORKDIR /app
COPY --from=build-app /app/dist ./dist
COPY --from=build-app /app/static ./static
COPY --from=build-runtime /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "dist"]
