#!/usr/bin/env python3
import asyncio
import feedparser
import json
import re

RESET        = "\033[0m"
BOLD         = "\033[1m"
YELLOW       = "\033[33m"
CLEAR_SCREEN = "\033c"
LINK_URL   = "\x1b]8;;"
LINK_TITLE     = "\x1b\\"
LINK_END     = "\x1b]8;;\x1b\\"

def load_rss_feed(rss_data, cache):
    url = rss_data["url"]
    title = rss_data["title"]
    article_count = rss_data.get("article_count", 5)
    article_regex = rss_data.get("article_regex", None)

    feed = feedparser.parse(url)

    new_articles = [article for article in feed.entries[:article_count] if article.title not in cache]
    cache += [article.title for article in new_articles]

    if not new_articles:
        return

    output = f" {BOLD}{title}{RESET}\n"
    for article in new_articles:
        link = article.link

        # format output title
        article_title = re.search(article_regex, article.title)[0] if article_regex else article.title
        article_title = article.title.title()

        new_indicator = f"{YELLOW}NEW   {RESET}"
        link_output = f"{LINK_URL}{link}{LINK_TITLE}{article_title}{LINK_END}"
        output += f'    {new_indicator} {link_output}\n'

    return output

async def main():
    with open('../private_dotfiles/rss-config.json', 'r') as config_file:
        config = json.load(config_file)

    with open('../private_dotfiles/rss-cache.json', 'r') as cache_file:
        cache = json.load(cache_file)

    tasks = [
        asyncio.to_thread(load_rss_feed, rss_data, cache)
        for rss_data in config
    ]

    print(CLEAR_SCREEN)
    for coroutine in asyncio.as_completed(tasks):
        rss_output = await coroutine
        if rss_output is not None:
            print(rss_output)

    with open('../private_dotfiles/rss-cache.json', 'w') as cache_file:
        json.dump(cache, cache_file)

if __name__ == "__main__":
    asyncio.run(main())
