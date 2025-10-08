from TikTokApi import TikTokApi
import asyncio
import os
from pathlib import Path
import subprocess
import csv
import logging

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger("analytik")

BATCH_SIZE = 10
CSV_DIALECT = "excel"


async def run():
    appdata_path = os.environ.get("APPDATA", None)
    if appdata_path is None:
        raise Exception("Cannot find APPDATA environment variable")
    analytik_path = Path(appdata_path).joinpath("analytik")
    if not analytik_path.exists():
        analytik_path.mkdir(parents=True)
    input_file_path = analytik_path.joinpath("links.txt")
    output_file_path = analytik_path.joinpath("report.csv")
    if not input_file_path.exists():
        with open(input_file_path, "w", encoding="utf-8") as f:
            f.write("Dán các link vào đây, lưu và đóng lại")
    subprocess.run(["notepad", input_file_path])
    with open(input_file_path, "r") as f:
        content = f.read()
    urls = [
        line.strip() for line in content.split("\n") if line.strip().startswith("http")
    ]
    with open(output_file_path, "w") as f:
        writer = csv.writer(f, dialect=CSV_DIALECT)
        writer.writerow(["Link", "View", "Like", "Comment", "Share", "Save"])
    async with TikTokApi() as api:
        await api.create_sessions(num_sessions=1, sleep_after=3, browser="chromium")
        for batch_num in range(len(urls) // BATCH_SIZE + 1):
            tasks = []
            async with asyncio.TaskGroup() as tg:
                for url in urls[
                    BATCH_SIZE * batch_num : min(
                        len(urls), BATCH_SIZE * (batch_num + 1)
                    )
                ]:
                    tasks.append((url, tg.create_task(api.video(url=url).info())))
            with open(output_file_path, "a") as f:
                writer = csv.writer(f, dialect=CSV_DIALECT)
                for url, task in tasks:
                    stats = task.result().get("stats")
                    like_count = stats.get("diggCount")
                    comment_count = stats.get("commentCount")
                    view_count = stats.get("playCount")
                    share_count = stats.get("shareCount")
                    save_count = stats.get("collectCount")
                    logger.info(
                        f"url: {url}, view: {view_count}, like: {like_count}, comment: {comment_count}, share: {share_count}, save: {save_count}"
                    )
                    writer.writerow(
                        [url, view_count, like_count, comment_count, share_count, save_count]
                    )
    subprocess.run(["cmd", "/C", "start", output_file_path])

def main():
    asyncio.run(run())
