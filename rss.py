import feedparser
from pprint import pprint
import datetime
import re
import json

def load_rss_feed(rss_data, cache):
    url = rss_data["url"]
    title = rss_data["title"]
    article_count = rss_data.get("article_count", 5)
    article_regex = rss_data.get("article_regex", None)

    data = feedparser.parse(url)
    feed = data.feed

    recent_articles = []
    for article in data.entries[:article_count]:
        date = datetime.datetime(*article.published_parsed[:7])
        date_today = datetime.datetime.today()
        if date > date_today - datetime.timedelta(days=3):
            recent_articles.append(article)

    if not recent_articles:
        return 

    print("", f"\033[1m{title}\033[0m")

    for article in recent_articles:
        link = article.link

        date = datetime.datetime(*article.published_parsed[:7])
        date_string = date.strftime("%b/%d") # e.g. Mar/10

        article_title = article.title.title()

        if article_regex:
            article_title = re.search(article_regex, article_title)[0]

        if article_title not in cache:
            cache.append(article_title)
            date_string = "\033[33mNEW   \033[0m"

        print("    ", date_string, f'\x1b]8;;{link}\x1b\\{article_title}\x1b]8;;\x1b\\')

    print()

def main():
    with open('../private_dotfiles/rss-config.json', 'r') as config_file:
        config = json.load(config_file)

    with open('../private_dotfiles/rss-cache.json', 'r') as cache_file:
        cache = json.load(cache_file)

    for rss_data in config:
        load_rss_feed(rss_data, cache)

    with open('../private_dotfiles/rss-cache.json', 'w') as cache_file:
        json.dump(cache, cache_file)

if __name__ == "__main__":
    main()
