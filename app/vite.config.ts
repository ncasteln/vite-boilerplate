import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig({
  server: {
	host: true,
	port: 8080, // This is the port which we will use in docker
  }
})
