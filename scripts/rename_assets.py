#!/usr/bin/env python3
"""
Rename all anime character images to the OTADEX naming convention:
  JJK  → jj_[abbrev][n].jpeg
  NS   → ns_[abbrev][n].jpeg
  CLK  → clk_[abbrev][n].jpeg
"""

import os
import shutil

BASE = "/home/tilstack/Bureau/Otadex_v1/assets/images/Animé pictures"

def rename_folder(folder_path, prefix, output_ext=".jpeg"):
    """Rename all files in folder to prefix1.ext, prefix2.ext, ..."""
    if not os.path.isdir(folder_path):
        print(f"  SKIP (not found): {folder_path}")
        return []
    files = sorted(os.listdir(folder_path))
    renamed = []
    n = 1
    for fname in files:
        src = os.path.join(folder_path, fname)
        if not os.path.isfile(src):
            continue
        # Skip already-correctly-named files (prefix already matches)
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


# ─── JJK: fix Sukuna (was jj_sugu*, collision with Suguru Geto) ──────────────
print("\n=== JJK / Sukuna ===")
rename_folder(f"{BASE}/Jujutsu kaizen/Sukuna", "jj_suku")

# ─── JJK: fix Yuji Itadori (was jj_toji*, collision with Toji Fushiguro) ─────
print("\n=== JJK / Yuji Itadori ===")
rename_folder(f"{BASE}/Jujutsu kaizen/Yuji Itadori", "jj_yuji")

# ─── Naruto Shippuden ─────────────────────────────────────────────────────────
ns = f"{BASE}/Naruto Shippuden"

print("\n=== NS / Gaara ===")
rename_folder(f"{ns}/Gaara", "ns_gaara")

print("\n=== NS / Hashirama Senju ===")
rename_folder(f"{ns}/Hashirama Senju", "ns_hashi")

print("\n=== NS / Hinata Hyuga ===")
rename_folder(f"{ns}/Hinata Hyuga", "ns_hinata")

print("\n=== NS / Itachi Uchiha ===")
rename_folder(f"{ns}/Itachi Uchiha", "ns_itachi")

print("\n=== NS / Jiraiya ===")
rename_folder(f"{ns}/Jiraiya", "ns_jira")

print("\n=== NS / Kakashi Hatake ===")
rename_folder(f"{ns}/Kakashi Hatake", "ns_kakashi")

print("\n=== NS / Konan ===")
rename_folder(f"{ns}/Konan", "ns_konan")

print("\n=== NS / Madara Uchiha ===")
rename_folder(f"{ns}/Madara Uchiha", "ns_madara")

print("\n=== NS / Might Guy ===")
rename_folder(f"{ns}/Might Guy", "ns_guy")

print("\n=== NS / Naruto Uzumaki ===")
rename_folder(f"{ns}/Naruto Uzumaki", "ns_naruto")

print("\n=== NS / Neji Hyuga ===")
rename_folder(f"{ns}/Neji Hyuga", "ns_neji")

print("\n=== NS / Pain ===")
rename_folder(f"{ns}/Pain", "ns_pain")

print("\n=== NS / Rock Lee ===")
rename_folder(f"{ns}/Rock Lee", "ns_lee")

print("\n=== NS / Sasuke Uchiha ===")
rename_folder(f"{ns}/Sasuke Uchiha", "ns_sasuke")

# ─── Classroom of Elite ───────────────────────────────────────────────────────
clk = f"{BASE}/Classroom of Elite"

print("\n=== CLK / Kei Karuizawa ===")
rename_folder(f"{clk}/Kei Karuizawa", "clk_karu")

print("\n=== CLK / Kiyotaka Ayanokoji ===")
rename_folder(f"{clk}/Kiyotaka Ayanokoji", "clk_ayan")

print("\n=== CLK / Suzune Horikita ===")
rename_folder(f"{clk}/Suzune Horikita", "clk_hori")

print("\nDone.")
