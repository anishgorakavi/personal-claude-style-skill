<!-- Rules for AI agents editing this repo: source of truth, checker constraints, demo caveats, verification. -->

# AGENTS.md

Instructions for AI agents working in this repository. Read `TREE.md` for the file map and
`README.md` for install and usage.

## What this repo is

The source of one Claude Code skill, `personal-code-hygiene`, which enforces my personal
engineering standards (TREE.md upkeep, self-explanatory code, useful-only comments, spaces over
tabs, minimal abstraction, honest verification). The skill is the folder `personal-code-hygiene/`;
everything else is docs and a demo.

## Working rules

- **The repo copy is the source of truth.** Edit `personal-code-hygiene/`, never
  `~/.claude/skills/personal-code-hygiene/`. After editing, sync and confirm:
  `cp -R personal-code-hygiene ~/.claude/skills/ && diff -r personal-code-hygiene ~/.claude/skills/personal-code-hygiene`
- **Follow the skill's own rules here.** Keep `TREE.md` current in the same change, open every
  file with a one- or two-line purpose header (see the skill's header rule), comment every
  function, use spaces, and keep changes minimal.
- **Keep `SKILL.md` short.** It is loaded into context whenever the skill triggers. Put long
  material in `personal-code-hygiene/references/` and link it. Tag every rule `[M]` (mandatory)
  or `[P]` (preference); do not add rules without a reason I gave.
- **`check-hygiene.sh` constraints:** POSIX `sh` plus `awk`, no dependencies, strictly read-only
  (it must never write, move, or delete anything), correct on filenames with spaces, and it skips
  itself so its own patterns do not self-match. Its output is heuristic; it must not claim more
  than it checks. Do not turn it into a framework.
- **Do not add dependencies, build steps, or extra scripts** without asking.

## The examples are broken on purpose

`examples/messy-project/` seeds known violations (tab indentation in `stats.py`, a space-indented
Makefile recipe, a stale `TREE.md`, a TODO, missing headers). Do not fix them. Do not reformat
them: the tabs are real, so create or edit those files with `printf` or a tool that preserves
tabs, and confirm with `grep -nP '^\t'`. If you change a rule or the checker, update
`examples/EXPECTED_REVIEW.md` and its finding count to match.

## Verification before finishing

Run these and report the actual results; never claim a check passed without running it.

```sh
sh personal-code-hygiene/scripts/check-hygiene.sh examples/messy-project   # expect 7 findings
sh personal-code-hygiene/scripts/check-hygiene.sh .                        # expect 5, all under examples/
sh personal-code-hygiene/scripts/check-hygiene.sh personal-code-hygiene    # only "TREE.md is missing" (it has no TREE.md of its own)
```

If you changed the checker, also test a directory whose names contain spaces and confirm that the
files are unchanged afterward (`shasum` before and after). If the counts above change, say why and
update this file.

## Git

Commit and push only when asked. End commit messages with the attribution line the harness
provides. Keep commits scoped: one concern each.
