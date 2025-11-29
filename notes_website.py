#!/usr/bin/env python3
"""
Build markdowns based on dev_note.md and language reminders

TODO:
    - change to argparser
        - add option to replace reset_notes_website_hash_and_clear_htmls
    - use regex to parse markdown?
"""
import json
import re
import shutil
import subprocess
from base64 import urlsafe_b64encode
from hashlib import md5
from pathlib import Path

from pypinyin import lazy_pinyin

from recipes import RECIPES

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
    "db",
    "vim",
    "book",
    "docker",
    "git",
    "django",
    "sh",
    "career",
    "personal",
    "recipe",
]

DOCUMENTS = Path("~/Documents/").expanduser()
PERSONAL_NOTES = DOCUMENTS / "personal-notes"
DOTFILES = DOCUMENTS / "dotfiles"

# notes files
DEV_NOTES_MARKDOWN_FILEPATH = PERSONAL_NOTES / "dev_notes.md"
PYTHON_REMINDER_FILEPATH = DOTFILES / "language-reminders" / "python.md"

# images, cache file, css, and header html
DEV_NOTES_IMAGES_FILEPATH = PERSONAL_NOTES / "images"
DATA_PATH = DOTFILES / "notes_website_data"
HASH_PRIVATE_FILEPATH = DATA_PATH / ".hash_private.json"
STYLES_CSS_FILENAME = "styles.css"
STYLES_CSS_FILEPATH = DATA_PATH / STYLES_CSS_FILENAME
HEADER_HTML_FILEPATH = DATA_PATH / "header.html"

# output folders
OUTPUT_PRIVATE_FOLDER = DOTFILES / "notes_website_output"
OUTPUT_PUBLIC_FOLDER = DOCUMENTS / "notes"


class Note:
    def __init__(self, title: str, tags_line: str, contents: str):
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
        # TODO: is there a better way to remove these charaters?
        slug = re.sub(r"[/ `&,+...;?':-]", "_", self.title)
        slug = "".join(lazy_pinyin(slug))
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

    is_in_codeblock = False
    for index, line in enumerate(lines):
        if line.startswith("```"):
            is_in_codeblock = not is_in_codeblock

        if not is_in_codeblock and line.startswith("# "):
            next_line = lines[index + 1]
            if not next_line.startswith("tags:"):
                raise ValueError(
                    f"Missing `tags:` in {next_line.strip()}, following title {line.strip()}"
                )

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
                    # reversing the lines as the file is read in reverse
                    contents="".join(contents[::-1]),
                )
            )
            contents = []
            index -= 2
        else:
            contents.append(line)
            index -= 1

    # reverse the order of the notes because the file is read in reverse
    notes = notes[::-1]
    return notes


def _build_index_md_from_notes(notes: list[Note], is_for_public=False) -> list[str]:
    markdown = ""
    # put pinned notes at the top
    for note in notes:
        if is_for_public and note.is_private:
            continue
        if note.is_pinned:
            markdown += f"- {note.link}\n\n"

    # write each topic
    for topic in TOPICS:
        if is_for_public and topic == "work":
            continue
        markdown += f"# {topic.title()}\n\n"
        for document_type in DOCUMENT_TYPES:
            matching_notes = []
            for note in notes:
                if document_type == note.document_type and topic in note.topics:
                    matching_notes.append(note)

            formatted_document_type = document_type.replace("_", " ").title()
            if matching_notes:
                markdown += f"**{formatted_document_type}**\n\n"
                for note in matching_notes:
                    markdown += f"- {note.link}\n\n"
    return markdown


def _convert_markdown_string_to_html(markdown: str, html_filepath: Path, title: str):
    subprocess.run(
        [
            "pandoc",
            # pass file in stdin
            "-",
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
        ],
        # pass file from stdin
        input=markdown,
        # use text mode, this will automatically use utf-8 encoding of markdown
        # pass in
        text=True,
        # raises subprocess.CalledProcessError if the process exits with a
        # non-zero exit code
        check=True,
    )


