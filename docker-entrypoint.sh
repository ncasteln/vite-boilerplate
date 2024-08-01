#!/bin/bash

if npm list | grep -q empty; then
	yes | npm create vite@latest ./ -- --template vanilla-ts;
	cp /vite.config.ts /app/vite.config.ts;
	rm -rf /vite.config.ts;
	npm install;
fi

exec npm run dev;
