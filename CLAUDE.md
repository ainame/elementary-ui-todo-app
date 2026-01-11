# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Todo app built with ElementaryUI, a Swift-based framework for building web applications that compile to WebAssembly. The project combines Swift for UI logic and TypeScript for the browser runtime integration.

## Build System

### Swift WebAssembly Build
- **Build command**: `swift build --swift-sdk wasm32-unknown-wasip1`
- **Test command**: `swift test` (if tests are added in the future)
- The project uses Swift 6.2+ with Swift SDK for WebAssembly
- Debug builds use the standard WASM SDK; release builds use Embedded Swift SDK
- Swift compilation is handled automatically by the Vite plugin during development

### Frontend Build (Vite)
- **Development server**: `npm run dev` - Starts Vite dev server with hot reload
- **Production build**: `npm run build` - Creates optimized production bundle
- **Preview**: `npm run preview` - Preview production build locally
- **Dependency resolution**: `npm run preinstall` - Runs `swift package resolve` automatically before npm install

## Architecture

### Swift Layer (Sources/WebApp/)
- **App.swift**: Entry point that creates and mounts the ElementaryUI Application
- **ContentView.swift**: Main UI view containing the todo list component
  - Uses `@State` for reactive state management
  - `@View` macro for defining UI components
  - ElementaryUI's HTML-like DSL (div, h1, p, button, span, etc.)
  - Tailwind CSS classes applied via `.attributes(.class(...))`
  - Animations via `.animation()` and `.animateContainerLayout()`

### TypeScript Layer (src/)
- **index.ts**: Browser runtime entry point that initializes the Swift WebAssembly module
  - Imports CSS and browser runtime
  - Loads Swift WASM via virtual module `virtual:swift-wasm?init`
  - Calls `runApplication(appInit)` to start the app

### HTML Entry (index.html)
- Minimal HTML shell that loads the TypeScript module
- The Swift app mounts itself to `<body>`

### Build Configuration
- **vite.config.ts**: Configures Vite with Swift WASM plugin and Tailwind
  - `@elementary-swift/vite-plugin-swift-wasm` handles Swift compilation
  - `useEmbeddedSDK: true` for optimized release builds
  - `@tailwindcss/vite` plugin for Tailwind CSS v4

### Package Management
- **Package.swift**: Swift Package Manager configuration
  - Target name: "WebApp"
  - Dependency: ElementaryUI 0.1.0+
  - Platform: macOS 26+
  - Swift language mode: v5
- **package.json**: NPM dependencies including browser WASI shim and Tailwind

## Key Patterns

### State Management
The app uses ElementaryUI's reactive state system with `@State` properties. Changes to state automatically trigger UI updates.

### UI Components
Components are defined using the `@View` macro and return a `body` computed property containing the view hierarchy. ElementaryUI provides HTML element functions (div, span, button, etc.) that can be composed with modifiers like `.attributes()`, `.onClick()`, and `.animation()`.

### Styling
All styling is done with Tailwind CSS utility classes. The project uses Tailwind v4 with the Vite plugin for CSS processing.

## Development Workflow

1. Ensure Swift 6.2+ toolchain and WASM SDK are installed
2. Run `npm install` (automatically resolves Swift packages)
3. Run `npm run dev` to start development server
4. Edit Swift files in `Sources/WebApp/` - changes trigger automatic rebuild
5. Edit TypeScript/CSS in `src/` - changes trigger hot reload
6. Run `npm run build` for production deployment

## Important Notes

- Swift files use Swift 5 language mode despite Swift 6.2 toolchain
- The Swift WASM module is loaded asynchronously in the browser
- ElementaryUI components are rendered as actual DOM elements
- Date formatting uses Swift's `.formatted()` API
- The app uses browser WASI shim for WASM compatibility
