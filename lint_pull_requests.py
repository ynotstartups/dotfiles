#!/usr/bin/env python
"""
lint added lines in a patch outputs quickfix format

Design Principle:

1. should be easy to add new lint rule
2. no external dependencies for easy portability
"""

# TODO: add tests, try to get 100% coverage

import sys
import logging
from enum import Enum
from dataclasses import dataclass
import pathlib

parent_folder = pathlib.Path(__file__).parent.resolve()

logging.basicConfig(
    filename=f'{parent_folder}/lint_pull_requests.log',
    encoding='utf-8',
    format='%(asctime)s:%(levelname)s:%(funcName)s:%(message)s',
    level=logging.DEBUG,
)
logger = logging.getLogger(__name__)

class DiffType(Enum):
    ADDED = "+"
    REMOVED = "-"
    MODIFIED = "~"

@dataclass
class DiffLine:
    type: int
    filename: str
    line: str
    line_number: int
    column_number: int

    def error_message(self, message: str) -> str:
        return f"{self.filename}:{self.line_number}:{self.column_number}: {message}" 

def lint(diff_line: DiffLine) -> tuple[str]:
    error_messages = []
    line = diff_line.line.strip()

    if "TODO" in line:
        message = diff_line.error_message("Remaining TODO")
        error_messages.append(message)

    if "breakpoint" in line:
        message = diff_line.error_message("Remaining breakpoint")
        error_messages.append(message)

    if "mock" in line:
        message = diff_line.error_message("Check that the mock is called")
        error_messages.append(message)


    return error_messages

def lint_diffs(diff_lines: tuple[DiffLine]) -> tuple[str]:
    error_messages = []
    for diff_line in diff_lines:
        error_messages.extend(lint(diff_line))
    return error_messages

def parse_patch(patch: tuple[str]) -> tuple[DiffLine]:
    diff_lines = []
    for patch_line in patch:
        patch_line = patch_line.strip()

        if patch_line.startswith("---"):
            filename = None
            plus_line_starts = None

        elif patch_line.startswith("+++"):
            filename = patch_line.split(' ')[1]
            plus_line_starts = None

        elif patch_line.startswith("@@"):
            _, _minus_line_starts, plus_line_starts, _, *_ = patch_line.split(' ')

            # -165 or -417,2
            _minus_line_starts = _minus_line_starts.removeprefix('-').split(',')[0]
            # +165 or +417,2
            plus_line_starts = int(plus_line_starts.removeprefix('+').split(',')[0])

        elif patch_line.startswith("+"):
            assert filename is not None
            assert plus_line_starts is not None

            diff_line = DiffLine(
                type=DiffType.ADDED,
                filename=filename,
                line=patch_line.removeprefix("+"),
                line_number=plus_line_starts,
                column_number=0,
            )

            diff_lines.append(diff_line)

            plus_line_starts += 1
    return diff_lines

def main():
    patch = []
    for in_line in sys.stdin:
        patch.append(in_line)
    diff_lines = parse_patch(patch)
    messages = lint_diffs(diff_lines)
    for m in messages:
        logger.debug(m)
        print(m)

def test_parse_patch():
    patch_raw_string = """
        diff --git config.fish config.fish
        index e9edf19..b17667b 100644
        --- config.fish
        +++ config.fish
        @@ -165 +165 @@ end
        -function ,gnew_branch --argument-names branch_name
        +function ,gnew_branch --argument-names new_branch_name
        @@ -354 +354 @@ function ,docker_build_backend
        -    docker compose -f docker-compose-dev.yml up --build --detach django postgres
        +    docker compose -f docker-compose-dev.yml up --build --detach django
        @@ -417,2 +416,0 @@ function ,npm_run_frontend
        -    # stops the react container, not sure why it's started automatically
        -    docker stop $(docker ps -a -q --filter='name=oneview-react-1')
    """

    diff_lines = parse_patch(patch_raw_string)
    messages = lint_diffs(diff_lines)
    for m in messages:
        print(m)

if __name__ == "__main__":
    main()
