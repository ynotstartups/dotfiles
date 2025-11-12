#!/usr/bin/env python3
import os

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
"""
TODO ideas

- store question and answer in a sqllite db
"""


def get_answer(question: str):
    client = OpenAI(api_key=OPENAI_API_KEY)
    stream = client.responses.create(
        model="gpt-5-nano",
        input=[
            {
                "role": "system",
                "content": "You are a helpful assistant for python backend django developers.",
            },
            {
                "role": "user",
                "content": f"I am a python backend django senior developer using MacOS, {question}",
            },
        ],
        text={"verbosity":'low'},
        reasoning={'effort': 'low',}
        stream=True,
    )
    for event in stream:
        if event.type == "response.output_text.delta":
            print(event.delta, end="", flush=True)

    if event.type == "response.completed":
        print()
        print("Usage Summary")
        print(f"input token {event.response.usage.input_tokens}")
        print(f"output token {event.response.usage.output_tokens}")
        print(event.response.usage)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "question",
        type=str,
        nargs="+",
        help="question to ask AI",
    )
    args = parser.parse_args()

    question = " ".join(args.question)

    get_answer(args.question)

# import pickle
# with open('stream_response.pickle', 'rb') as f:
#     events = pickle.load(f)

# for event in events:
#     # if event.type == 'response.output_text.delta':
#     #     print(event.delta, end='', flush=True)

#     if event.type == "response.completed":
#         from pprint import pp
#         print(event.__dict__)
#         print("============================"
#         print('Usage Summary')
#         print(f'input token {event.response.usage.input_token}')
#         print(f'output token {event.response.usage.output_tokens}')
#         print(event.response.usage)
