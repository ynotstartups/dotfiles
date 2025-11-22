from unittest import mock

from notes_website import Note, _build_index_md_from_notes, _parse_dev_notes_md_to_notes


class TestParseDevNotesMdToNotesPrivateNotes:
    def test_parse_dev_notes_md_and_Note(self):
        lines = [
            "# test title",
            "tags:python, reference, pin",
            "",
            "*some content*",
            "...",
        ]
        notes = _parse_dev_notes_md_to_notes(
            lines=lines,
            output_private_notes=True,
        )

        assert len(notes) == 1
        note = notes[0]
        assert note.title == "test title"
        assert note.topics == ["python"]
        assert note.markdown == ["", "*some content*", "..."]
        assert note.is_pinned is True
        assert note.is_private is False
        assert note.document_type == "reference"
        assert note.md_filename == "python_reference_test_title.md"
        assert note.html_filename == "python_reference_test_title.html"
        assert note.link == "[test title](python_reference_test_title.html)"
        assert note.hash
        assert str(note)

    def test_work_note_do_not_output_to_public(self):
        lines = [
            "# test title",
            "tags:work, reference, pin",
            "",
        ]
        notes = _parse_dev_notes_md_to_notes(
            lines=lines,
            output_private_notes=False,
        )

        assert len(notes) == 0

    def test_work_note_output_to_private(self):
        lines = [
            "# test title",
            "tags:work, reference",
            "",
        ]
        notes = _parse_dev_notes_md_to_notes(
            lines=lines,
            output_private_notes=True,
        )

        assert len(notes) == 1


class TestBuildIndexMdFromNotes:

    @mock.patch("notes_website.TOPICS", ["python", "git"])
    def test_build_index_md(self):
        note_0 = Note(
            title="# test use git",
            tags_line="tags: git, how_to, pin",
            contents=["abc", "def"],
        )
        note_1 = Note(
            title="# test use python",
            tags_line="tags: python, how_to",
            contents=["abc", "def"],
        )

        markdown = _build_index_md_from_notes(notes=[note_0, note_1])
        assert markdown == [
            "- [test use git](git_how_to_test_use_git.html)\n\n",
            "# [Python](python.html)\n\n",
            "**How To**\n\n",
            "- [test use python](python_how_to_test_use_python.html)\n\n",
            "# [Git](git.html)\n\n",
            "**How To**\n\n",
            "- [test use git](git_how_to_test_use_git.html)\n\n",
        ]
