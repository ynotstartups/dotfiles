#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import time
import feedparser
import json
import concurrent.futures

CONFIG_FILEPATH = "../private_dotfiles/rss-config.json"
CACHE_FILEPATH  = "../private_dotfiles/rss-cache.json"

host_name = "0.0.0.0"
port = 8000
ENCODING = "utf-8"

def load_rss_feed(rss_data, cache):
    url = rss_data["url"]
    title = rss_data["title"]
    article_count = rss_data.get("article_count", 5)

    feed = feedparser.parse(url)

    new_articles = [article for article in feed.entries[:article_count] if article.title not in cache]
    cache += [article.title for article in new_articles]

    if not new_articles:
        return

    output = f"<h2>{title}</h2>"
    for article in new_articles:
        article_title = article.title.replace("’", "\'").replace("‘", "\'").replace("–", "-")
        link = article.link
        link_output = f'<a href="{link}">{article_title}</a><br>'
        output += link_output

    return output

def test_yield(rss_data, cache):
    with concurrent.futures.ThreadPoolExecutor() as executor:
        rss_feed_futures = (executor.submit(load_rss_feed, rss_data, cache) for rss_data in config)
        for future in concurrent.futures.as_completed(rss_feed_futures):
            rss_output = future.result()
            if rss_output is not None:
                yield rss_output


class Server(BaseHTTPRequestHandler):
    def do_HEAD(self):
        """
        check if there are new articles

        if yes, returns 200
        if no, returns 204
        """
        with open(CACHE_FILEPATH, 'r') as cache_file:
            cache = json.load(cache_file)

        yielding = test_yield(config, cache)
        if next(yielding, False):
            self.send_response(200)
        else:
            self.send_error(204)

        self.send_header("Content-type", "text/html")
        self.end_headers()

    def do_GET(self):
        with open(CACHE_FILEPATH, 'r') as cache_file:
            cache = json.load(cache_file)

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes('<html><head><title>News</title></head><body style="width: 50%;margin: auto;padding-top:20px">', ENCODING))
        for rss_output in test_yield(config, cache):
            self.wfile.write(bytes(rss_output, ENCODING))

        self.wfile.write(bytes("<h1>That's all.</h1></body></html>", ENCODING))

        # write to cache
        with open(CACHE_FILEPATH, 'w') as cache_file:
            json.dump(cache, cache_file)


if __name__ == "__main__":
    with open(CONFIG_FILEPATH, 'r') as config_file:
        config = json.load(config_file)

    print("Starting server...")
    web_server = ThreadingHTTPServer((host_name, port), Server)
    web_server.serve_forever()
