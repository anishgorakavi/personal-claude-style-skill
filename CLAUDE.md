# CLAUDE.md

@AGENTS.md

## Claude Code specifics

- The skill is invoked as `/personal-code-hygiene [review|implement] [path]` or triggers
  automatically on coding tasks. Skills are discovered at session start, so restart the session
  after changing `SKILL.md` frontmatter or adding the skill.
- To test activation or invocation for real, use a fresh headless session in the scratchpad
  directory, not this repo, so the demo files are not modified:
  `cd <scratchpad>/proj && claude -p "/personal-code-hygiene review ." --allowedTools "Bash(sh *check-hygiene.sh*)" Read Glob Grep`
  For automatic activation, give a coding task that does not name the skill and look for a
  `Skill` tool call with `personal-code-hygiene` in `--output-format stream-json --verbose` output.
- Copy `examples/messy-project/` to the scratchpad before running agents against it.
- The skill's `${CLAUDE_SKILL_DIR}` path variable is used in `SKILL.md` for the script path.
  Keep it if you move the script.
