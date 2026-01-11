import { defineConfig } from "vite";
import swiftWasm from "@elementary-swift/vite-plugin-swift-wasm";
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    swiftWasm({
      useEmbeddedSDK: true,
    }),
    tailwindcss(),
  ],
});
