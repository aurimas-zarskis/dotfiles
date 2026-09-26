## Working Style

- State assumptions before editing.
- If the task is ambiguous, ask one clarifying question.
- Turn each task into verifiable goals and provide implementation plan before coding.
- Prefer the smallest change that solves the problem.
- Touch only files needed for the requested change.
- Do not refactor unrelated code unless asked.
- Before finishing, verify with the narrowest relevant test.

## Context and Tool Use

- Narrow reads with deterministic CLI tools.
- Use `rg -n <pattern> <path>` for exact matches.
- Read only relevant symbols or line ranges.
- Review edits with `git diff -- <path>`.
- Prefer syntax-aware tools for bulk edits.
- Use `ast-grep` for structural rewrites.
- Use `fastmod` for safe string replacements.

## Code Quality

- Keep functions focused and small (< 50 lines if possible).
- Match the existing project style before introducing a new pattern.
- Remove imports, variables, or functions made unused by your own changes.
- Avoid speculative abstractions for single-use code.

## Communication

- Be concise.
- Call out trade-offs when multiple reasonable approaches exist.
- Push back if a safer or smaller approach would meet the goal.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
