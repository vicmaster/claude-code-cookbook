# product-designer

**Pain:** Asking Claude "what should this UI look like?" gets you a generic answer with no awareness of the components or patterns already in your app.
**Fix:** A subagent that reads your views/components first, frames the user and their goal, then proposes screens with ASCII wireframes, interaction details, and edge cases — grounded in your existing design system.
**Time to install:** 30s

## Why this exists

Most "design" prompts skip the two things designers actually do: defining the user's goal, and reusing what already works. This agent forces both.

Useful for: wireframing new flows, critiquing existing screens, accessibility passes, design system audits.

## Install

```bash
mkdir -p ~/.claude/agents
cp agent.md ~/.claude/agents/product-designer.md
```

Then: `Use the product-designer agent to wireframe the onboarding flow for new admin users`.

## Files

- `agent.md` — the subagent definition

## Gotchas

- Read-only — it won't write components. Hand off to your frontend builder agent once the direction is approved.
- ASCII wireframes are coarse — for high-fidelity work, pair with a design tool MCP (Figma, Pencil, Penpot).
- The agent assumes your app has a design system or at least consistent patterns. In greenfield apps, ask it to propose a system first.

## Variations

- Add `mcp__figma__*` or similar tools to let it read actual design files
- Narrow to a domain: `product-designer-mobile`, `product-designer-dashboard`
- Add a `### Accessibility checklist` section if a11y reviews are a regular workflow
