#!/usr/bin/env python3
"""
YouTube Music Downloader with Metadata
Downloads audio from YouTube with embedded metadata and thumbnails
"""

import argparse
import subprocess
import sys
import shutil
from pathlib import Path
from typing import List, Optional, Dict
import re
import glob
import tempfile
import os


class YouTubeMusicDownloader:
    def __init__(self):
        self.check_dependencies()

    def check_dependencies(self):
        """Check if required dependencies are installed."""
        if not shutil.which("yt-dlp"):
            print("Error: yt-dlp is not installed or not in PATH")
            print("\nTo install yt-dlp:")
            print("  • pip install yt-dlp")
            print("  • Or download from: https://github.com/yt-dlp/yt-dlp")
            sys.exit(1)

    def validate_url(self, url: str) -> bool:
        """Basic URL validation."""
        return bool(re.match(r"^https?://", url))

    def is_playlist_url(self, url: str) -> bool:
        """Check if URL is a playlist."""
        playlist_patterns = [
            r"[?&]list=",
            r"/playlist\?",
            r"music\.youtube\.com/playlist",
        ]
        return any(re.search(pattern, url) for pattern in playlist_patterns)

    def set_metadata_with_mutagen(
        self, filepath: str, metadata: Dict[str, str]
    ) -> bool:
        """Set metadata using mutagen (if available)."""
        try:
            from mutagen.mp3 import MP3
            from mutagen.id3 import ID3, TIT2, TPE1, TALB, TRCK

            audio = MP3(filepath, ID3=ID3)

            # Add ID3 tag if it doesn't exist
            if audio.tags is None:
                audio.add_tags()

            # Set metadata fields
            if "title" in metadata:
                audio.tags["TIT2"] = TIT2(encoding=3, text=metadata["title"])
            if "artist" in metadata:
                audio.tags["TPE1"] = TPE1(encoding=3, text=metadata["artist"])
            if "album" in metadata:
                audio.tags["TALB"] = TALB(encoding=3, text=metadata["album"])
            if "track" in metadata:
                audio.tags["TRCK"] = TRCK(encoding=3, text=metadata["track"])

            audio.save()
            return True
        except ImportError:
            return False
        except Exception as e:
            print(f"Warning: Failed to set metadata with mutagen: {e}")
            return False

    def set_metadata_with_ffmpeg(self, filepath: str, metadata: Dict[str, str]) -> bool:
        """Set metadata using ffmpeg."""
        if not shutil.which("ffmpeg"):
            return False

        try:
            # Build ffmpeg command
            temp_file = f"{filepath}.temp.mp3"
            cmd = ["ffmpeg", "-i", filepath, "-codec", "copy"]

            # Add metadata
            for key, value in metadata.items():
                if key == "track":
                    cmd.extend(["-metadata", f"track={value}"])
                else:
                    cmd.extend(["-metadata", f"{key}={value}"])

            cmd.extend(["-y", temp_file])

            # Run ffmpeg
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                # Replace original with temp file
                Path(temp_file).replace(filepath)
                return True
            else:
                if Path(temp_file).exists():
                    Path(temp_file).unlink()
                return False
        except Exception as e:
            print(f"Warning: Failed to set metadata with ffmpeg: {e}")
            return False

    def crop_thumbnail_to_square(self, mp3_file: str) -> bool:
        """Extract, crop to center square, and re-embed thumbnail."""
        if not shutil.which("ffmpeg") or not shutil.which("ffprobe"):
            print(
                f"  ⚠ ffmpeg/ffprobe not available, skipping thumbnail crop for: {mp3_file}"
            )
            return False

        with tempfile.TemporaryDirectory() as temp_dir:
            original_thumb = os.path.join(temp_dir, "original.jpg")
            cropped_thumb = os.path.join(temp_dir, "cropped.jpg")
            temp_mp3 = os.path.join(temp_dir, "temp.mp3")

            # Extract embedded thumbnail
            extract_cmd = [
                "ffmpeg",
                "-i",
                mp3_file,
                "-an",
                "-vcodec",
                "copy",
                original_thumb,
                "-y",
            ]
            result = subprocess.run(extract_cmd, capture_output=True, text=True)

            if result.returncode != 0:
                # No thumbnail found or extraction failed
                return False

            # Get original thumbnail dimensions
            probe_cmd = [
                "ffprobe",
                "-v",
                "quiet",
                "-select_streams",
                "v:0",
                "-show_entries",
                "stream=width,height",
                "-of",
                "csv=s=x:p=0",
                original_thumb,
            ]
            result = subprocess.run(probe_cmd, capture_output=True, text=True)

            if result.returncode != 0 or not result.stdout.strip():
                return False

            dimensions = result.stdout.strip()
            try:
                width, height = map(int, dimensions.split("x"))
            except ValueError:
                return False

            # Check if already square
            if width == height:
                return True  # Already square, nothing to do

            print(f"  Cropping thumbnail from {width}x{height} to square...")

            # Crop to center square
            crop_cmd = [
                "ffmpeg",
                "-i",
                original_thumb,
                "-vf",
                "crop='if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'",
                "-y",
                cropped_thumb,
            ]
            result = subprocess.run(crop_cmd, capture_output=True, text=True)

            if result.returncode != 0:
                print(f"  ✗ Failed to crop thumbnail")
                return False

            # Re-embed cropped thumbnail
            embed_cmd = [
                "ffmpeg",
                "-i",
                mp3_file,
                "-i",
                cropped_thumb,
                "-map",
                "0:0",
                "-map",
                "1:0",
                "-c",
                "copy",
                "-id3v2_version",
                "3",
                "-metadata:s:v",
                "title=Album cover",
                "-metadata:s:v",
                "comment=Cover (front)",
                "-disposition:v:0",
                "attached_pic",
                "-y",
                temp_mp3,
            ]
            result = subprocess.run(embed_cmd, capture_output=True, text=True)

            if result.returncode != 0:
                print(f"  ✗ Failed to re-embed cropped thumbnail")
                return False

            # Replace original file
            try:
                shutil.move(temp_mp3, mp3_file)
                print(f"  ✓ Thumbnail cropped to square")
                return True
            except Exception as e:
                print(f"  ✗ Failed to replace original file: {e}")
                return False

    def post_process_metadata(self, pattern: str, metadata: Dict[str, str]) -> None:
        """Apply metadata to downloaded files."""
        files = glob.glob(pattern)
        if not files:
            return

        print(f"\nApplying custom metadata to {len(files)} file(s)...")

        # Try mutagen first, then ffmpeg
        for filepath in files:
            if self.set_metadata_with_mutagen(filepath, metadata):
                print(
                    f"  ✓ Updated metadata for: {Path(filepath).name} (using mutagen)"
                )
            elif self.set_metadata_with_ffmpeg(filepath, metadata):
                print(f"  ✓ Updated metadata for: {Path(filepath).name} (using ffmpeg)")
            else:
                print(f"  ✗ Could not update metadata for: {Path(filepath).name}")
                print(
                    "    Install mutagen (pip install mutagen) or ffmpeg for metadata editing"
                )

    def post_process_thumbnails(self, pattern: str) -> None:
        """Crop thumbnails to square for matching files."""
        files = glob.glob(pattern)
        if not files:
            return

        print(f"\nProcessing thumbnails for {len(files)} file(s)...")

        for filepath in files:
            filename = Path(filepath).name
            print(f"  Processing: {filename}")
            self.crop_thumbnail_to_square(filepath)

    def download_single_song(
        self,
        url: str,
        artist: Optional[str] = None,
        title: Optional[str] = None,
        crop_thumbnails: bool = False,
    ) -> bool:
        """Download a single song."""
        print(f"Downloading single song from: {url}")
        print("=" * 50)

        # Build yt-dlp command
        cmd = [
            "yt-dlp",
            "-x",
            "--audio-format",
            "mp3",
            "--audio-quality",
            "0",
            "--embed-metadata",
            "--embed-thumbnail",
            "--convert-thumbnails",
            "png",
            "--parse-metadata",
            "uploader:%(meta_artist)s",
        ]

        # Output format
        if artist:
            # Use custom artist in filename but don't try to override metadata yet
            cmd.extend(["-o", f"{artist}_%(title)s.%(ext)s"])
            pattern = f"{artist}_*.mp3"
        else:
            cmd.extend(["-o", "%(uploader)s_%(title)s.%(ext)s"])
            pattern = "*_*.mp3"

        cmd.append(url)

        try:
            result = subprocess.run(cmd, capture_output=False, text=True)
            if result.returncode == 0:
                print("✓ Download completed successfully")

                # Post-process to set custom metadata if provided
                if artist or title:
                    metadata = {}
                    if artist:
                        metadata["artist"] = artist
                    if title:
                        metadata["title"] = title

                    self.post_process_metadata(pattern, metadata)

                # Crop thumbnails if requested
                if crop_thumbnails:
                    self.post_process_thumbnails(pattern)

                return True
            else:
                print("✗ Download failed")
                return False
        except Exception as e:
            print(f"✗ Error during download: {e}")
            return False

    def download_album_playlist(
        self,
        url: str,
        album: Optional[str] = None,
        artist: Optional[str] = None,
        crop_thumbnails: bool = False,
    ) -> bool:
        """Download an album or playlist."""
        print(f"Downloading album/playlist from: {url}")
        print("=" * 50)

        # Build yt-dlp command
        cmd = [
            "yt-dlp",
            "-x",
            "--audio-format",
            "mp3",
            "--audio-quality",
            "0",
            "--embed-metadata",
            "--embed-thumbnail",
            "--convert-thumbnails",
            "png",
            "--parse-metadata",
            "playlist_index:%(track_number)s",
            "--parse-metadata",
            "uploader:%(meta_artist)s",
            "--parse-metadata",
            "playlist_title:%(meta_album)s",
        ]

        # Output format for playlists
        cmd.extend(["-o", "%(playlist_index)s_%(title)s.%(ext)s"])

        cmd.append(url)

        try:
            result = subprocess.run(cmd, capture_output=False, text=True)
            if result.returncode == 0:
                print("✓ Download completed successfully")

                # Post-process to set custom metadata if provided
                if artist or album:
                    metadata = {}
                    if artist:
                        metadata["artist"] = artist
                    if album:
                        metadata["album"] = album

                    # Apply to all files matching the pattern
                    self.post_process_metadata("*_*.mp3", metadata)

                # Crop thumbnails if requested
                if crop_thumbnails:
                    self.post_process_thumbnails("*_*.mp3")

                return True
            else:
                print("✗ Download failed")
                return False
        except Exception as e:
            print(f"✗ Error during download: {e}")
            return False

    def download(
        self,
        urls: List[str],
        mode: Optional[str] = None,
        artist: Optional[str] = None,
        album: Optional[str] = None,
        title: Optional[str] = None,
        crop_thumbnails: bool = False,
    ) -> None:
        """Main download function."""
        total = len(urls)
        successful = 0
        failed = 0

        print("YouTube Music Downloader")
        print("=" * 50)
        print(f"Processing {total} URL(s)...")

        # Check for metadata tools
        has_mutagen = False
        has_ffmpeg = shutil.which("ffmpeg") is not None
        has_ffprobe = shutil.which("ffprobe") is not None

        try:
            import mutagen

            has_mutagen = True
        except ImportError:
            pass

        if artist or album or title:
            print("\nMetadata override tools:")
            print(
                f"  • mutagen: {'✓ Available' if has_mutagen else '✗ Not installed (pip install mutagen)'}"
            )
            print(f"  • ffmpeg:  {'✓ Available' if has_ffmpeg else '✗ Not installed'}")

            if not has_mutagen and not has_ffmpeg:
                print(
                    "\n⚠ Warning: No metadata tools available. Custom metadata won't be applied."
                )
                print("  Install mutagen (recommended): pip install mutagen")

        if crop_thumbnails:
            print("\nThumbnail cropping:")
            print(
                f"  • ffmpeg:  {'✓ Available' if has_ffmpeg else '✗ Not installed (required)'}"
            )
            print(
                f"  • ffprobe: {'✓ Available' if has_ffprobe else '✗ Not installed (required)'}"
            )

            if not has_ffmpeg or not has_ffprobe:
                print(
                    "\n⚠ Warning: ffmpeg/ffprobe not available. Thumbnails won't be cropped."
                )
                print("  Install ffmpeg to enable thumbnail cropping")

        print()

        for url in urls:
            # Validate URL
            if not self.validate_url(url):
                print(f"Warning: '{url}' doesn't look like a valid URL")
                failed += 1
                continue

            # Determine download mode
            if mode == "single":
                is_playlist = False
            elif mode == "album" or mode == "playlist":
                is_playlist = True
            else:
                # Auto-detect based on URL
                is_playlist = self.is_playlist_url(url)

            # Download based on type
            if is_playlist:
                success = self.download_album_playlist(
                    url, album, artist, crop_thumbnails
                )
            else:
                success = self.download_single_song(url, artist, title, crop_thumbnails)

            if success:
                successful += 1
            else:
                failed += 1

            print()  # Empty line between downloads

        # Print summary
        print("Download Summary")
        print("=" * 50)
        print(f"Total URLs: {total}")
        print(f"Successful: {successful}")
        print(f"Failed: {failed}")

        if failed > 0:
            print("\nSome downloads failed. Common issues:")
            print("  • Video is private, deleted, or geo-blocked")
            print("  • Network connectivity issues")
            print("  • Age-restricted content requiring authentication")
            print("  • Invalid or malformed URL")
            print("\nTry running yt-dlp with -v flag for verbose output")
            sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="YouTube Music Downloader - Downloads audio from YouTube with metadata",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s https://www.youtube.com/watch?v=dQw4w9WgXcQ
  %(prog)s --mode single --artist "Rick Astley" https://www.youtube.com/watch?v=dQw4w9WgXcQ
  %(prog)s --mode album --album "Greatest Hits" https://www.youtube.com/playlist?list=PLxxxxxx
  %(prog)s --crop-thumbnails https://www.youtube.com/watch?v=xxxxx
  %(prog)s --artist "Custom Artist" --crop-thumbnails *.txt

