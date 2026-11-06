# Review of examples/messy-project

Scope: all four files; mechanical script: ran (7 findings, all confirmed); tests: none exist, nothing run.

## Correctness
- stats.py:9: `avg([])` raises `ZeroDivisionError` (`main()` with no arguments crashes). Fix: decide the
  contract for empty input (return 0.0, or raise `ValueError("avg() needs at least one number")`) and
  add a test for it.
- stats.py:17: `main()` runs on import. Fix: guard with `if __name__ == "__main__":` so `avg` can be
  tested without executing the script.
- Makefile:2: the `run` recipe is indented with spaces, so GNU make fails with "missing separator".
  Fix: replace the leading spaces with a single tab. The `test:` recipe already uses a tab; leave it.

## Maintainability
- stats.py:1, helpers.py:1: no file purpose comment. Fix: open each with a line or two, e.g.
  `"""Computes summary statistics for numbers given on the command line."""`.
- stats.py:3, 11, 14 (`avg`, `is_adult`, `main`) and helpers.py:1 (`clamp`): no method comments
  (the script cannot detect these). Fix: one purpose line each; `avg`'s must state the
  empty-input behavior chosen above, and `clamp`'s that `low <= high` is assumed.
- stats.py:4-9, 12, 15-16: indentation uses tabs. Fix: re-indent with 4 spaces (formatter output only,
  no logic change).
- stats.py:12: `18` is an unexplained magic value. Fix: `ADULT_AGE_YEARS = 18`. Also, `is_adult` is
  never called; confirm it is needed before keeping it.
- stats.py:8: `TODO: handle empty list` is a finished-code marker, and it is the crash above. Fix:
  resolve it as described, then delete the marker.
- stats.py:5, 7: comments narrate the code ("loop through nums", "add n to total"). Fix: delete them;
  `sum(nums) / len(nums)` removes the loop entirely.
- TREE.md:6: lists `utils.py`, which does not exist. Fix: remove the line.
- TREE.md: `helpers.py` is missing. Fix: add `helpers.py   Clamps a value to a [low, high] range.`
- TREE.md:5: "Computes averages" omits the CLI entry point and `is_adult`. Fix: reword after the
  changes above.

## Style preference
- none

Not verified: no tests exist; the `make` targets were not run.
Out of scope (noticed, not changed): none.
