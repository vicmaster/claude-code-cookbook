# sensible-permissions-electron

**Pain:** Permission prompts every 30 seconds for `npm install`, `npx electron-vite`, `npx tsc`, `npm run` while iterating on an Electron app.
**Fix:** A vetted `settings.json` allowlist for Electron development — npm/npx tooling, TypeScript, vitest, electron-vite, electron-rebuild, asar, plus the docs domains you fetch most.
**Time to install:** 30s

## Why this exists

Electron development means lots of rebuilds — native modules need `electron-rebuild` after every dependency change, vite dev servers need restarting, asar packages need inspecting. Each of those is a permission prompt by default. This list pre-approves the routine ones.

Battle-tested in a real Electron + Vite + TypeScript app.

## Install

```bash
mkdir -p .claude
cp settings.json .claude/settings.local.json
```

## Files

- `settings.json` — the permissions block

## Gotchas

- **`npm install:*` allows arbitrary package installs.** That's intentional for dev velocity, but it means a rogue suggestion could pull anything from npm. Audit suggestions before agreeing to install large/unknown packages.
- **`gh repo:*` and `gh release:*` are pre-approved** — useful for releasing, but means agent can create repos. If that's too broad, narrow to `gh repo view`, `gh repo list`.
- **WebFetch domains** are scoped intentionally — adding `*` would let the agent fetch anything. Keep an explicit allowlist.
- **Not included**: `electron-builder *` for production builds (often needs signing certs / CI secrets — keep gated).
- Doesn't pre-approve `git push --force` or branch deletes — those should always be confirmed.

## Variations

- For Tauri/Wails projects: swap `electron-*` commands for `tauri *` / `wails *`
- Add `pnpm` or `yarn` siblings if you're on a non-npm package manager
- Add `Bash(npx playwright:*)` if you use Playwright for E2E
