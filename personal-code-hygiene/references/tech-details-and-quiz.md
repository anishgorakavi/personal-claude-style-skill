<!-- Formats and rules for a project's TECH_DETAILS.md and self-graded QUIZ.md. -->

# TECH_DETAILS.md and QUIZ.md format

Both files help a newcomer understand a codebase without asking the AI that wrote it. Both live
at the repo root, next to `TREE.md`. Scale them to the project: a one-file script needs a short
page and a few questions; a large project needs more of both.

## TECH_DETAILS.md

The technical orientation a newcomer needs to stop feeling lost. It is not a language tutorial.

Sections, in this order. Omit any that do not apply.

1. **What it is**: one or two sentences, matching the summary at the top of `TREE.md`.
2. **Stack**: language and version, frameworks, and key libraries, taken from the manifest files
   (`pyproject.toml`, `package.json`, `go.mod`, and similar). Explain a dependency only when its
   role is not obvious.
3. **Setup and commands**: install, run, test, lint, and build, each as the exact command. Write
   "not run" beside any command you did not execute.
4. **Architecture and data flow**: how an input or request moves through the code, in the order
   it happens, naming files and functions. A short numbered list is enough; do not diagram every
   module.
5. **Key concepts**: the domain terms and internal names a reader will meet, one line each.
6. **Conventions**: non-obvious rules the code depends on (config files, environment variables,
   where tests live, naming that carries meaning).
7. **Gotchas**: surprising behavior and known sharp edges, with the reason each exists.
8. **Where to start reading**: three to five files in reading order, one line each on why.

Rules:
- [M] Describe the code as it is now. Verify each claim by reading the code or the manifest. If a
  claim cannot be verified, say so instead of stating it.
- [M] Name the file for every component (`src/cli.py`). Add `file:line` only for a non-obvious spot.
- [P] Link to `TREE.md` for the file list; do not repeat it.
- [P] No AI chatter, no marketing language, no history of how the code was built (git holds that).

## QUIZ.md

Self-graded questions that check whether the reader understands the code, not whether they
memorized trivia. The answer key sits far enough below the questions that it is not visible while
reading them.

Layout:

```text
# Codebase quiz

How to use: answer each question in your own words, in scratch space below, before reading the
key. Then compare. One point per answer that is correct in substance.

## Questions

1. <question>
2. <question>

## Scratch space

(about 200 blank lines, for writing answers)

## Answer key

1. **Answer:** <short answer>. **Where:** `path:line`.
2. **Answer:** <short answer>. **Where:** `path:line`.
```

Rules:
- [M] Place the answer key about 200 lines after the last question, with the scratch space between
  them. The key must not be visible when the questions are read.
- [M] Every answer is verified against the current code and cites where it lives (`path:line`).
  Never write an answer that the code does not support.
- [M] Ask only questions the code can answer. Drop questions about the team's decisions or history.
- [M] Each question asks for reasoning: where a behavior lives, what happens in a case, why a piece
  is written a certain way, what breaks if something changes, how two parts interact. Avoid yes/no
  questions and questions with guessable answers.
- [P] Cover the parts a newcomer most needs: the entry point and main flow, the riskiest or least
  obvious logic, the contracts between modules, and the gotchas listed in `TECH_DETAILS.md`.
- [M] When code changes, update the questions and answers it affects, and delete any that no longer
  apply. Do not regenerate the whole quiz for an unrelated change.
