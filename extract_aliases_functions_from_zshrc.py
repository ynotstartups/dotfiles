#!/usr/bin/env python3
"""
extract aliases for functions from .zshrc for fzf
"""
import enum
from dataclasses import dataclass


def main():
    with open(".zshrc", "r") as f:
        file_content = [line.strip() for line in f]

    for line_number, line in enumerate(file_content):
        command = extract_command(line_number, line, file_content)
        # print without newline
        print(command, end="")


ALIAS_PREFIX = "alias "
FUNCTION_PREFIX = "function "


class colors:
    CODE = "\033[33m"  # yellow
    COMMENT = "\33[1m\033[90m"  # bold grey
    RESET = "\033[0m"


class CommandType(enum.Enum):
    ALIAS = enum.auto()
    FUNCTION = enum.auto()
    NOT_A_COMMAND = enum.auto()


@dataclass
class Command:
    """Descripting command with printing __str__ definition"""

    command: str
    command_type: CommandType
    description: str

    def __str__(self):
        if self.command_type is CommandType.ALIAS:
            return f"{self.command: <35}{'A':<5}{colors.CODE}{self.description}{colors.RESET}\n"
        elif self.command_type is CommandType.FUNCTION:
            return f"{self.command: <35}{'F':<5}{colors.COMMENT}{self.description}{colors.RESET}\n"
        else:  # CommandType.NOT_A_COMMAND
            return ""


CommandNone = Command(
    command="", command_type=CommandType.NOT_A_COMMAND, description=""
)


def extract_command(
    line_number: int, line: str, all_lines: list[str]
) -> Command | None:
    if line.startswith(ALIAS_PREFIX):
        alias_command_and_source_code = line.removeprefix(ALIAS_PREFIX)
        alias_command, alias_source_code = alias_command_and_source_code.split(
            "=", maxsplit=1
        )
        alias_source_code = alias_source_code[1:-1]
        # skip alias with no code
        if alias_source_code == "":
            return CommandNone
        return Command(
            command=alias_command,
            command_type=CommandType.ALIAS,
            description=alias_source_code,
        )
    elif line.startswith(FUNCTION_PREFIX):
        command = line.removeprefix(FUNCTION_PREFIX)
        command, _ = command.split("(", maxsplit=1)
        # ignores private function such as "_echo_green
        if command.startswith("_"):
            return CommandNone

        # assumes there is a one line comment above the function definition
        function_comment = all_lines[line_number - 1].strip()
        if not function_comment.startswith("# "):
            function_comment = ""
        else:
            function_comment = function_comment.removeprefix("# ")
        return Command(
            command=command,
            command_type=CommandType.FUNCTION,
            description=function_comment,
        )
    else:
        return CommandNone


def test_extract_empty_alias():
    data = [""]

    result = extract_command(0, data[0], data)

    assert result == CommandNone


def test_extract_alias():
    data = ["alias c=',fzf_find_command'"]

    result = extract_command(0, data[0], data)

    assert result == Command("c", CommandType.ALIAS, ",fzf_find_command")


def test_extract_alias_with_no_source_code():
    data = ["alias c=''"]

    result = extract_command(0, data[0], data)

    assert result is CommandNone


def test_extract_function_without_comment():
    data = ["function ,fzf_find_command() {"]

    result = extract_command(0, data[0], data)

    assert result == Command(",fzf_find_command", CommandType.FUNCTION, "")


def test_extract_private_function():
    data = ["function _foo() {"]

    result = extract_command(0, data[0], data)

    assert result is CommandNone


def test_extract_function_with_comment():
    data = ["# use fzf to find a custom command", "function ,fzf_find_command() {"]

    result = extract_command(1, data[1], data)

    assert result == Command(
        ",fzf_find_command", CommandType.FUNCTION, "use fzf to find a custom command"
    )


def test_function_command_string():
    command = Command(
        ",fzf_find_command", CommandType.FUNCTION, "use fzf to find a custom command"
    )

    assert (
        str(command)
        == ",fzf_find_command                  F    \x1b[1m\x1b[90muse fzf to find a custom command\x1b[0m\n"
    )


def test_alias_command_string():
    command = Command("c", CommandType.ALIAS, ",fzf_find_command")

    assert (
        str(command)
        == "c                                  A    \x1b[33m,fzf_find_command\x1b[0m\n"
    )


def test_not_a_command_string():
    command = CommandNone

    assert str(command) == ""


if __name__ == "__main__":
    main()
