FROM debian:bookworm

WORKDIR /app

RUN apt-get update -y && apt-get upgrade && apt-get install -y \
	procps \
	npm

RUN yes | npm create vite@latest ./ -- --template vanilla-ts
COPY ./app/vite.config.ts .
RUN npm i

EXPOSE 5173

ENTRYPOINT [ "npm", "run", "dev" ]
