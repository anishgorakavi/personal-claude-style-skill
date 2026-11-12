<!-- Project map: what each file and directory in this repo is for. -->

# TREE

Claude Code skill (`personal-code-hygiene`) that applies and enforces my personal software-engineering standards, plus a small demo.

README.md                                   Install, activation, and usage instructions.
AGENTS.md                                   Rules for AI agents editing this repo: source of truth, checker constraints, demo caveats, verification commands.
CLAUDE.md                                   Imports AGENTS.md and adds Claude Code specifics (skill invocation, fresh-session testing).
personal-code-hygiene/                      The skill itself; this folder is what gets installed into a skills directory.
  SKILL.md                                  Entry point: precedence, mandatory vs preferred rules (incl. one-or-two-line file headers for every file and method comments), Implementation and Review workflows, completion checklist.
  references/tree-md.md                     Format, rules, and example for the project's TREE.md.
  references/tech-details-and-quiz.md      Formats and rules for a project's TECH_DETAILS.md and self-graded QUIZ.md.
  references/review-checklist.md            Mechanical vs judgment table, tab exceptions, and the Review-mode report template.
  scripts/check-hygiene.sh                  Read-only POSIX shell checks: TREE.md sync, tab indentation, Makefile recipe tabs, file purpose headers, leftover markers.
examples/                                   Demonstration material; intentionally violates the rules.
  messy-project/                            Tiny Python project seeded with violations for the demo.
    stats.py                                Tab-indented script with a narrating comment, magic number, TODO, and an empty-list crash.
    helpers.py                              Small helper that the demo's TREE.md forgets to mention.
    Makefile                                One recipe wrongly indented with spaces and one correct tab recipe.
    TREE.md                                 Deliberately stale map (lists a nonexistent utils.py).
  EXPECTED_REVIEW.md                        What Review mode reports for messy-project.
