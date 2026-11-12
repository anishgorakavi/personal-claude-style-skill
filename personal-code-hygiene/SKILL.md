---
name: personal-code-hygiene
description: Apply and enforce my personal software-engineering standards (TREE.md, TECH_DETAILS.md, and QUIZ.md upkeep, self-explanatory code, useful-only comments, spaces over tabs with Makefile tab exceptions, no needless abstraction, minimal architecture-respecting changes, honest verification). Use whenever writing, modifying, refactoring, or reviewing code in any language, when creating/moving/deleting project files, or when asked for a code review, hygiene check, or cleanup.
argument-hint: "[review|implement] [path]"
---

<!-- Entry point for the personal-code-hygiene skill: rules, Implementation and Review modes, checklist. -->

# Personal Code Hygiene

Goal: code a human can understand, verify, modify, and maintain without the AI that wrote it.
More comments, files, abstractions, or docs are not better engineering.

Mode: `$ARGUMENTS` starting with `review` means Review mode; otherwise use Implementation mode when
you are changing code and Review mode when asked to inspect it.

## Precedence

1. The user's current instructions.
2. Repository instructions (`CLAUDE.md`, `AGENTS.md`, course/assignment rules, `.editorconfig`,
   formatter and linter configs, existing code style).
3. This skill.

Where a higher level conflicts with a rule below, follow the higher level and say so in one line.
If a repo documentation or formatting rule is stricter (for example, a course requiring a comment
on every function), follow the stricter rule.

## Rules

**[M] = mandatory. [P] = preference: follow by default, deviate when the codebase or situation
gives a reason.**

### Project map
- [M] Keep `TREE.md` at the repo root, and update it in the same change that creates, deletes,
  moves, renames, or repurposes a file. Format and example: `references/tree-md.md`.
- [M] `TREE.md` describes every relevant source file in one or two accurate lines, plus the
  responsibility of each important directory. Exclude generated files, dependencies, build output.
- [M] Keep `TECH_DETAILS.md` at the repo root: stack, setup and commands, architecture and data
  flow, key concepts, gotchas, and where to start reading. Update it in the same change that
  changes any of those. Format: `references/tech-details-and-quiz.md`.
- [M] Keep `QUIZ.md` at the repo root: self-graded questions that test understanding of the code,
  with the answer key about 200 lines below the questions. Keep every answer true for the current
  code. Format: `references/tech-details-and-quiz.md`.

### Code
- [P] Meaningful names; straightforward algorithms over clever ones; readability and algorithmic
  efficiency over line count.
- [P] Narrowest practical variable scope; no duplicated state, redundant computation, or
  throwaway intermediate objects.
- [P] Named constants instead of unexplained magic values. Make assumptions and invariants explicit
  (assertion, validation, or a comment stating them).
- [P] No unnecessary interfaces, inheritance, wrappers, factories, or helpers. Do not enforce a
  maximum function length. A coherent 40-line function beats eight scattered tiny ones. Extract
  only for clarity, real reuse, testability, or separation of responsibilities.
- [P] Entry points orchestrate when the app is big enough to warrant it; simple cohesive modules
  beat boilerplate layering.

### Comments
- [M] No conversational AI commentary, obsolete/commented-out attempts, debug notes, or
  unnecessary TODOs in finished code.
- [M] File header: every file opens with a one- or two-line comment stating its purpose, placed
  after any shebang, encoding line, or YAML frontmatter, in the file's comment syntax (`#`, `//`,
  `--`, `<!-- -->` in Markdown, docstring in Python). Files with no comment syntax (JSON, lockfiles,
  images, binaries) have no header; their `TREE.md` entry states the purpose instead. Keep the
  header consistent with the `TREE.md` entry.
- [M] Every method, function, and class method has a comment or docstring (nested closures and
  lambdas excluded). Lead with what it is for; add parameters, return value, side effects, and
  exceptions only when a caller needs them. A trivial method gets one short line, not a
  restated signature. Use the language's convention (docstring, JSDoc, Javadoc, `///`, `//`
  above the function).
