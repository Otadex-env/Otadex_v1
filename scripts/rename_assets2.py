#!/usr/bin/env python3
"""
Round 2 — rename newly added images.
Skips files that already match the target prefix pattern.
"""

import os
import re

BASE = "/home/tilstack/Bureau/Otadex_v1/assets/images/Animé pictures"


def rename_new_files(folder_path, prefix, start_n=1, output_ext=".jpeg"):
    """
    Rename files whose name does NOT already match prefix+digit pattern.
    Already-renamed files (e.g. clk_ayan1.jpeg) are skipped.
    New files get numbered starting from start_n.
    """
    if not os.path.isdir(folder_path):
        print(f"  SKIP (not found): {folder_path}")
        return []

    already_pattern = re.compile(rf'^{re.escape(prefix)}\d+\.jpeg$')
    files = sorted(os.listdir(folder_path))

    # Find highest already-used number
    max_n = start_n - 1
    for f in files:
        m = re.match(rf'^{re.escape(prefix)}(\d+)\.jpeg$', f)
        if m:
            max_n = max(max_n, int(m.group(1)))

    n = max_n + 1
    renamed = []
    for fname in files:
        src = os.path.join(folder_path, fname)
        if not os.path.isfile(src):
            continue
        if already_pattern.match(fname):
            print(f"  OK   {fname}")
            renamed.append(fname)
            continue
        dst_name = f"{prefix}{n}{output_ext}"
        dst = os.path.join(folder_path, dst_name)
        os.rename(src, dst)
        print(f"  {fname!r:<60} → {dst_name}")
        renamed.append(dst_name)
        n += 1
    return renamed


def rename_folder(folder_path, prefix, output_ext=".jpeg"):
    """Rename ALL files sequentially (for new folders with no existing renamed files)."""
    if not os.path.isdir(folder_path):
        print(f"  SKIP (not found): {folder_path}")
        return []
    files = sorted(os.listdir(folder_path))
    n = 1
    renamed = []
    for fname in files:
        src = os.path.join(folder_path, fname)
        if not os.path.isfile(src):
            continue
        dst_name = f"{prefix}{n}{output_ext}"
        dst = os.path.join(folder_path, dst_name)
        if src == dst:
            print(f"  OK   {fname}")
            renamed.append(dst_name)
            n += 1
            continue
        os.rename(src, dst)
        print(f"  {fname!r:<60} → {dst_name}")
        renamed.append(dst_name)
        n += 1
    return renamed


ns = f"{BASE}/Naruto Shippuden"
clk = f"{BASE}/Classroom of Elite"

# ─── NS: new folders with raw images ─────────────────────────────────────────
print("\n=== NS / Minato Namikaze ===")
rename_folder(f"{ns}/Minato Namikaze", "ns_mina")

print("\n=== NS / Orochimaru ===")
rename_folder(f"{ns}/Orochimaru", "ns_oroc")

print("\n=== NS / Sakura Haruno ===")
rename_folder(f"{ns}/Sakura Haruno", "ns_saku")

# ─── CLK: new folders ─────────────────────────────────────────────────────────
print("\n=== CLK / Arisu Sakayanagi ===")
rename_folder(f"{clk}/Arisu Sakayanagi ", "clk_saka")  # trailing space in folder name

print("\n=== CLK / Honami Ichinose ===")
rename_folder(f"{clk}/honami ichinose", "clk_ichi")

print("\n=== CLK / Kakeru Ryuen ===")
rename_folder(f"{clk}/kakeru ryuen", "clk_ryue")

print("\n=== CLK / Manabu Horikita ===")
rename_folder(f"{clk}/Manabu Horikita", "clk_mana")

# ─── CLK: Ayanokoji — only rename the 4 newly added files ────────────────────
print("\n=== CLK / Kiyotaka Ayanokoji (new files only) ===")
rename_new_files(f"{clk}/Kiyotaka Ayanokoji", "clk_ayan")

print("\nDone.")
