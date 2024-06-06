"""
python utils functions to be used in Vim or Ultisnips

this file is soft linked to ~/.vim/python3/vim_python.py, so it's able to be imported to Vim or Ultisnips.

## Example of using this in Vim

```vim
function! JumpToTestFile()
py3 << EOF
import vim
from vim_python import get_or_create_alternative_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_alternative_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"edit {test_filepath}")
EOF
endfunction
```

command! JumpToTestFile call JumpToTestFile()

## Example of using this in Ultisnips

```python
global !p
from vim_python import write_section
endglobal

snippet "(.*).SS" "Create Section (postfix)" r
`!p snip.rv = write_section(text=match.group(1), comment_character='\"')`
endsnippet
```
"""

import os


def write_section(text: str, comment_character: str = "#") -> str:
    """
    from:
    example text

    to:
    ################
    # example text #
    ################
    """

    COMMENT_CHARACTER = comment_character

    length_text = len(text)
    top_border = bottom_border = COMMENT_CHARACTER * (length_text + 4) + "\n"
    left_border = f"{COMMENT_CHARACTER} "
    right_border = f" {COMMENT_CHARACTER}\n"
    return f"{top_border}{left_border}{text}{right_border}{bottom_border}"


def get_alternative_filepath(filepath: str) -> str:
    if "test_" in filepath.split("/")[-1]:
        # convert test filepath to filepath
        return filepath.replace("test_", "").replace("tests/", "")
    else:
        # convert filepath to test filepath
        if not filepath.startswith("saltus/oneview/"):
            splitted_filepath = filepath.split("/")
            splitted_filepath[-1] = f"test_{splitted_filepath[-1]}"
            result_filepath = "/".join(splitted_filepath)
            return result_filepath
        else:
            splitted_filepath = filepath.split("/")
            splitted_filepath.insert(2, "tests")
            splitted_filepath[-1] = f"test_{splitted_filepath[-1]}"
            result_filepath = "/".join(splitted_filepath)
            return result_filepath


def get_or_create_alternative_file(filepath: str) -> None:
    alternative_filepath = get_alternative_filepath(filepath)
    if not os.path.exists(alternative_filepath):
        with open(alternative_filepath, "w"):
            pass
    return alternative_filepath


def get_import_path_given_word(vim: object) -> str | None:
    word = vim.eval('expand("<cword>")')

    if word == "uuid4":
        import_string = "from uuid import uuid4"
    elif word == "mock":
        import_string = "from unittest import mock"
    elif word == "call":
        import_string = "from unittest.mock import call"
    else:
        taglists = vim.eval(f'taglist("{word}")')
        if taglists:
            tag = taglists[0]
            filename = tag["filename"]
            from_string = (
                filename.removeprefix("saltus/")
                .removesuffix("/__init__.py")
                .removesuffix(".py")
                .replace("/", ".")
            )
            import_string = f"from {from_string} import {word}"

    return import_string
