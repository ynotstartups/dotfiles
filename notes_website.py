#!/usr/bin/env python3
"""
Build markdowns based on dev_note.md and language reminders

TODO:
    - output both private and public notes in a single run
    - change to argparser
        - add option to reset_notes_website_hash_and_clear_htmls:

"""
import glob
import json
import os
import re
import shutil
import subprocess
import sys
from hashlib import md5
from pathlib import Path

DOCUMENT_TYPES = [
    # document types in html will follow this order
    "reference",
    "how_to",
    "explanation",
]
TOPICS = [
    # topics in html will follow this order
    "engineering",
    "aws",
    "devops",
    "terraform",
    "python",
    "rg",
    "work",
    "sql",
    "vim",
    "book",
    "docker",
    "git",
    "django",
    "sh",
    "career",
    "personal",
]

DEV_NOTES_MARKDOWN_FILEPATH = Path(
    "/Users/yuhao.huang/Documents/personal-notes/dev_notes.md"
)
DEV_NOTES_IMAGES_FILEPATH = Path("/Users/yuhao.huang/Documents/personal-notes/images")
INPUT_DIR = Path("/Users/yuhao.huang/Documents/dotfiles/")
PYTHON_REMINDER_FILEPATH = INPUT_DIR / "language-reminders" / "python.md"
OUTPUT_PRIVATE_FOLDER = Path(
    "/Users/yuhao.huang/Documents/dotfiles/notes_website_output/"
)
OUTPUT_PUBLIC_FOLDER = Path("/Users/yuhao.huang/Documents/notes/")
DATA_PATH = Path("/Users/yuhao.huang/Documents/dotfiles/notes_website_data")
HASH_PRIVATE_FILEPATH = DATA_PATH / ".hash_private.json"
HASH_PUBLIC_FILEPATH = DATA_PATH / ".hash_public.json"
STYLES_CSS_FILENAME = "styles.css"
STYLES_CSS_FILEPATH = DATA_PATH / STYLES_CSS_FILENAME
HEADER_HTML_FILEPATH = DATA_PATH / "header.html"


class Note:
    def __init__(self, title: str, tags_line: str, contents: list[str]):
        self.title = title.removeprefix("# ").strip()
        self.markdown = contents
        self.topics = []
        self.is_pinned = False
        self.is_private = False

        raw_tags = tags_line.removeprefix("tags:").strip().split(",")
        tags = [i.strip() for i in raw_tags if i]

        for tag in tags:
            if tag == "work":
                self.is_private = True
            if tag in TOPICS:
                self.topics.append(tag)
            elif tag in DOCUMENT_TYPES:
                self.document_type = tag
            elif tag == "pin":
                self.is_pinned = True

        if not self.is_private:
            assert self.topics, f"`{self.title}` in dev_notes.md has no tags!"

    @property
    def md_filename(self) -> str:
        slug = re.sub(r"[^a-zA-Z0-9]", "_", self.title)
        topic = "_".join(self.topics)
        return f"{topic}_{self.document_type}_{slug}.md"

    @property
    def html_filename(self) -> str:
        return self.md_filename.replace(".md", ".html")

    @property
    def link(self) -> str:
        return f"[{self.title}]({self.html_filename})"

    @property
    def hash(self) -> str:
        each_note_to_string = (
            str(self.title)
            + str(self.markdown)
            + str(self.document_type)
            + str(self.topics)
            + str(self.is_pinned)
        )
        return md5(each_note_to_string.encode()).hexdigest()

    def __repr__(self) -> str:
        return f"title:\t{self.title}\ntags:\t{self.topics}\nlines:\t{len(self.markdown)}\n"


def _parse_dev_notes_md_to_notes(
    lines: list[str], output_private_notes: bool
) -> list[Note]:
    """
    read dev_notes.md, convert to `Note` object
    important! filter out private (work) notes!
    """
    notes = []

    # parsing the readme file backward this simplifies logics
    index = len(lines) - 1
    contents = []
    while index > 0:
        line = lines[index]
        if line.startswith("tags:") and lines[index - 1].startswith("# "):
            tags_line = line
            title = lines[index - 1]
            notes.append(
                Note(
                    title=title,
                    tags_line=tags_line,
                    # reversing the contents as the file is read in reverse
                    contents=contents[::-1],
                )
            )
            contents = []
            index -= 2
        else:
            contents.append(line)
            index -= 1

    # Note: the order of the notes is the file is read in reverse
    notes = notes[::-1]
    if output_private_notes:
        pass
    else:
        # remove work notes if outputing public notes
        notes = [i for i in notes if not i.is_private]

    return notes


