#!/usr/bin/env python3
import os
import argparse
import subprocess

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-t",
        "--ticket_number",
        type=int,
        help="such as 1234",
        required=True,
    )
    parser.add_argument(
        "-d",
        "--dentist",
        help="whether open the dentist jira board, default False",
        action='store_true',
        required=False,
    )
    args = parser.parse_args()

    if args.dentist:
        subprocess.run(
            ["open", f"https://saltus.atlassian.net/browse/DBO-{args.ticket_number}"]
        )
    else:
        subprocess.run(
            ["open", f"https://saltus.atlassian.net/browse/ON-{args.ticket_number}"]
        )

