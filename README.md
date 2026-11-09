# personal-claude-style-skill

A Claude Code skill, `personal-code-hygiene`, that applies my software-engineering standards when
writing or reviewing code in any language: a maintained `TREE.md`, self-explanatory code, comments
that explain why, spaces over tabs (Makefile tabs preserved), no needless abstraction, minimal
changes that respect existing architecture, and honest verification.

## Install

Personal (all projects):

```sh
cp -R personal-code-hygiene ~/.claude/skills/
```

Single project (commit it so collaborators get it):

```sh
mkdir -p .claude/skills && cp -R personal-code-hygiene .claude/skills/
```

Skills are discovered when a session starts (new top-level skill directories need a restart).
Re-copy after editing this repo's copy.

## Use

- Automatic: Claude loads the skill when you write, modify, or review code, or add/move/delete files.
- Newcomer aids: the skill keeps `TECH_DETAILS.md` (stack, setup, architecture, gotchas) and a
  self-graded `QUIZ.md` (answer key about 200 lines below the questions) in each project it works on.
- Explicit: `/personal-code-hygiene review src/` or `/personal-code-hygiene implement`.
- Mechanical checks alone: `sh personal-code-hygiene/scripts/check-hygiene.sh [project-root]`.

## Layout

See [TREE.md](TREE.md). The demo in `examples/` is intentionally broken; run the script on it with
`sh personal-code-hygiene/scripts/check-hygiene.sh examples/messy-project` and compare with
`examples/EXPECTED_REVIEW.md`.
