#!/usr/bin/env python
import time
from random import random

import pyautogui

MAX_WIDTH, MAX_HEIGHT = pyautogui.size()
SLEEP_TIME = 60  # seconds


def _get_random_position():
    return (int(random() * MAX_WIDTH), int(random() * MAX_HEIGHT))


def main():
    old_position = pyautogui.position()

    while True:
        time.sleep(SLEEP_TIME)

        current_position = pyautogui.position()
        x, _ = current_position
        # 1496 is the MAX_WIDTH of macbook screen,
        # 1920 is the MAX_WIDTH of monitor screen,
        # so if I use the macbook screen and put cursor at the right edge,
        # don't move cursor
        if x in [1496 - 1, 1920 - 1]:
            print("cursor is at the right edge, don't move cursor")
            continue

        if current_position == old_position:
            print("cursor didn't move, auto move cursor")
            random_position = _get_random_position()
            pyautogui.moveTo(*random_position)
            old_position = random_position
        else:
            print("cursor moved, don't move cursor")
            old_position = current_position


if __name__ == "__main__":
    main()
