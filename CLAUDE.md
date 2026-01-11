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
- **Development server**: `pnpm run dev` - Starts Vite dev server with hot reload
- **Production build**: `pnpm run build` - Creates optimized production bundle
- **Preview**: `pnpm run preview` - Preview production build locally
- **Dependency resolution**: `pnpm run preinstall` - Runs `swift package resolve` automatically before install
- **Note**: This project uses pnpm, not npm

## Architecture

### Swift Layer (Sources/WebApp/)
- **App.swift**: Entry point that creates and mounts the ElementaryUI Application
- **ContentView.swift**: Contains all UI components and view models
  - **TodoItem**: Plain data model class (not @Reactive) with id, title, description, deadline
  - **TodoViewModel**: `@Reactive` class managing todo items array and business logic
  - **ContentView**: Main view that renders the todo list using TodoViewModel
  - **TodoItemView**: Container view managing edit mode state (isEditMode)
  - **TodoItemViewerView**: Read-only view with Edit and Delete buttons
  - **TodoItemEditView**: Form view with Cancel and Done buttons
  - Uses `@State` for component-level state (like isEditMode)
  - Uses `@View` macro for defining UI components
  - ElementaryUI's HTML-like DSL (div, h1, p, button, span, input, textarea, etc.)
  - Tailwind CSS classes applied via `.class()` parameter
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
- **@Reactive on ViewModels**: Use `@Reactive` class for view models that manage collections and business logic
  - Example: `@Reactive class TodoViewModel { var items: [TodoItem] = [] }`
- **Plain model classes**: Data models like TodoItem should NOT use @Reactive
- **@State for UI state**: Use `@State` in views for component-level UI state like `isEditMode`
- Changes to @Reactive properties automatically trigger UI updates

### Property Binding with #Binding()
Use the `#Binding()` macro to bind directly to reactive object properties:
```swift
TodoItemEditView(
    item: item,  // Pass the whole item
    ...
)

// In TodoItemEditView:
input(.type(.text))
    .bindValue(#Binding(item.title))  // Bind directly to property
```
This creates two-way binding without intermediate @State variables.

### Inline Editing Pattern
Views can switch between view and edit modes using @State:
```swift
@State var isEditMode: Bool = false

if isEditMode {
    TodoItemEditView(...)  // Form with Cancel/Done buttons
} else {
    TodoItemViewerView(...)  // Read-only with Edit button
}
```

### UI Components
Components are defined using the `@View` macro and return a `body` computed property containing the view hierarchy. ElementaryUI provides HTML element functions (div, span, button, input, textarea, etc.) that can be composed with modifiers like `.class()`, `.onClick()`, `.bindValue()`, and `.animation()`.

### Styling
- All styling is done with Tailwind CSS utility classes
- Classes are passed as parameters: `.class("flex items-center gap-2")`
- The project uses Tailwind v4 with the Vite plugin for CSS processing

## Development Workflow

1. Ensure Swift 6.2+ toolchain and WASM SDK are installed
2. Run `pnpm install` (automatically resolves Swift packages)
3. Run `pnpm run dev` to start development server
4. Edit Swift files in `Sources/WebApp/` - changes trigger automatic rebuild
5. Edit TypeScript/CSS in `src/` - changes trigger hot reload
6. Run `pnpm run build` for production deployment

## Important Notes

- Swift files use Swift 5 language mode despite Swift 6.2 toolchain
- The Swift WASM module is loaded asynchronously in the browser
- ElementaryUI components are rendered as actual DOM elements
- The app uses browser WASI shim for WASM compatibility
- Use `#Binding()` macro for direct property binding, not intermediate @State variables
- Only use @Reactive on view models that manage collections, not on plain model classes
- Keypaths don't work in Embedded Swift - use closures for ForEach keys: `key: { $0.id }`
- For textarea binding, use `.onInput { event in ... }` as `.bindValue()` only works on input elements
