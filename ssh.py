#!/usr/bin/env python3
import subprocess

SSH_PRIVATE_KEY = "~/.ssh/ssh-private-key"

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "environment",
        choices=["prod", "uat", "test", "test2", "test3"],
        help="oneview environment",
    )
    parser.add_argument(
        "-c",
        "--command",
        choices=["root", "bash", "shell"],
        default="shell",
        help="base",
    )
    args = parser.parse_args()

    result = subprocess.run(
        [
            "pgrep",
            "AWS VPN",
        ],
        capture_output=True,
    )

    if result.returncode == 1:
        print("Did you forget to turn on AWS VPN?")
        exit(1)
    result.check_returncode()

    match args.environment:
        case "prod":
            ec2_name = "oneview-prod-leader"
        case "uat":
            ec2_name = "oneview-uat-leader"
        case "test":
            ec2_name = "oneview-test-leader"
        case "test2":
            ec2_name = "OneView-test2-leader"
        case "test3":
            ec2_name = "OneView-test3-leader"
        case _:
            raise ValueError()

    result = subprocess.run(
        [
            "/usr/local/bin/aws",
            "ec2",
            "describe-instances",
            "--filters",
            f"Name=tag:Name,Values={ec2_name}",
            "--output",
            "text",
            "--query",
            "Reservations[*].Instances[*].PrivateIpAddress",
        ],
        capture_output=True,
        text=True,
    )
    ip_address = result.stdout.strip()

    command = [
        "/usr/bin/ssh",
        "-t",
        "-o",
        "StrictHostKeyChecking=no",
        "-o",
        "ConnectTimeout=10",
        "-i",
        SSH_PRIVATE_KEY,
        f"ec2-user@{ip_address}",
    ]
    match args.command:
        case "root":
            command.append("")
        case "bash":
            command.append("sudo docker exec -it oneview-django bash")
        case "shell":
            command.append(
                "sudo docker exec -it oneview-django poetry run python manage.py shell"
            )
        case _:
            raise ValueError()

    subprocess.run(command)
