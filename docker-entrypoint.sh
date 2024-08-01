#!/bin/bash

yes | npm create vite@latest ./ -- --template vanilla-ts;
cp /vite.config.ts /app/vite.config.ts;
npm install;

exec npm run dev;
