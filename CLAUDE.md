# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VinReadability is a Swift library that wraps Mozilla's @mozilla/readability (article content extractor) for use in Swift via JavaScriptCore. The JavaScript bundle and its DOM parser (linkedom) are vendored as a package resource — consumers never need npm or Node.js.

## Build Commands

```bash
swift build                # Build the library
swift test                 # Run all tests
swift test --filter <name> # Run a single test by name
```

## Rebuilding the JS Bundle

The vendored JS file at `Sources/VinReadability/Resources/readability.js` is pre-built. To regenerate it:

```bash
mkdir -p js && cd js
npm init -y
npm install @mozilla/readability linkedom esbuild
cd ..
npx esbuild js/entry.js --bundle --format=iife --platform=neutral --main-fields=main,module --outfile=Sources/VinReadability/Resources/readability.js
rm -rf js node_modules package-lock.json
```

The `js/entry.js` source for the bundle wrapper is not committed — recreate it from the git history or plan notes if needed.

## Architecture

- **Swift Package Manager** project (swift-tools-version: 6.2)
- **Platforms:** macOS 14+, iOS 17+
- **Single dependency:** SwiftyJSCore (branch: `main`) — provides `JSInterpreter` actor for async JavaScript execution, Codable bridging, and promise handling
- **Library target:** `VinReadability` (Sources/VinReadability/)
  - `Readability` actor — main API, wraps JSInterpreter
  - `ReadabilityArticle` — Codable struct for parsed article data
  - `Resources/readability.js` — bundled JS (esbuild IIFE of @mozilla/readability + linkedom)
- **Test target:** `VinReadabilityTests` using Swift Testing framework (`@Test` macro, `#expect`)
- All JavaScript interaction is async via SwiftyJSCore's actor-based API
