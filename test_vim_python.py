import os
from unittest import mock
from unittest.mock import Mock, patch

import pytest

from vim_python import (
    format_markdown_table,
    get_alternative_filepath,
    get_import_path_given_word,
    get_or_create_alternative_file,
)


def test_get_alternative_filepath_non_saltus_file():
    assert get_alternative_filepath("foo.py") == "test_foo.py"
    assert get_alternative_filepath("test_foo.py") == "foo.py"


def test_get_alternative_filepath_saltus_file():
    assert (
        get_alternative_filepath("saltus/oneview/graphql/foo.py")
        == "saltus/oneview/tests/graphql/test_foo.py"
    )
    assert (
        get_alternative_filepath("saltus/oneview/tests/graphql/test_foo.py")
        == "saltus/oneview/graphql/foo.py"
    )


def test_get_alternative_filepath_saltus_public_api_files(tmp_path):
    assert (
        get_alternative_filepath("saltus/public_api/views/report_pack.py")
        == "saltus/public_api/tests/views/test_report_pack.py"
    )
    assert (
        get_alternative_filepath("saltus/public_api/tests/views/test_report_pack.py")
        == "saltus/public_api/views/report_pack.py"
    )


@mock.patch("vim_python._file_exists")
def test_get_alternative_filepath_backup_api_files(mock_file_exists, tmp_path):
    mock_file_exists.return_value = True
    # note the api is not in the test filepath
    assert (
        get_alternative_filepath("saltus/oneview/graphql/api/fee.py")
        == "saltus/oneview/tests/graphql/test_fee.py"
    )
    # note the api is added in the source filepath
    assert (
        get_alternative_filepath("saltus/oneview/tests/graphql/test_fee.py")
        == "saltus/oneview/graphql/api/fee.py"
    )


def test_create_alternative_file(tmp_path):
    get_or_create_alternative_file(str(tmp_path / "foo.py"))

    assert os.path.exists(str(tmp_path / "test_foo.py"))


@patch("builtins.open")
def test_dont_create_alternative_file(mock_open, tmp_path):
    file = tmp_path / "test_foo.py"
    # needed to write to file to create
    file.write_text("")

    get_or_create_alternative_file(str(tmp_path / "foo.py"))

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


def test_format_markdown_table_malform_table():
    mock_vim = Mock()
    mock_vim.current.buffer = [
        "",
        "|||",
        "|-|-|",
        "|abc|def|",
        "",
    ]
    mock_vim.current.range.start = 1

    format_markdown_table(mock_vim)
    assert mock_vim.current.buffer == [
        "",
        "|     |     |",
        "|-----|-----|",
        "| abc | def |",
        "",
    ]


def test_format_markdown_table_correct_table():
    mock_vim = Mock()
    mock_vim.current.buffer = [
        "",
        "|     |     |",
        "|-----|-----|",
        "| abc | def |",
        "",
    ]
    mock_vim.current.range.start = 1

    format_markdown_table(mock_vim)
    assert mock_vim.current.buffer == [
        "",
        "|     |     |",
        "|-----|-----|",
        "| abc | def |",
        "",
    ]
