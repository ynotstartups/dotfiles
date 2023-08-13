#!/usr/bin/env python3
"""
copy last edited file in this working directory to file with name such as
`08-Aug-23.md`
"""
import glob
import os
import shutil
from datetime import date
from pathlib import Path
from unittest.mock import patch


def main(path: Path):
    list_directory = glob.glob(str(path / "*"))
    list_of_files = [f for f in list_directory if os.path.isfile(f)]
    last_edited_file = max(list_of_files, key=os.path.getmtime)

    today_date_string = date.today().strftime("%d-%b-%y")  # e.g. 10-Aug-23
    today_date_filepath = path / f"{today_date_string}.md"

    if not os.path.exists(today_date_filepath):
        shutil.copy(last_edited_file, today_date_filepath)


def test_copy_to_new_file(tmp_path):
    expected_file_content = "foo"
    file = tmp_path / "hello.txt"
    file.write_text(expected_file_content)

    main(tmp_path)

    today_date_string = date.today().strftime("%d-%b-%y")  # e.g. 10-Aug-23
    today_date_filepath = tmp_path / f"{today_date_string}.md"
    assert os.path.exists(today_date_filepath)
    with open(today_date_filepath, "r") as f:
        file_content = f.read()
    assert file_content == expected_file_content


@patch.object(shutil, "copy")
def test_no_file_exists(mock_copy, tmp_path):
    today_date_string = date.today().strftime("%d-%b-%y")  # e.g. 10-Aug-23
    today_date_filename = f"{today_date_string}.md"
    file = tmp_path / today_date_filename
    # needed to force to file to create
    file.write_text("bar")

    main(tmp_path)

    mock_copy.assert_not_called()


if __name__ == "__main__":
    main(Path("."))  # pragma: no cover
