#!/usr/bin/env python

import os

def get_test_filepath(filepath: str) -> str:
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

def get_or_create_test_file(filepath: str) -> None:
    test_filepath = get_test_filepath(filepath)
    if os.path.exists(test_filepath):
        print(f"test file already existed with path {test_filepath}")
    else:
        with open(test_filepath, "w"):
            print(f"new test file created with path {test_filepath}")
    return test_filepath

if __name__ == "__main__":
    pass
