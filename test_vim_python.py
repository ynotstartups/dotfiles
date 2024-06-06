import os
from unittest.mock import Mock, patch

import pytest

from vim_python import (
    get_import_path_given_word,
    get_or_create_test_file,
    get_test_filepath,
    write_section,
)


def test_write_section():
    assert write_section("test 123") == "############\n# test 123 #\n############\n"
    assert (
        write_section("test 123", '"') == '""""""""""""\n" test 123 "\n""""""""""""\n'
    )


def test_get_test_filepath():
    assert (
        get_test_filepath("saltus/oneview/graphql/foo.py")
        == "saltus/oneview/tests/graphql/test_foo.py"
    )
    assert get_test_filepath("foo.py") == "test_foo.py"


def test_create_test_file(tmp_path):
    get_or_create_test_file(str(tmp_path / "foo.py"))

    assert os.path.exists(str(tmp_path / "test_foo.py"))


@patch("builtins.open")
def test_dont_create_test_file(mock_open, tmp_path):
    file = tmp_path / "test_foo.py"
    # needed to force to file to create
    file.write_text("")

    get_or_create_test_file(str(tmp_path / "foo.py"))

    mock_open.assert_not_called()


@pytest.mark.parametrize(
    ["word", "expected_import_string"],
    [
        ("uuid4", "from uuid import uuid4"),
        ("mock", "from unittest import mock"),
        ("call", "from unittest.mock import call"),
    ],
)
def test_get_import_path_given_word(word, expected_import_string):
    mock_vim = Mock()
    mock_vim.eval.return_value = word
    assert get_import_path_given_word(mock_vim) == expected_import_string


def test_get_import_path_given_word_in_tag():
    mock_vim = Mock()
    mock_vim.eval.side_effect = [
        "foo",
        [{"filename": "saltus/oneview/email/__init__.py"}],
    ]

    assert get_import_path_given_word(mock_vim) == "from oneview.email import foo"
