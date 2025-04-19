#!/usr/bin/env python3
"""
Build markdowns based on dev_note.md
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
PIN = "pin"
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

DEV_NOTES_MARKDOWN_FILEPATH = Path("/Users/yuhao.huang/Documents/personal-notes/dev_notes.md")
DEV_NOTES_IMAGES_FILEPATH = Path("/Users/yuhao.huang/Documents/personal-notes/images")
INPUT_DIR = Path("/Users/yuhao.huang/Documents/dotfiles/")
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

    def __init__(self, title: str, contents: list[str]):
        self.title = title.removeprefix("# ").strip()
        self.markdown = contents[1:]
        self.topics = []
        self.is_pinned = False

        raw_tags = contents[0].strip().split(",")
        tags = [i.strip() for i in raw_tags if i]

        for tag in tags:
            if tag in TOPICS:
                self.topics.append(tag)
            elif tag in DOCUMENT_TYPES:
                self.document_type = tag
            elif tag == PIN:
                self.is_pinned = True
            else:
                print(f"!!! Unknown tag: {tag}")

        assert self.topics, f"{self.title} has no tags!"

    @property
    def link(self) -> str:
        return f"[{self.title}]({self.html_filename})"

    @property
    def md_filename(self) -> str:
        slug = re.sub(r"[^a-zA-Z0-9]", "_", self.title)
        topic = "_".join(self.topics)
        return f"{topic}_{self.document_type}_{slug}.md"

    @property
    def html_filename(self) -> str:
        return self.md_filename.replace(".md", ".html")

    @property
    def hash(self) -> bool:
        each_note_to_string = (
            str(self.title)
            + str(self.markdown)
            + str(self.document_type)
            + str(self.topics)
            + str(self.is_pinned)
        )
        return md5(each_note_to_string.encode()).hexdigest()


def _parse_dev_notes_md_to_notes(output_private_notes: bool) -> list[Note]:
    notes = []
    is_in_code_block = False
    title = None
    with open(DEV_NOTES_MARKDOWN_FILEPATH, "r") as file:
        for line in file:
            if line.strip().startswith("```"):
                is_in_code_block = not is_in_code_block
            if not is_in_code_block and line.startswith("# "):
                # this block means we are entering a new markdown file
                if title is not None:
                    notes.append(Note(title, contents))
                title = line
                contents = []  # noqa: F821
            else:
                contents.append(line)
        else:
            # add the last note
            notes.append(Note(title, contents))

    if output_private_notes:
        pass
    else:
        # remove work notes if we only output public notes
        notes = [i for i in notes if "work" not in i.topics]
    return notes


def _build_index_md_from_notes(notes: list[Note]) -> list[str]:
    markdown = []
    for note in notes:
        if note.is_pinned:
            markdown.append(f"- {note.link}\n\n")

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


def _build_topic_md_from_notes(notes: list[Note], topic: str) -> list[str]:
    markdown = []
    for document_type in DOCUMENT_TYPES:
        matching_notes = []
        for note in notes:
            if document_type == note.document_type and topic in note.topics:
                matching_notes.append(note)

        formatted_document_type = document_type.replace("_", " ").title()
        if matching_notes:
            markdown.append(f"# {topic.title()} - {formatted_document_type}\n\n")
            for note in matching_notes:
                markdown.append(f'# {note.title}')
                markdown.extend(note.markdown)
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
        notes = _parse_dev_notes_md_to_notes(output_private_notes=True)
        hash_filepath = HASH_PRIVATE_FILEPATH
    elif sys.argv[1] == "--public":
        output_folder = OUTPUT_PUBLIC_FOLDER
        notes = _parse_dev_notes_md_to_notes(output_private_notes=False)
        hash_filepath = HASH_PUBLIC_FILEPATH
    else:
        raise ValueError(f"Unknown args {sys.argv[1]}")

    notes_updated = []
    with open(hash_filepath, "r") as file:
        existing_note_hash = json.load(file)
    for note in notes:
        if note.title not in existing_note_hash:
            notes_updated.append(note)
        elif existing_note_hash[note.title] != note.hash:
            notes_updated.append(note)
        else:
            # hash hit
            pass

    note_hash = {note.title: note.hash for note in notes}
    with open(hash_filepath, "w") as file:
        json.dump(note_hash, file)

    # write updated notes as htmls
    for note in notes_updated:
        print(f'>>> writing "{note.title}" ...')
        md_filepath = output_folder / note.md_filename
        with open(md_filepath, "w") as file:
            file.writelines(note.markdown)
        html_filepath = output_folder / note.html_filename
        _convert_md_to_html(md_filepath, html_filepath, note.title)

    # copy css and images if any note is updated
    if notes_updated:
        # write index.html
        with open(output_folder / "index.md", "w") as file:
            file.writelines(_build_index_md_from_notes(notes))
        _convert_md_to_html(
            md_filepath=output_folder / "index.md",
            html_filepath=output_folder / "index.html",
            title="index",
        )

        shutil.copy2(STYLES_CSS_FILEPATH, output_folder / STYLES_CSS_FILENAME)
        shutil.copytree(DEV_NOTES_IMAGES_FILEPATH, output_folder / "images", dirs_exist_ok=True)

        for topic in TOPICS:
            topic_markdown_name = f"{topic}.md"
            topic_html_name = f"{topic}.html"
            print(f'>>> writing "{topic_markdown_name}" ...')
            with open(output_folder / topic_markdown_name, "w") as file:
                file.writelines(_build_topic_md_from_notes(notes, topic))
            _convert_md_to_html(
                md_filepath=output_folder / topic_markdown_name,
                html_filepath=output_folder / topic_html_name,
                title=topic.title(),
            )

    # remove temporary markdown files
    files = glob.glob(str(output_folder / "*.md"))
    for f in files:
        os.remove(f)

    print("Done")


if __name__ == "__main__":
    main()
