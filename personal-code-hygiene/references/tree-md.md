<!-- Format, rules, and example for a project's TREE.md. -->

# TREE.md format

`TREE.md` is a map for a newcomer: where things live and what each file is for. It is not a
`tree` dump.

## Rules

- Lives at the repo root. Paths are relative to the root.
- One summary sentence at the top describing what the project is.
- Every relevant source, config, and test file gets a one- or two-line description of its
  *purpose* (what it is responsible for), not a restatement of its name.
- Files with no comment syntax (JSON, lockfiles, images, binaries) get their purpose only here,
  since they cannot carry a header.
- Important directories get a line stating their responsibility.
- Repetitive families (e.g. `migrations/001_*.sql`, generated-style fixtures) may share one line
  that states the pattern.
- Exclude: dependencies (`node_modules`, `.venv`, `vendor`), build output (`dist`, `build`,
  `target`), caches (`__pycache__`), generated files, lockfiles, editor and OS files.
- Descriptions must match the implementation as it is now. If a file's job changed, rewrite the
  line; do not append.
- Update in the same change that creates, deletes, moves, renames, or repurposes a file.

## Example

```text
# TREE

Command-line tool that converts CSV exports into a summary report.

src/                  Application code.
  cli.py              Entry point: parses arguments and calls the report pipeline.
  parser.py           Reads CSV rows; skips the header and rejects malformed lines.
  report.py           Aggregates parsed rows into totals and renders the text report.
tests/                Pytest suite; mirrors src/ one-to-one.
  test_parser.py      Covers header skipping, malformed rows, empty files.
  test_report.py      Covers totals and rounding.
Makefile              `make test` and `make lint` shortcuts.
```

## Anti-patterns

- Listing every file with a description such as "main file" or "utilities".
- Pasting the output of `tree` or `ls -R`.
- Descriptions of planned rather than existing behavior.
- Leaving a deleted or renamed file in the map.
