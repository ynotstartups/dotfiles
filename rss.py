#!/usr/bin/env python3
import feedparser
from pprint import pprint
import datetime
import re
import json
import asyncio

# bold
# yellow
# reset
# link
# clear screen

def load_rss_feed(rss_data, cache):
    url = rss_data["url"]
    title = rss_data["title"]
    article_count = rss_data.get("article_count", 5)
    article_regex = rss_data.get("article_regex", None)

    data = feedparser.parse(url)
    feed = data.feed

    new_articles = []
    for article in data.entries[:article_count]:
        article_title = article.title.title()
        # remove seen articles, i.e. only show new articles
        if article_title in cache:
            continue 

        new_articles.append(article)
        cache.append(article_title)

    if not new_articles:
        return " No new articles!"

    output = f" \033[1m{title}\033[0m\n"

    for article in new_articles:
        link = article.link

        article_title = article.title.title()

        if article_regex:
            article_title = re.search(article_regex, article_title)[0]

        new_indicator = "\033[33mNEW   \033[0m"
        output += f'    {new_indicator} \x1b]8;;{link}\x1b\\{article_title}\x1b]8;;\x1b\\\n'

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

    print('\033c') # clear screen
    for coroutine in asyncio.as_completed(tasks):
        rss_output = await coroutine
        if rss_output is not None:
            print(rss_output)

    with open('../private_dotfiles/rss-cache.json', 'w') as cache_file:
        json.dump(cache, cache_file)

if __name__ == "__main__":
    asyncio.run(main())
