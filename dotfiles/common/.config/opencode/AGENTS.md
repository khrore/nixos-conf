# AGENTS.md - Multiagent Workflow Playbook

- Audience: Workflow agents under this directory.
- Purpose: Shared context and quality-of-life conventions for clean handoffs.
- Scope: Coordination guidance only. Role behavior and routing rules live in each agent file.

---

## 1) What this file is (and is not)

Use this file as a lightweight playbook to keep stage outputs consistent and easy to consume.

This file does not replace:

- `workflow-orchestrator.md` for queue control and loop routing
- stage prompts (`analyzer`, `researcher`, `planner`, `coder`, `reviewer`, `tester`, `technical-writer`, `summarizer`) for role-specific rules
- workflow docs in `docs/workflow/` for canonical schema and policy definitions

If there is a conflict, follow the stage prompt and orchestrator context.

---

## 2) Workflow orientation (quick map)

Default queue:

`analyzer -> researcher -> planner -> coder -> reviewer -> tester -> technical-writer -> summarizer`

Common loop:

- reviewer returns `changes_required`
- route back to the same coder with actionable `fix_instructions`
- repeat until approved or review-cycle limit is reached

Escalation is context-driven via workflow settings (for example `escalation_policy`, `max_review_cycles`).

---

## 3) Handoff quality defaults

Every handoff should be easy for the next stage to execute without guessing.

- Keep outputs concise and structured; prefer short lists over long prose.
- State assumptions explicitly; do not hide them in narrative text.
- Call out unknowns that can change implementation behavior.
- Include evidence references (files, checks, observations), not just conclusions.
- If work is skipped, state what was skipped and why.

Recommended status vocabulary (for consistency):

- `ready`: stage finished and handoff is complete
- `needs_human`: stage cannot continue without a decision
- `blocked`: cannot proceed due to missing input/tooling/precondition
- `changes_required`: reviewer requests coder remediation
- `done`: terminal completion (typically summarizer)

---

## 4) Escalation communication style

When asking a human question, keep it decision-ready:

1. One clear question
2. Why this decision matters now
3. Recommended default
4. What changes based on each choice

Avoid broad or multi-part questions that delay routing.

---

## 5) Reviewer -> coder remediation quality

`fix_instructions` should be actionable and verifiable.

Good `fix_instructions` are:

- specific to files/behaviors
- minimal in scope
- testable with clear acceptance checks
- ordered when steps depend on each other

Avoid:

- vague feedback ("improve quality", "clean this up")
- mixed unrelated requests in one item
- requirements without validation criteria

Example (good):

"In `src/cache.ts`, handle TTL parse failures by returning a typed error instead of defaulting to `0`; add a test that asserts invalid TTL returns `ConfigError::InvalidTtl`."

Example (bad):

"Caching is risky; please make it safer."

---

## 6) Stage collaboration etiquette

- Respect prior stage decisions unless new evidence shows risk or contradiction.
- Do not re-scope the task without a concrete reason.
- Preserve useful context from upstream; do not force downstream stages to rediscover it.
- Prefer smallest-change guidance that still satisfies acceptance criteria.
- Keep language neutral and operational; avoid performative commentary.

---

## 7) Practical checklists (non-binding reminders)

Analyzer:

- restate objective clearly
- list assumptions/constraints
- define acceptance criteria and risk framing

Researcher:

- map relevant files/systems
- capture existing patterns and constraints
- flag unknowns that affect plan viability

Planner:

- produce executable steps
- align validation depth with risk
- choose appropriate coder path

Coder:

- implement only approved scope
- keep changes focused and reversible
- report exactly what changed

Reviewer:

- decide: approved / changes_required / blocked
- provide concrete remediation when not approved
- include acceptance checks for each fix item

Tester:

- validate behavior and failure paths
- separate pass/fail from confidence notes
- report residual risk when coverage is partial

Technical writer:

- update impacted docs only
- keep docs concise and task-scoped
- no-op explicitly when docs impact is zero

Summarizer:

- produce structured + human summaries
- include validation, assumptions, and residual risks
- clearly mark skipped stages/checks and reasons

---

## 8) Token and readability hygiene

- Prefer compact, high-signal outputs.
- Avoid repeating unchanged context from earlier stages.
- Use stable field names and ordering when possible.
- Keep examples short and directly relevant to the active task.

This playbook is intentionally lightweight. Add guidance here only when it improves cross-stage clarity.
