from unittest import mock

import pytest

from notes_website import Note, _build_index_md_from_notes, _parse_dev_notes_md_to_notes


class TestParseDevNotesMdToNotesPrivateNotes:
    def test_parse_dev_notes_md_and_Note(self):
        lines = [
            "# test title",
            "tags:python, reference, pin",
            "\n",
            "*some content*\n",
            "...\n",
        ]
        notes = _parse_dev_notes_md_to_notes(
            lines=lines,
            output_private_notes=True,
        )

        assert len(notes) == 1
        note = notes[0]
        assert note.title == "test title"
        assert note.topics == ["python"]
        assert note.markdown == "\n*some content*\n...\n"
        assert note.is_pinned is True
        assert note.is_private is False
        assert note.document_type == "reference"
        assert note.md_filename == "python_reference_test_title.md"
        assert note.html_filename == "python_reference_test_title.html"
        assert note.link == "[test title](python_reference_test_title.html)"
        assert note.hash
        assert str(note)

    def test_unmatch_code_block(self):
        lines = [
            "# test title",
            "tags:python, reference, pin",
            "\n",
            "```python\n",
            "```bash\n",
            "\n",
        ]

        with pytest.raises(
            ValueError, match="The line to end a code block must be '```'"
        ):
            _parse_dev_notes_md_to_notes(
                lines=lines,
                output_private_notes=True,
            )

    def test_missing_tags_line(self):
        lines = [
            "# test title",
            "python, reference, pin",
        ]
        with pytest.raises(ValueError, match="Missing `tags:`"):
            _parse_dev_notes_md_to_notes(
                lines=lines,
                output_private_notes=True,
            )


class TestBuildIndexMdFromNotes:

    @mock.patch("notes_website.TOPICS", ["python", "git", "work"])
    def test_build_index_md_for_private(self):
        notes = [
            Note(
                title="# test use git",
                tags_line="tags: git, how_to, pin",
                contents=["abc", "def"],
            ),
            Note(
                title="# test use python",
                tags_line="tags: python, how_to",
                contents=["abc", "def"],
            ),
            # should be Skipped
            Note(
                title="# test use work",
                tags_line="tags: work, how_to",
                contents=["should not be included"],
            ),
        ]

        markdown = _build_index_md_from_notes(notes=notes, is_for_public=False)
        assert markdown == "".join(
            [
                "- [test use git](git_how_to_test_use_git.html)\n\n",
                "# Python\n\n",
                "**How To**\n\n",
                "- [test use python](python_how_to_test_use_python.html)\n\n",
                "# Git\n\n",
                "**How To**\n\n",
                "- [test use git](git_how_to_test_use_git.html)\n\n",
                "# Work\n\n",
                "**How To**\n\n",
                "- [test use work](work_how_to_test_use_work.html)\n\n",
            ]
        )

    @mock.patch("notes_website.TOPICS", ["python", "git", "work"])
    def test_build_index_md_for_public(self):
        notes = [
            Note(
                title="# test use git",
                tags_line="tags: git, how_to, pin",
                contents=["abc", "def"],
            ),
            Note(
                title="# test use python",
                tags_line="tags: python, how_to",
                contents=["abc", "def"],
            ),
            # should be Skipped
            Note(
                title="# test use work",
                tags_line="tags: work, how_to",
                contents=["should not be included"],
            ),
        ]

        markdown = _build_index_md_from_notes(notes=notes, is_for_public=True)
        assert markdown == "".join(
            [
                "- [test use git](git_how_to_test_use_git.html)\n\n",
                "# Python\n\n",
                "**How To**\n\n",
                "- [test use python](python_how_to_test_use_python.html)\n\n",
                "# Git\n\n",
                "**How To**\n\n",
                "- [test use git](git_how_to_test_use_git.html)\n\n",
            ]
        )
