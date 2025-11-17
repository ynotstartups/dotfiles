#!/usr/bin/env python3
"""
- debug run `ollama run qwen2.5-coder:7b`
- support continue_conversation in web by dumping all context in the web and
  ask next question
"""
import json
import logging
import os
import pathlib
import pickle
import subprocess
from datetime import datetime

from dotenv import load_dotenv
from openai import OpenAI

SCRIPT_PATH = pathlib.Path(__file__).parent.resolve()
logging.basicConfig(
    level=logging.DEBUG,
    filename=SCRIPT_PATH / "logs" / "ai.log",
    format="%(asctime)s:%(levelname)s:%(module)s:%(message)s",
)
load_dotenv()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

SYSTEM_PROMPT = "You are a helpful assistant for python backend django developers on MacOS, working in a UK finance wealth management firm."


def get_answer_from_web(question: str, debug: bool):
    system_prompt_and_question = f"{SYSTEM_PROMPT} {question}"
    subprocess.run(
        [
            "open",
            f"https://chatgpt.com/?q={system_prompt_and_question}",
        ],
    )


def get_answer_from_api(question: str, continue_conversation: bool, debug: bool):
    if continue_conversation:
        with open(SCRIPT_PATH / "ai_db.jsonl", "r") as f:
            for line in f:
                lastline = line
        inputs = json.loads(lastline.strip())["inputs"]
        inputs.append(
            {
                "role": "user",
                "content": question,
            },
        )
    else:
        inputs = [
            {
                "role": "system",
                "content": SYSTEM_PROMPT,
            },
            {
                "role": "user",
                "content": question,
            },
        ]

    client = OpenAI(api_key=OPENAI_API_KEY)
    # client = OpenAI(
    #     base_url="http://localhost:11434/v1",  # Local Ollama API
    #     api_key="ollama",  # Dummy key
    # )
    if not debug:
        completion = client.chat.completions.create(
            # model="qwen2.5-coder:7b",
            # model="gpt-oss:20b",
            model="gpt-5-nano",
            messages=inputs,
            verbosity="low",
            reasoning_effort="minimal",
            stream=True,
            store=False,
            stream_options={
                "include_usage": True,
            },
        )
    else:
        with open(SCRIPT_PATH / "ai_output" / "test.pickle", "rb") as f:
            completion = pickle.load(f)

    answer = ""
    for chunk in completion:
        if chunk.choices:
            if chunk.choices[0].delta.content:
                delta_answer = chunk.choices[0].delta.content
                print(delta_answer, end="")
                answer += delta_answer

    print()
    print("============================")
    print("Usage Summary")
    print(f"input token {chunk.usage.prompt_tokens}")
    print(f"output token {chunk.usage.completion_tokens}")
    print(chunk.usage)

    inputs.append({"role": "assistant", "content": answer})
    with open(SCRIPT_PATH / "ai_db.jsonl", "a") as f:
        data = {
            "inputs": inputs,
            "date_created": datetime.now().isoformat(),
            "debug": debug,
            "continue_conversation": continue_conversation,
        }
        json.dump(data, f)
        f.write("\n")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "question",
        type=str,
        nargs="+",
        help="question to ask AI",
    )
    parser.add_argument(
        "--continue_conversation",
        "-c",
        action="store_true",
        help="continue to ask question on last conversation",
    )
    parser.add_argument(
        "--web",
        "-w",
        action="store_true",
        help="open chatgpt web for this question",
    )
    parser.add_argument(
        "--debug",
        "-d",
        action="store_true",
        help="to use a fake streaming response instead of calling open-ai",
    )
    args = parser.parse_args()

    question = " ".join(args.question)

    if args.web:
        get_answer_from_web(question, args.debug)
    else:
        get_answer_from_api(question, args.continue_conversation, args.debug)