- [P] Inline comments explain why: non-obvious reasoning, constraints, design decisions. Never
  narrate what the code plainly does (`# increment counter`), and do not comment self-explanatory
  variables or fields.

### Whitespace
- [M] Spaces, not tabs, in ordinary source. Tabs only where the language or tooling requires them
  (GNU Makefile recipe lines, Go via gofmt, `.tsv`, `<<-` heredocs, repos whose formatter says
  otherwise). Never convert mandatory Makefile tabs to spaces.
- [M] Use the project's formatter/linter if one exists; no unrelated formatting churn; preserve
  meaningful whitespace.

### Scope and architecture
- [M] Before editing: read the relevant files, understand existing conventions and dependencies,
  choose the smallest change that works, preserve existing behavior unless the task says otherwise.
- [M] Do not: move files to unrelated directories, add frameworks or dependencies without
  justification, rewrite working code, silently change public APIs or database schemas, invent
  features or requirements, or reorganize because another structure is fashionable.

### Correctness and verification
- [M] Preserve invariants; consider boundary cases and failure paths; add or update tests when
  behavior changes; consider time/space complexity where it matters.
- [M] Run available tests, formatters, and linters when practical. Never claim something passed
  unless it ran. State what could not be verified.
- [M] Hygiene cleanup must not introduce behavior changes.

## Implementation mode

1. Read the surrounding code and repo instructions. Match their naming, comment density, idiom.
2. Make the smallest change that satisfies the task.
3. Update `TREE.md` if the file set or any file's responsibility changed. Update `TECH_DETAILS.md`
   and `QUIZ.md` if the behavior, setup, or flow they describe changed; create them if missing.
4. Run the project's tests/formatter/linter if present. Run
   `sh ${CLAUDE_SKILL_DIR}/scripts/check-hygiene.sh` for the mechanical checks (optional; read-only).
5. Before finishing, run the checklist below against your own diff (`git diff`). Fix problems in
   code you touched. Report problems elsewhere; do not fix them silently.

## Review mode

1. Scope the review: the diff if there is one, otherwise the path given. Run
   `sh ${CLAUDE_SKILL_DIR}/scripts/check-hygiene.sh [root]` and treat its output as leads, not
   verdicts (it is heuristic).
2. Read the code. Check against the rules above and `references/review-checklist.md`.
3. Report concrete violations as `path:line` with the evidence and a minimal fix, grouped by:
   - **Correctness**: bugs, broken invariants, unhandled edge/failure paths, missing tests,
     unverified claims. Highest priority.
   - **Maintainability**: [M] violations, stale `TREE.md`, `TECH_DETAILS.md`, or `QUIZ.md`
     (including quiz answers the code contradicts), needless abstraction, misleading or
     missing why-comments, duplicated state.
   - **Style preference**: [P] items. Keep short; omit what the formatter already enforces.
4. Do not edit files in Review mode unless asked. Do not pad the report: if a category is empty,
   say "none" and move on. Do not flag things that merely differ from taste when the codebase
   already does it consistently.

## Completion checklist

- Names self-explanatory? Any unnecessary abstraction or dependency?
- Every file with comment syntax opens with a one- or two-line purpose comment, and every method has a comment? Inline comments
  explain why, not what? No AI chatter, dead code, debug leftovers, stray TODOs?
- Indentation correct (spaces; Makefile tabs intact)?
- `TREE.md` in sync with the file set and responsibilities?
- `TECH_DETAILS.md` and `QUIZ.md` match the code, and every quiz answer still holds?
- Only intended files modified? No unrelated behavior or formatting changes?
- Edge cases and failure paths handled? Existing contracts (APIs, schemas) preserved?
- Relevant tests/linters actually run, with results reported honestly, gaps stated?
- Understandable by a newcomer without asking an LLM?

Supporting files (load only when needed): `references/tree-md.md` (TREE.md format),
`references/tech-details-and-quiz.md` (TECH_DETAILS.md and QUIZ.md formats),
`references/review-checklist.md` (mechanical vs judgment table, report template, tab exceptions).
