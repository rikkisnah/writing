document_type: reference
topic: environment-variables
keywords: [env, node-options, artifactfile, bld_number, forge, webpack, jest]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: [docs/05-reference/ref-build-test-scripts.md]
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Compute Admin UI — Environment Variables Reference

Scope
Canonical list of environment variables and flags used by scripts, webpack, Storybook, and build service. Facts only; no procedures.

Global and Script-Level Variables
- NODE_OPTIONS
  - Purpose: Enables legacy OpenSSL provider required by Storybook builder-webpack4.
  - Typical value: --openssl-legacy-provider
  - Used by: npm run storybook, npm run build-storybook
- BLD_NUMBER
  - Purpose: Build service-injected number used to stamp version and artifact names.
  - Typical value: numeric, e.g., 42 (in CI context)
  - Used by: npm run build (via --env artifactFile='compute-admin-1.3${BLD_NUMBER}.0.tar.gz'), ocibuild.conf version: 1.6${BLD_NUMBER}.0
- WEBPACK --env artifactFile
  - Purpose: Overrides the output artifact tarball name during production build.
  - Typical value: compute-admin-X.Y${BLD_NUMBER}.0.tar.gz
  - Used by: npm run build; ocibuild.conf passes artifactFile to webpack
- PACKAGE VERSION (derived)
  - Purpose: Stamped into src/version.ts by npm run stamp-version.
  - Typical value: from package.json "version" (e.g., 1.0.0)
  - Used by: UI version display and traceability

Forge Dev Path and Base Paths
- Forge dev proxy path
  - Purpose: Local development path base for the SPA.
  - Value: /local (via homepage in package.json)
  - Used by: npm start dev server and browser navigation to /local?localPort=8080
- Deployed runtime base path
  - Purpose: Base path for production deployments under the plugin name.
  - Value: /compute-admin (plugin-name)
  - Used by: Router and asset resolution (must remain base-path-safe)

Build Service (ocibuild.conf) Fields (informational)
- runnerImage / runnerTag
  - Purpose: Defines build runner container image (build-runner-node-ol9:latest)
- nodeVersion
  - Purpose: Node.js version used in CI steps (16.20.0)
- version (pipeline)
  - Purpose: CI-injected version used by npm version and artifact naming (1.6${BLD_NUMBER}.0)
- artifactFile (pipeline)
  - Purpose: Final artifact name (compute-admin-${version}.tar.gz) passed to webpack

Testing and Tooling
- Jest flags (via scripts)
  - --runInBand, --workerIdleMemoryLimit, --silent, --coverage, --logHeapUsage (script-level flags; not env variables)
- ESLint config resolution
  - parserOptions.project points to tsconfig.json (not env variable)

Examples
- Storybook with legacy OpenSSL: NODE_OPTIONS=--openssl-legacy-provider npm run storybook
- Production build with artifact override: npm run build -- --env artifactFile='compute-admin-1.3${BLD_NUMBER}.0.tar.gz'

Stable anchors (150–400 tokens per section)
- Global and Script-Level Variables
- Forge Dev Path and Base Paths
- Build Service Fields (informational)
- Testing and Tooling
- Examples

Compliance
- Do not include secrets or credentials.
- Keep internal URLs only if already present in README or configuration comments.
