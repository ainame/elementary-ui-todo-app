import { defineConfig } from "vite";
import swiftWasm from "@elementary-swift/vite-plugin-swift-wasm";
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  base: process.env.GITHUB_PAGES ? '/elementary-ui-todo-app/' : '/',
  plugins: [
    swiftWasm({
      useEmbeddedSDK: true,
      useWasmOpt: true,
    }),
    tailwindcss(),
  ],
});
