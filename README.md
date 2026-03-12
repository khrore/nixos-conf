# nixos-conf

## Multiagent workflow

This repository now includes a portable multiagent workflow spec used for OpenCode and
adapter-ready for Codex and Claude-style runtimes.

Key docs:

- `docs/workflow/core-spec.md`
- `docs/workflow/handoff-schema.md`
- `docs/workflow/policy.md`
- `docs/workflow/adapter-mapping.md`
- `docs/workflow/implementation-plan.md`

Adapter notes:

- `docs/workflow/adapters/opencode.md`
- `docs/workflow/adapters/codex.md`
- `docs/workflow/adapters/claude.md`

OpenCode runtime files:

- config: `dotfiles/common/.config/opencode/opencode.json`
- agents: `dotfiles/common/.config/opencode/agents/`

Workflow queue:

`analyzer -> researcher -> planner -> coder -> reviewer -> tester -> technical-writer -> summarizer`

Runtime controls set at workflow creation:

- `escalation_policy`: `strict | balanced | relaxed`
- `max_review_cycles`: integer (default `3`)
