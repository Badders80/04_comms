#!/usr/bin/env python3
"""Post a single image + caption to X (@EvolutionStable) via API v2."""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import sys
from pathlib import Path

import requests
from requests_oauthlib import OAuth1

ENV_PATH = Path("/home/evo/.env")
UPLOAD_URL = "https://upload.twitter.com/1.1/media/upload.json"
TWEET_URL = "https://api.twitter.com/2/tweets"
MAX_TWEET_LEN = 280


def load_dotenv(path: Path) -> dict[str, str]:
    env: dict[str, str] = {}
    if not path.exists():
        return env
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        value = value.strip().strip('"').strip("'")
        env[key.strip()] = value
    return env


def x_credentials(env: dict[str, str]) -> dict[str, str] | None:
    keys = {
        "api_key": env.get("X_API_KEY") or env.get("TWITTER_API_KEY"),
        "api_secret": env.get("X_API_SECRET") or env.get("TWITTER_API_SECRET"),
        "access_token": env.get("X_ACCESS_TOKEN") or env.get("TWITTER_ACCESS_TOKEN"),
        "access_token_secret": env.get("X_ACCESS_TOKEN_SECRET")
        or env.get("TWITTER_ACCESS_TOKEN_SECRET"),
    }
    if all(keys.values()):
        return keys
    return None


def oauth_session(creds: dict[str, str]) -> requests.Session:
    session = requests.Session()
    session.auth = OAuth1(
        creds["api_key"],
        creds["api_secret"],
        creds["access_token"],
        creds["access_token_secret"],
    )
    return session


def upload_media(session: requests.Session, image_path: Path) -> str:
    mime, _ = mimetypes.guess_type(image_path)
    if mime not in {"image/png", "image/jpeg", "image/jpg", "image/webp", "image/gif"}:
        raise ValueError(f"Unsupported image type for X upload: {mime} ({image_path})")

    with image_path.open("rb") as handle:
        response = session.post(
            UPLOAD_URL,
            files={"media": (image_path.name, handle, mime)},
            timeout=120,
        )
    if response.status_code >= 400:
        raise RuntimeError(f"Media upload failed ({response.status_code}): {response.text}")

    payload = response.json()
    media_id = payload.get("media_id_string") or str(payload.get("media_id", ""))
    if not media_id:
        raise RuntimeError(f"Media upload returned no media_id: {payload}")
    return media_id


def create_tweet(session: requests.Session, text: str, media_id: str) -> dict:
    body = {"text": text, "media": {"media_ids": [media_id]}}
    response = session.post(TWEET_URL, json=body, timeout=60)
    if response.status_code >= 400:
        raise RuntimeError(f"Tweet failed ({response.status_code}): {response.text}")
    return response.json()


def resolve_package(package_dir: Path) -> tuple[Path, Path]:
    manifest_path = package_dir / "manifest.json"
    if manifest_path.exists():
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        image_name = manifest.get("post_asset") or "poster.png"
        caption_name = manifest.get("caption_file") or "x_caption.txt"
        return package_dir / image_name, package_dir / caption_name

    image = package_dir / "poster.png"
    caption = package_dir / "x_caption.txt"
    return image, caption


def main() -> int:
    parser = argparse.ArgumentParser(description="Post image + caption to X")
    parser.add_argument("image", nargs="?", help="Path to image (png/jpg)")
    parser.add_argument("caption", nargs="?", help="Path to caption text file")
    parser.add_argument(
        "--package",
        help="Social package directory (reads manifest.json when present)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Validate inputs and credentials without posting",
    )
    args = parser.parse_args()

    if args.package:
        package_dir = Path(args.package).resolve()
        image_path, caption_path = resolve_package(package_dir)
    else:
        if not args.image or not args.caption:
            parser.error("Provide image + caption paths, or use --package")
        image_path = Path(args.image).resolve()
        caption_path = Path(args.caption).resolve()

    if not image_path.exists():
        print(f"Error: image not found: {image_path}", file=sys.stderr)
        return 1
    if not caption_path.exists():
        print(f"Error: caption not found: {caption_path}", file=sys.stderr)
        return 1

    caption = caption_path.read_text(encoding="utf-8").strip()
    if not caption:
        print(f"Error: caption file is empty: {caption_path}", file=sys.stderr)
        return 1
    if len(caption) > MAX_TWEET_LEN:
        print(
            f"Warning: caption is {len(caption)} chars (X limit {MAX_TWEET_LEN}). "
            "Post may fail unless you have Premium.",
            file=sys.stderr,
        )

    env = {**os.environ, **load_dotenv(ENV_PATH)}
    creds = x_credentials(env)
    if not creds:
        print(
            "Error: X API credentials missing in /home/evo/.env\n"
            "Required: X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_TOKEN_SECRET\n"
            "Create an app at https://developer.x.com → authorize @EvolutionStable → "
            "generate user access tokens with tweet.write scope.",
            file=sys.stderr,
        )
        return 1

    print(f"Image:   {image_path} ({image_path.stat().st_size // 1024} KB)")
    print(f"Caption: {caption_path} ({len(caption)} chars)")
    print("Account: @EvolutionStable (via user access token)")

    if args.dry_run:
        print("Dry run OK — credentials present, ready to post.")
        return 0

    session = oauth_session(creds)
    print("Uploading media...")
    media_id = upload_media(session, image_path)
    print(f"Media ID: {media_id}")
    print("Posting tweet...")
    result = create_tweet(session, caption, media_id)
    tweet_id = result.get("data", {}).get("id", "")
    if tweet_id:
        print(f"Posted: https://x.com/EvolutionStable/status/{tweet_id}")
    else:
        print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())