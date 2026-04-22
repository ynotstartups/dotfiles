#!/usr/bin/env python3
import subprocess

# TODO: dedup missing import errors in the same file

QUICKFIX_FILE = "quickfix.vim"


def rewrite_path(line: str) -> str:
    line = line.rstrip()
    if line.startswith("./"):
        return "saltus/" + line[2:]
    if not line.startswith("saltus/"):
        return "saltus/" + line
    return line


def run(command: str, outfile):
    result = subprocess.run(
        command.split(" "),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    for line in result.stdout.splitlines():
        line = rewrite_path(line)
        print(line)
        outfile.write(line + "\n")


def main():
    with open(QUICKFIX_FILE, "w") as file:
        print(">>> Running ruff format...")
        run(
            "docker exec oneview-django-1 poetry run ruff format --output-format concise --quiet",
            file,
        )
        print(">>> Running ruff check --fix...")
        run(
            "docker exec oneview-django-1 poetry run ruff check --fix --output-format concise --quiet",
            file,
        )


if __name__ == "__main__":
    main()