def main():
    with open(DEV_NOTES_MARKDOWN_FILEPATH, "r") as file:
        lines = file.readlines()

    notes = _parse_dev_notes_md_to_notes(
        lines=lines,
        output_private_notes=True,
    )

    with open(PYTHON_REMINDER_FILEPATH, "r") as file:
        contents = file.read()
    notes.append(
        Note(
            title="# Python Language Reminders",
            tags_line="tags: reference, python,",
            contents=contents,
        )
    )

    notes.append(
        Note(
            title="# Menu",
            tags_line="tags: reference, recipe,",
            contents=parse_recipe_readme(),
        )
    )

    notes.extend(parse_recipes_notes())

    # check hash, only update changed file
    changed_notes = []
    with open(HASH_PRIVATE_FILEPATH, "r") as file:
        existing_note_hash = json.load(file)
    for note in notes:
        if note.title not in existing_note_hash:
            changed_notes.append(note)
        elif existing_note_hash[note.title] != note.hash:
            changed_notes.append(note)
        else:
            # hash hit
            pass

    print(changed_notes)

    # update hash
    note_hash = {note.title: note.hash for note in notes}
    with open(HASH_PRIVATE_FILEPATH, "w") as file:
        json.dump(note_hash, file)

    # write changed notes as htmls
    for note in changed_notes:
        # write to private
        print(f'>>> writing private "{note.title}"')
        private_html_filepath = OUTPUT_PRIVATE_FOLDER / note.html_filename
        _convert_markdown_string_to_html(
            note.markdown, private_html_filepath, note.title
        )

        if not note.is_private:
            print(f'>>> writing public  "{note.title}"')
            public_html_filepath = OUTPUT_PUBLIC_FOLDER / note.html_filename
            shutil.copy2(private_html_filepath, public_html_filepath)

    print(">>> writing private index.html")
    _convert_markdown_string_to_html(
        markdown=_build_index_md_from_notes(notes, is_for_public=False),
        html_filepath=OUTPUT_PRIVATE_FOLDER / "index.html",
        title="index",
    )

    print(">>> writing public  index.html")
    _convert_markdown_string_to_html(
        markdown=_build_index_md_from_notes(notes, is_for_public=True),
        html_filepath=OUTPUT_PUBLIC_FOLDER / "index.html",
        title="index",
    )

    # copy css and images
    shutil.copy2(STYLES_CSS_FILEPATH, OUTPUT_PRIVATE_FOLDER / STYLES_CSS_FILENAME)
    shutil.copytree(
        DEV_NOTES_IMAGES_FILEPATH, OUTPUT_PRIVATE_FOLDER / "images", dirs_exist_ok=True
    )
    shutil.copy2(STYLES_CSS_FILEPATH, OUTPUT_PUBLIC_FOLDER / STYLES_CSS_FILENAME)
    shutil.copytree(
        DEV_NOTES_IMAGES_FILEPATH, OUTPUT_PUBLIC_FOLDER / "images", dirs_exist_ok=True
    )
    print("Done")


def to_id(title: str) -> str:
    return urlsafe_b64encode(title.encode("utf-8")).decode("utf-8")


def parse_recipe_readme():
    menu_markdown = ""
    menu_category = None
    menu_subcategory = None
    for recipe in RECIPES:
        # handle category logic
        last_menu_category = menu_category
        menu_category = recipe["menu_category"]
        if menu_category != last_menu_category:
            # New Category
            menu_markdown += f"\n\n## {menu_category}\n\n"
            menu_subcategory = None

        # handle sub_category logic
        last_menu_subcategory = menu_subcategory
        menu_subcategory = recipe.get("menu_subcategory", None)
        if menu_subcategory != last_menu_subcategory:
            if last_menu_subcategory is not None:
                menu_markdown += "\n\n"

        title = recipe["title"]
        if "instructions" in recipe:
            slug = "".join(lazy_pinyin(title.replace("/ ", "_")))
            menu_markdown += f"[{title}](./recipe_how_to_{slug}.html), "
        else:
            menu_markdown += f"{title}, "
    return menu_markdown


def parse_recipes_notes() -> list[Note]:
    notes = []
    for recipe in RECIPES:
        if not "instructions" in recipe:
            continue
        recipe_markdown = ""
        for instruction in recipe["instructions"]:
            recipe_markdown += f"- {instruction}\n"

        notes.append(
            Note(
                title=f"# {recipe['title']}",
                tags_line="tags: how_to, recipe, ",
                contents=recipe_markdown,
            )
        )

    return notes


if __name__ == "__main__":
    main()
