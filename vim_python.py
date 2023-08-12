#!/usr/bin/env python
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


def test_write_section():
    assert write_section("test 123") == "############\n# test 123 #\n############\n"
    assert (
        write_section("test 123", '"') == '""""""""""""\n" test 123 "\n""""""""""""\n'
    )


def get_test_filepath(filepath: str) -> str:
    if "/" not in filepath:
        return f"test_{filepath}"

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
    if os.path.exists(test_filepath):
        print(f"test file already existed with path {test_filepath}")
    else:
        with open(test_filepath, "w"):
            print(f"new test file created with path {test_filepath}")
    return test_filepath


if __name__ == "__main__":
    pass
