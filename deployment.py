#!/usr/bin/env python3
"""
To inspect oneview deployment in CLI
"""
import json
import os
import subprocess

from dotenv import load_dotenv

load_dotenv()
ONEVIEW_AMPLIFY_APP_ID = os.getenv("ONEVIEW_AMPLIFY_APP_ID")


def print_deployment_summaries(environment: str, number_of_deployments: int):
    # aws documentation on aws amplify list-jobs
    # https://docs.aws.amazon.com/cli/latest/reference/amplify/list-jobs.html
    result = subprocess.run(
        [
            "aws",
            "amplify",
            "list-jobs",
            "--max-items",
            str(number_of_deployments),
            "--app-id",
            ONEVIEW_AMPLIFY_APP_ID,
            "--branch-name",
            f"env/{environment}",
        ],
        capture_output=True,
    )
    fe_deployment_data = json.loads(result.stdout)
    fe_summaries = fe_deployment_data["jobSummaries"]

    # https://docs.aws.amazon.com/cli/latest/reference/codepipeline/list-pipeline-executions.html
    result = subprocess.run(
        [
            "aws",
            "codepipeline",
            "list-pipeline-executions",
            "--max-items",
            str(number_of_deployments),
            "--pipeline-name",
            (
                f"oneview-pipeline-{environment}"
                if environment != "prod"
                else f"oneview-{environment}"
            ),
        ],
        capture_output=True,
    )
    be_deployment_data = json.loads(result.stdout)
    be_summaries = be_deployment_data["pipelineExecutionSummaries"]

    for fe_summary, be_summary in zip(fe_summaries, be_summaries):
        print("Start Time:\t", fe_summary["startTime"])
        print("FE Status:\t", fe_summary["status"])
        if "endTime" in fe_summary:
            print("End Time:\t", fe_summary["endTime"])
        else:
            print("End Time:\t", "Running")
        print("BE Status:\t", be_summary["status"].upper())
        print("Update Time:\t", be_summary["lastUpdateTime"])
        print("====")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "environment",
        choices=["prod", "uat", "test", "test2", "test3"],
        help="oneview environment",
    )
    parser.add_argument(
        "-n",
        "--number",
        type=int,
        default=1,
        help="number of recent deployments to retrieve",
    )
    args = parser.parse_args()

    print_deployment_summaries(
        environment=args.environment,
        number_of_deployments=args.number,
    )
