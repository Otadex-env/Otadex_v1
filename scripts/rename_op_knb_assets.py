#!/usr/bin/env python3
import os
import shutil

BASE = "/home/tilstack/Bureau/Otadex_v1/assets/images/Animé pictures"

def rename_folder(folder_path, prefix, output_ext=".jpeg"):
    if not os.path.isdir(folder_path):
        print(f"  SKIP (not found): {folder_path}")
        return []
    
    files = sorted(os.listdir(folder_path))
    
    # Check max index currently used
    max_index = 0
    existing_renamed = set()
    for f in files:
        if f.startswith(prefix) and f.endswith(output_ext):
            try:
                num = int(f[len(prefix):-len(output_ext)])
                if num > max_index:
                    max_index = num
                existing_renamed.add(f)
            except ValueError:
                pass
                
    renamed = []
    n = max_index + 1
    
    for fname in files:
        if fname in existing_renamed:
            continue
            
        src = os.path.join(folder_path, fname)
        if not os.path.isfile(src):
            continue
            
        dst_name = f"{prefix}{n}{output_ext}"
        dst = os.path.join(folder_path, dst_name)
        
        os.rename(src, dst)
        print(f"  {fname!r:<60} → {dst_name}")
        renamed.append(dst_name)
        n += 1
        
    if not renamed:
        print(f"  No new files to rename in {folder_path}")
        
    return renamed

op_map = {
    "Monkey D. Luffy": "op_luffy",
    "Roronoa Zoro": "op_zoro",
    "Sanji Vinsmoke": "op_sanji",
    "Nami": "op_nami",
    "Trafalgar D. Water Law": "op_law",
    "Portgas D. Ace": "op_ace",
    "Tony Tony Chopper": "op_chopp",
    "Nico Robin": "op_robin",
    "Boa Hancock": "op_hanco",
    "Shanks le Roux": "op_shanks",
    "Sabo": "op_sabo",
    "Usopp": "op_usopp",
    "Jinbe": "op_jinbe",
    "Brook": "op_brook",
    "Franky": "op_franky"
}

knb_map = {
    "Seijūrō Akashi": "knb_akashi",
    "Tetsuya Kuroko": "knb_kurok",
    "Kazunari Takao": "knb_takao",
    "Ryōta Kise": "knb_kise",
    "Taiga Kagami": "knb_kagam",
    "Shintarō Midorima": "knb_midori",
    "Daiki Aomine": "knb_aomin",
    "Atsushi Murasakibara": "knb_muras",
    "Tatsuya Himuro": "knb_himuro",
    "Satsuki Momoi": "knb_momoi",
    "Junpei Hyūga": "knb_hyuga",
    "Teppei Kiyoshi": "knb_kiyos",
    "Riko Aida": "knb_aida"
}

print("=== ONE PIECE ===")
op_base = os.path.join(BASE, "One piece")
for char_name, prefix in op_map.items():
    print(f"\n+++ {char_name} +++")
    rename_folder(os.path.join(op_base, char_name), prefix)

print("\n=== KUROKO NO BASKET ===")
knb_base = os.path.join(BASE, "Kuroko no basket")
for char_name, prefix in knb_map.items():
    print(f"\n+++ {char_name} +++")
    rename_folder(os.path.join(knb_base, char_name), prefix)

print("\nAll done.")
