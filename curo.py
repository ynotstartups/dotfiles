#!/usr/bin/env python3
import subprocess

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "environment",
        choices=["prod", "uat"],
        help="curo environment",
    )
    parser.add_argument(
        "entity_name",
        choices=["t4a_review", "account", "t4a_atr", "t4a_curoholding", "contact"],
        help="curo entity name",
    )
    parser.add_argument(
        "curo_id",
        type=str,
        help="curo_id",
    )

    args = parser.parse_args()

    if args.environment == "prod":
        subprocess.run(
            "open",
            f"https://saltus.curo3.net/main.aspx?etn={args.entity_name}&pagetype=entityrecord&id=%7B{args.curo_id}%7D",
        )
    else:
        subprocess.run(
            "open",
            f"https://saltus.curo3uat.net/main.aspx?etn={args.entity_name}&pagetype=entityrecord&id=%7B{args.curo_id}%7D",
        )
