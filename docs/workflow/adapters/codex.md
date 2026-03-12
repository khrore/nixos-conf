# Codex Adapter

## Integration Surface

- map role contracts to codex subagent/task invocation
- map abstract capabilities to codex file/search/edit/shell/web tools
- enforce queue and escalation in orchestrator state machine

## Required Behavior

- maintain same handoff schema as core docs
- preserve reviewer-to-coder loop and `max_review_cycles`
- apply user-selected `escalation_policy`

## Notes

- codex runtime differences should be adapter-only
- avoid changing core stage definitions for runtime convenience
