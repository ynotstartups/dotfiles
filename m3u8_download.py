#!/usr/bin/env python3
import asyncio
import httpx

FAKE_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"

# import logging
# logging.basicConfig(level=logging.DEBUG)
async def log_request(request):
    # logging.debug(f"Request headers: {request.headers}")
    pass


NUMBER_CONCURRENT_DOWNLOADS = 16


async def download_part(client, part_name, semaphore, result_dict) -> None:
    async with semaphore:
        # print(f'downloading {part_name}')
        response = await client.get(part_name)
        response.raise_for_status()
        result_dict[part_name] = response.content
        print(f"{str(len(result_dict)).zfill(3)} ", end="", flush=True)


async def download_episode(base_url: str, part_names: list[str], result_dict) -> None:
    async with httpx.AsyncClient(
        base_url=base_url,
        timeout=None,
        event_hooks={"request": [log_request]},
        headers={"user-agent": FAKE_USER_AGENT},
    ) as client:
        # semaphore limits the number of concurrent downloads
        semaphore = asyncio.Semaphore(NUMBER_CONCURRENT_DOWNLOADS)
        tasks = [
            download_part(
                client=client,
                part_name=part_name,
                semaphore=semaphore,
                result_dict=result_dict,
            )
            for part_name in part_names
        ]
        await asyncio.gather(*tasks)


def download_m3u8(m3u8_url: str, video_name: str):
    result_dict = {}
    response = httpx.get(
        m3u8_url, timeout=None, headers={"user-agent": FAKE_USER_AGENT}
    )
    response.raise_for_status()
    part_names = []
    for line in response.text.split("\n"):
        if line.startswith("#"):
            continue
        # skip empty line
        if line.strip() == "":
            continue
        part_names.append(line.strip())

    print("Downloading", video_name, "...")
    print("Total number of parts", len(part_names), "...")

    base_url = "/".join(m3u8_url.split("/")[:-1])
    asyncio.run(
        download_episode(
            base_url=base_url, part_names=part_names, result_dict=result_dict
        )
    )

    with open(f"download/{video_name}", "wb") as combiled_file:
        for part_name in part_names:
            combiled_file.write(result_dict[part_name])


if __name__ == "__main__":
    """
    works for 

    - 欧乐
    - 努努
    - myself-bbs
    - 西瓜动漫
    """
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("m3u8_url", type=str,
                        help="index file for m3u8, response contains a list of video ts fragments")
    parser.add_argument("filename", type=str,
                        help="download to this filename")

    args = parser.parse_args()
    download_m3u8(
        m3u8_url=args.m3u8_url,
        video_name=args.filename,
    )
