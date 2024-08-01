FROM debian:bookworm

RUN apt-get update -y && apt-get upgrade && apt-get install -y \
	procps \
	npm

COPY config/vite.config.ts /vite.config.ts
COPY docker-entrypoint.sh /

WORKDIR /app

EXPOSE 5173

ENTRYPOINT [ "/docker-entrypoint.sh" ]
