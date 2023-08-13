"""
python utils functions to be used in Vim or Ultisnips

this file is soft linked to ~/.vim/python3/vim_python.py, so it's able to be imported to Vim or Ultisnips.

## Example of using this in Vim

```vim
function! JumpToTestFile()
py3 << EOF
import vim
from vim_python import get_or_create_test_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_test_file(filepath=vim.eval("@%"))

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
from unittest.mock import patch

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


def test_write_section():
    assert write_section("test 123") == "############\n# test 123 #\n############\n"
    assert (
        write_section("test 123", '"') == '""""""""""""\n" test 123 "\n""""""""""""\n'
    )


def get_test_filepath(filepath: str) -> str:
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


def test_get_test_filepath():
    assert (
        get_test_filepath("saltus/oneview/graphql/foo.py")
        == "saltus/oneview/tests/graphql/test_foo.py"
    )
    assert get_test_filepath("foo.py") == "test_foo.py"


def get_or_create_test_file(filepath: str) -> None:
    test_filepath = get_test_filepath(filepath)
    if not os.path.exists(test_filepath):
        with open(test_filepath, "w"):
            pass
    return test_filepath

def test_create_test_file(tmp_path):
    get_or_create_test_file(str(tmp_path / "foo.py"))

    assert os.path.exists(str(tmp_path / "test_foo.py"))

@patch("builtins.open")
def test_dont_create_test_file(mock_open, tmp_path):
    file = tmp_path / "test_foo.py"
    # needed to force to file to create
    file.write_text("")

    get_or_create_test_file(str(tmp_path / 'foo.py'))

    mock_open.assert_not_called()