Features:
  • Downloads highest quality audio as MP3
  • Embeds metadata and album artwork
  • Auto-detects single songs vs playlists
  • Allows manual override of artist/album metadata
  • Post-processes files to apply custom metadata
  • Optionally crops thumbnails to square format

Metadata Tools:
  • mutagen (recommended): pip install mutagen
  • ffmpeg: fallback option if mutagen unavailable

Thumbnail Cropping:
  • Requires ffmpeg and ffprobe
  • Crops YouTube's 16:9 thumbnails to center square
  • Preserves original if already square
        """,
    )

    parser.add_argument("urls", nargs="+", help="YouTube URLs to download")

    parser.add_argument(
        "--mode",
        choices=["single", "album", "playlist", "auto"],
        default="auto",
        help="Download mode (default: auto-detect based on URL)",
    )

    parser.add_argument("--artist", help="Override artist name in metadata")

    parser.add_argument(
        "--album", help="Override album name in metadata (for playlists/albums)"
    )

    parser.add_argument(
        "--title", help="Override song title in metadata (for single songs only)"
    )

    parser.add_argument(
        "--crop-thumbnails",
        action="store_true",
        help="Crop thumbnails to square format (requires ffmpeg)",
    )

    args = parser.parse_args()

    # Validate mode-specific arguments
    if args.mode == "single" and args.album:
        print("Warning: --album is ignored for single song downloads")

    if (args.mode == "album" or args.mode == "playlist") and args.title:
        print("Warning: --title is ignored for album/playlist downloads")

    # Create downloader and run
    downloader = YouTubeMusicDownloader()
    downloader.download(
        urls=args.urls,
        mode=args.mode,
        artist=args.artist,
        album=args.album,
        title=args.title,
        crop_thumbnails=args.crop_thumbnails,
    )


if __name__ == "__main__":
    main()
