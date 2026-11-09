# Review checklist and enforcement notes

## What can be checked mechanically

`scripts/check-hygiene.sh [root]` covers the first block. Output is heuristic: confirm each finding
before reporting it.

| Rule | Check | Script rule id |
| --- | --- | --- |
| `TREE.md` exists | file present at root | `tree` |
| Source file documented | file's basename appears in `TREE.md` | `tree` |
| No stale entries | backticked file names in `TREE.md` exist | `tree` |
| Spaces over tabs | source line starting with a tab (Go excluded) | `whitespace` |
| Makefile tabs intact | recipe line indented with spaces | `whitespace` |
| File purpose header | first non-shebang line of a source file is a comment or docstring | `comment` |
| Finished-code leftovers | `TODO`/`FIXME`/`XXX`/`HACK`, AI phrasing, debugger calls | `leftover` |

Also mechanical, but done by the project's own tools, not this skill: formatting, lint rules,
unused code, tests, type checks. Run them; do not reimplement them.

`TREE.md` grouped entries (a documented pattern covering several files) will produce `tree`
findings. Dismiss those if the pattern is stated.

## What needs judgment

| Rule | What to look for |
| --- | --- |
| Meaningful names | Would a newcomer know what `data2`, `handle`, `util` hold or do? |
| Method comments present and useful | Every method has one that says what it is for (the script cannot find missing ones); header describes the file's real purpose; neither merely restates the name |
| Inline comments add information | Narration of the next line, restated field names, stale or misleading comments, missing *why* on non-obvious logic |
| Needless abstraction | Single-implementation interfaces, pass-through wrappers, factories for one type, helper-of-helper chains |
| Over-inlined code | A function doing unrelated jobs that cannot be tested or understood in one reading |
| Magic values | Literals whose meaning is not obvious at the use site |
| Narrow scope, no duplicated state | Variables hoisted far from use; two sources of truth |
| Invariants explicit | Assumptions only visible by reading callers |
| Correctness | Boundary cases (empty, one, max, negative), failure paths, resource cleanup, complexity |
| Minimal change | Diff touches unrelated files, reformats untouched lines, adds dependencies |
| Contracts preserved | Public signatures, return shapes, schema, CLI flags unchanged unless required |
| Tests | Behavior changes have tests; claimed results correspond to commands actually run |
| `TREE.md` accuracy | Descriptions match what the file does now |
| `TECH_DETAILS.md` and `QUIZ.md` accuracy | Setup commands run or marked not run; flow matches the code; each quiz answer is still true and cites a real location |

## Tab exceptions

Tabs are required or conventional in: GNU Makefile recipe lines (`Makefile`, `*.mk`,
`GNUmakefile`), Go (gofmt), `.tsv`, `<<-` heredoc bodies, `.gitconfig`, and any repo whose
`.editorconfig` or formatter sets tabs (e.g. Linux-kernel-style C). A Makefile line that is a
continuation or a variable assignment may legitimately use spaces; only recipe lines need tabs.
When unsure whether the repo uses tabs deliberately, follow the repo.

## Report template (Review mode)

```text
Scope: <files or diff reviewed>; mechanical script: <ran / not run>; tests: <ran X / not run>

Correctness
- path:line: <problem>. Evidence: <why>. Fix: <minimal change>.

Maintainability
- path:line: <problem>. Fix: <minimal change>.

Style preference
- path:line: <observation>.

Not verified: <anything that could not be run or confirmed>
Out of scope (noticed, not changed): <unrelated hygiene issues>
```

Rules for the report: cite `path:line`; one fix per finding, as small as possible; say "none" for
empty categories; never present a style preference as a defect; never claim a test passed that was
not run.
