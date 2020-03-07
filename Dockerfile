# syntax=docker/dockerfile:experimental
FROM node:12.15.0

COPY . /app/frontend
WORKDIR /app/frontend

ENV API_HOST=127.0.0.1 API_PORT=80 API_PREFIX=/api API_URL_BROWSER=/api TZ="Asia/Tokyo"

RUN yarn install \
  && yarn build

EXPOSE 3000

ENTRYPOINT ["yarn"]
CMD ["start"]
