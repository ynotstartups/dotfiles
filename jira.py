#!/usr/bin/env python3
import os

import httpx
from dotenv import load_dotenv

# -----------------------------
# LOAD ENVIRONMENT VARIABLES
# -----------------------------
load_dotenv()

JIRA_BASE_URL = os.getenv("JIRA_URL")
JIRA_EMAIL = os.getenv("JIRA_EMAIL")
JIRA_API_TOKEN = os.getenv("JIRA_TOKEN")
JIRA_PROJECT = os.getenv("JIRA_PROJECT")
STATUSES = ["To Do", "In Progress"]


# -----------------------------
# FETCH JIRA TICKETS (NEW API)
# -----------------------------
def show_my_tickets_in_sprint(statuses=STATUSES):
    url = f"{JIRA_BASE_URL}rest/api/3/search/jql"
    query = {
        "jql": "sprint in openSprints() AND assignee = currentUser()",
        "fields": "key,summary,status",
    }

    with httpx.Client(auth=(JIRA_EMAIL, JIRA_API_TOKEN)) as client:
        response = client.get(url, params=query)
        response.raise_for_status()
        data = response.json()

    issues = []
    for issue in data["issues"]:
        ticket_number = issue["key"]
        status = issue["fields"]["status"]["name"]
        title = issue["fields"]["summary"]
        # sort by status 'Code Review', 'In Progress', 'TODO', 'Done'
        issues.append((ticket_number, status, title))

    if not issues:
        print("there is no issues!")
        print("Check if the Jira Token is expired, Jira Token will expire on Nov/2026")

    priority = {
        "Blocked": 0,
        "In Review": 1,
        "In Progress": 2,
        "Ready for sprint": 3,
        "Done": 4,
    }
    issues.sort(key=lambda x: priority.get(x[1], 999))

    for ticket_number, status, title in issues:
        print(f"{ticket_number} {status: <20} {title}")


if __name__ == "__main__":
    import argparse
    import subprocess

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-t",
        "--ticket_number",
        type=int,
        help="such as 1234",
        required=False,
    )
    args = parser.parse_args()

    if not args.ticket_number:
        show_my_tickets_in_sprint()
    else:
        subprocess.run(
            ["open", f"https://saltus.atlassian.net/browse/ON-{args.ticket_number}"]
        )
