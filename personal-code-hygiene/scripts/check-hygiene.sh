#!/bin/sh
# Mechanical checks for the personal-code-hygiene skill; needs only POSIX tools and awk.
# Usage: check-hygiene.sh [project-root]
# Prints one "path:line: [rule] message" per finding.
# Exit status: 0 clean, 1 findings, 2 root not found.
# Checks are heuristics: a finding is a prompt to look, not proof of a violation.

# Resolve this script's path before changing directory so it can skip itself later.
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
cd "${1:-.}" || exit 2

SOURCE_EXTENSIONS='py|js|jsx|ts|tsx|go|rs|c|h|cc|cpp|hpp|java|kt|swift|rb|sh|sql|cs|php|lua|scala'
DOC_EXTENSIONS='md|json|toml|yaml|yml'
LEFTOVER_PATTERN='TODO|FIXME|XXX|HACK|as an AI|AI language model|here( is|.s) the (updated|fixed|new)|pdb\.set_trace|breakpoint\(\)|binding\.pry|debugger;'
TAB=$(printf '\t')

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  candidate_files=$(git ls-files --cached --others --exclude-standard)
else
  candidate_files=$(find . -type f \
    -not -path '*/.git/*' -not -path '*/node_modules/*' -not -path '*/.venv/*' \
    -not -path '*/__pycache__/*' -not -path '*/dist/*' -not -path '*/build/*' \
    -not -path '*/target/*' -not -path '*/vendor/*' | sed 's|^\./||')
fi

# git ls-files still lists tracked files that were deleted in the working tree.
all_files=$(printf '%s\n' "$candidate_files" | while IFS= read -r path; do
  [ -f "$path" ] && printf '%s\n' "$path"
done)
source_files=$(printf '%s\n' "$all_files" | grep -E "\.($SOURCE_EXTENSIONS)$")

check_tree_md() {
  if [ ! -f TREE.md ]; then
    echo "TREE.md:1: [tree] TREE.md is missing at the project root"
    return
  fi

  printf '%s\n' "$source_files" | while IFS= read -r file; do
    [ -n "$file" ] || continue
    grep -qF "$(basename "$file")" TREE.md ||
      echo "$file:1: [tree] not described in TREE.md"
  done

  grep -o '`[^`]*`' TREE.md | tr -d '`' |
    grep -E "\.($SOURCE_EXTENSIONS|$DOC_EXTENSIONS)$" | grep -v '[*<>]' | sort -u |
    while IFS= read -r mentioned; do
      case "$mentioned" in
        */*) printf '%s\n' "$all_files" | grep -qxF "${mentioned#./}" ;;
        *) printf '%s\n' "$all_files" |
             grep -qE "(^|/)$(printf '%s' "$mentioned" | sed 's/\./\\./g')$" ;;
      esac || echo "TREE.md:1: [tree] mentions \`$mentioned\`, which does not exist"
    done
}

check_tab_indentation() {
  printf '%s\n' "$source_files" | grep -v '\.go$' | while IFS= read -r file; do
    [ -n "$file" ] && [ ! "$file" -ef "$self" ] || continue
    first_line=$(grep -n "^$TAB" "$file" | head -n 1 | cut -d: -f1)
    [ -n "$first_line" ] &&
      echo "$file:$first_line: [whitespace] tab indentation; use spaces unless the tooling requires tabs"
  done
}

# Recipe lines must start with a tab. A rule starts at a "target:" line (not an assignment)
# and ends at the next unindented line that is not itself a rule.
check_makefile_recipes() {
  printf '%s\n' "$all_files" | grep -E '(^|/)(Makefile|makefile|GNUmakefile|[^/]*\.mk)$' |
    while IFS= read -r makefile; do
      awk '
        /^\t/ { next }
        /^ +[^ #]/ && in_rule {
          printf "%s:%d: [whitespace] recipe line indented with spaces; GNU make requires a tab\n", FILENAME, NR
          next
        }
        /^[^ \t#][^=]*:($|[^=])/ { in_rule = 1; next }
        /^[^ \t]/ { in_rule = 0 }
      ' "$makefile"
    done
}

# The first line after any shebang or blank lines must be a comment or docstring.
# Method-level comments are not checked here: finding methods needs a per-language parser.
check_file_headers() {
  printf '%s\n' "$source_files" | while IFS= read -r file; do
    [ -n "$file" ] && [ ! "$file" -ef "$self" ] || continue
    first_line=$(grep -m 1 -vE '^(#!|[[:space:]]*$)' "$file")
    case "$first_line" in
      '#include'* | '#define'* | '#pragma'* | '#if'*) has_header=no ;;
      '#'* | '//'* | '/*'* | '--'* | '"""'* | "'''"* | '<!--'* | ' *'*) has_header=yes ;;
      *) has_header=no ;;
    esac
    [ "$has_header" = yes ] || echo "$file:1: [comment] file does not start with a purpose comment"
  done
}

check_leftovers() {
  printf '%s\n' "$source_files" | while IFS= read -r file; do
    [ -n "$file" ] && [ ! "$file" -ef "$self" ] || continue
    grep -nE "$LEFTOVER_PATTERN" "$file" | cut -d: -f1 | while IFS= read -r line; do
      echo "$file:$line: [leftover] TODO-style marker, AI phrasing, or debugger call in finished code"
    done
  done
}

findings=$(check_tree_md; check_tab_indentation; check_makefile_recipes; check_file_headers; check_leftovers)

if [ -n "$findings" ]; then
  printf '%s\n' "$findings"
  printf '%s finding(s)\n' "$(printf '%s\n' "$findings" | wc -l | tr -d ' ')"
  exit 1
fi
echo "No mechanical findings. Judgment-based rules still need review."