def _build_index_md_from_notes(notes: list[Note]) -> list[str]:
    markdown = []
    # put pinned notes at the top
    for note in notes:
        if note.is_pinned:
            markdown.append(f"- {note.link}\n\n")

    # write each topic
    for topic in TOPICS:
        markdown.append(f"# [{topic.title()}]({topic}.html)\n\n")
        for document_type in DOCUMENT_TYPES:
            matching_notes = []
            for note in notes:
                if document_type == note.document_type and topic in note.topics:
                    matching_notes.append(note)

            formatted_document_type = document_type.replace("_", " ").title()
            if matching_notes:
                markdown.append(f"**{formatted_document_type}**\n\n")
                for note in matching_notes:
                    markdown.append(f"- {note.link}\n\n")
    return markdown


def _convert_md_to_html(md_filepath, html_filepath, title):
    subprocess.run(
        [
            "pandoc",
            md_filepath,
            "-o",
            html_filepath,
            # create table of content in <nav>
            "--toc",
            "--css",
            # this css is attached in the html file
            STYLES_CSS_FILENAME,
            # standalone create standalone html with header, footer, etc...
            "--standalone",
            "--include-in-header",
            HEADER_HTML_FILEPATH,
            "--metadata",
            f"title={title}",
        ]
    )


def main():
    # by default we don't show work notes, work notes are private,
    # unless --private is passed in
    assert len(sys.argv) > 1, "missing --public or --private"
    if sys.argv[1] == "--private":
        output_folder = OUTPUT_PRIVATE_FOLDER
        output_private_notes = True
        hash_filepath = HASH_PRIVATE_FILEPATH
    elif sys.argv[1] == "--public":
        output_folder = OUTPUT_PUBLIC_FOLDER
        output_private_notes = False
        hash_filepath = HASH_PUBLIC_FILEPATH
        TOPICS.remove("work")
    else:
        raise ValueError(f"Unknown args {sys.argv[1]}")

    with open(DEV_NOTES_MARKDOWN_FILEPATH, "r") as file:
        lines = file.readlines()

    notes = _parse_dev_notes_md_to_notes(
        lines=lines,
        output_private_notes=output_private_notes,
    )

    with open(PYTHON_REMINDER_FILEPATH, "r") as file:
        contents = file.readlines()
    notes.append(
        Note(
            title="# Python Language Reminders",
            tags_line="tags: reference, python,",
            contents=contents,
        )
    )

    # check hash, only update changed file
    changed_notes = []
    with open(hash_filepath, "r") as file:
        existing_note_hash = json.load(file)
    for note in notes:
        if note.title not in existing_note_hash:
            changed_notes.append(note)
        elif existing_note_hash[note.title] != note.hash:
            changed_notes.append(note)
        else:
            # hash hit
            pass

    # update hash
    note_hash = {note.title: note.hash for note in notes}
    with open(hash_filepath, "w") as file:
        json.dump(note_hash, file)

    # write updated notes as htmls
    for note in changed_notes:
        print(f'>>> writing "{note.title}" ...')
        md_filepath = output_folder / note.md_filename
        with open(md_filepath, "w") as file:
            file.writelines(note.markdown)
        html_filepath = output_folder / note.html_filename
        _convert_md_to_html(md_filepath, html_filepath, note.title)

    # write index.html if any note is updated
    if changed_notes:
        with open(output_folder / "index.md", "w") as file:
            file.writelines(_build_index_md_from_notes(notes))
        _convert_md_to_html(
            md_filepath=output_folder / "index.md",
            html_filepath=output_folder / "index.html",
            title="index",
        )

        # copy css and images if any note is updated
        shutil.copy2(STYLES_CSS_FILEPATH, output_folder / STYLES_CSS_FILENAME)
        shutil.copytree(
            DEV_NOTES_IMAGES_FILEPATH, output_folder / "images", dirs_exist_ok=True
        )

    # remove temporary markdown files
    files = glob.glob(str(output_folder / "*.md"))
    for f in files:
        os.remove(f)

    print("Done")


if __name__ == "__main__":
    main()
