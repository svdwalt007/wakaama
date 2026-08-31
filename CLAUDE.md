# CLAUDE.md — wakaama-dut-client

Global contract in `~/.claude/CLAUDE.md` applies (QA/TDD/verification laws, skill
routing, attribution rules).

## Docker policy (standing, until further notice)
- Do not start, stop, build, or otherwise manage Docker containers, images, or
  compose stacks in this repo — OpenClaw manages all live Docker instances and
  health. Applies to `docker run`, `docker compose up/down`, `docker build`, and
  container restarts/kills.
- Read-only inspection (`docker ps`, `docker logs`, `docker inspect`) is fine.
- Standing until Sean lifts it explicitly.

## LEARNINGS process

Cross-project engineering lessons live in `~/.claude/LEARNINGS.md` (global, applies to
every repo — deliberately not committed here).

- **Use**: consult it when you hit build/test/debugging/orchestration weirdness — the
  failure pattern and its fix may already be recorded there.
- **Post**: when a session produces a durable, project-agnostic lesson (a pattern that
  proved itself, or failed, clearly enough to be worth carrying into the next project),
  append an entry structured as **what / why it matters / how to apply**. Don't post
  after every session, and prune entries that turn out to be one-off flukes.
  Project-specific facts belong in this repo's own CLAUDE.md/memory, not in LEARNINGS.
