"""
OTADEX - Générateur d'assets visuels placeholder
Dépendances : Pillow (pip install Pillow)
Usage       : python3 tools/generate_assets.py
Sortie      : assets/images/onboarding/*.png + assets/images/splash/*.png
"""

import os
import math
import random
from PIL import Image, ImageDraw, ImageFilter

# ─── Couleurs design system OTADEX ───────────────────────────────────────────
BG_DEEP       = (13,  13,  20)
BG_CARD       = (26,  26,  46)
BG_METAL      = (26,  42,  74)
BG_ELEVATED   = (18,  23,  42)
ACCENT        = (255, 101,   0)
PRIMARY       = (92,  43, 226)
RANK_GENIN    = (126, 171, 201)
RANK_JONIN    = (155,  89, 182)
RANK_KAGE     = (255, 101,   0)
SUCCESS       = (34,  197,  94)
ERROR         = (239,  68,  68)
BORDER_SUBTLE = (37,  37,  64)
TEXT_PRIMARY  = (255, 255, 255)
TEXT_SEC      = (160, 160, 192)
TEXT_DIS      = (74,  74, 106)

OUT_ONBOARDING = "assets/images/onboarding"
OUT_SPLASH     = "assets/images/splash"

os.makedirs(OUT_ONBOARDING, exist_ok=True)
os.makedirs(OUT_SPLASH,     exist_ok=True)

random.seed(42)


# ─── Utilitaires ─────────────────────────────────────────────────────────────

def draw_rounded_rect(draw, xy, radius, fill=None, outline=None, width=1):
    x0, y0, x1, y1 = xy
    draw.rounded_rectangle([x0, y0, x1, y1], radius=radius,
                            fill=fill, outline=outline, width=width)

def vertical_gradient(draw, w, h, c_top, c_bot):
    for y in range(h):
        t = y / max(1, h - 1)
        r = int(c_top[0] + t * (c_bot[0] - c_top[0]))
        g = int(c_top[1] + t * (c_bot[1] - c_top[1]))
        b = int(c_top[2] + t * (c_bot[2] - c_top[2]))
        draw.line([(0, y), (w, y)], fill=(r, g, b))

def horizontal_gradient_block(w, h, c_left, c_right):
    img = Image.new("RGB", (w, h))
    draw = ImageDraw.Draw(img)
    for x in range(w):
        t = x / max(1, w - 1)
        r = int(c_left[0] + t * (c_right[0] - c_left[0]))
        g = int(c_left[1] + t * (c_right[1] - c_left[1]))
        b = int(c_left[2] + t * (c_right[2] - c_left[2]))
        draw.line([(x, 0), (x, h)], fill=(r, g, b))
    return img

def draw_radial_glow(draw, cx, cy, radius, color_rgb, alpha_center, steps=40):
    """Dégradé radial approximé via ellipses concentriques."""
    for i in range(steps, 0, -1):
        t = i / steps
        r = int(radius * t)
        a = int(alpha_center * (1 - t))
        if a <= 0 or r <= 0:
            continue
        fill_color = color_rgb + (a,)
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill_color)

def radial_glow_layer(size, cx, cy, radius, color_rgb, alpha_center, steps=30):
    """Retourne un layer RGBA avec glow radial."""
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    draw_radial_glow(draw, cx, cy, radius, color_rgb, alpha_center, steps)
    return layer

def text_line(draw, x, y, width, height, color):
    draw.rectangle([x, y, x + width, y + height], fill=color)


# ─── Image 1 : onboarding_1.png (Encyclopédie — 3 cards) ─────────────────────

def gen_onboarding_1():
    W, H = 1080, 1920
    img = Image.new("RGBA", (W, H), BG_DEEP + (255,))
    draw = ImageDraw.Draw(img)
    vertical_gradient(draw, W, H, BG_DEEP, (26, 26, 46))

    # Glow radial orange central
    glow = radial_glow_layer((W, H), W // 2, H // 2 - 100, 480, ACCENT, 22)
    img.alpha_composite(glow)
    draw = ImageDraw.Draw(img)

    cx, cy = W // 2, H // 2 - 80

    def paste_card(card_rgba, cx_offset, cy_offset, angle=0):
        rotated = card_rgba.rotate(angle, expand=True, resample=Image.BICUBIC)
        px = cx + cx_offset - rotated.width // 2
        py = cy + cy_offset - rotated.height // 2
        img.alpha_composite(rotated, dest=(max(0, px), max(0, py)))

    # ── Card gauche ──
    cw, ch = 280, 380
    card = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    cd = ImageDraw.Draw(card)
    draw_rounded_rect(cd, [0, 0, cw, ch], 24, fill=BG_METAL + (178,))
    grad = horizontal_gradient_block(cw - 4, int(ch * 0.60), (61, 43, 138), PRIMARY)
    card.paste(grad.convert("RGBA"), (2, 2))
    draw_rounded_rect(cd, [0, 0, cw, ch], 24, outline=BORDER_SUBTLE + (160,), width=1)
    text_line(cd, 14, int(ch * 0.67), int(cw * 0.72), 10, TEXT_SEC + (140,))
    text_line(cd, 14, int(ch * 0.67) + 16, int(cw * 0.50), 8, TEXT_DIS + (120,))
    paste_card(card, -320, 30, angle=8)

    # ── Card droite ──
    card2 = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    cd2 = ImageDraw.Draw(card2)
    draw_rounded_rect(cd2, [0, 0, cw, ch], 24, fill=BG_METAL + (178,))
    grad2 = horizontal_gradient_block(cw - 4, int(ch * 0.60), (204, 51, 0), ACCENT)
    card2.paste(grad2.convert("RGBA"), (2, 2))
    draw_rounded_rect(cd2, [0, 0, cw, ch], 24, outline=BORDER_SUBTLE + (160,), width=1)
    text_line(cd2, 14, int(ch * 0.67), int(cw * 0.72), 10, TEXT_SEC + (140,))
    text_line(cd2, 14, int(ch * 0.67) + 16, int(cw * 0.50), 8, TEXT_DIS + (120,))
    paste_card(card2, 320, 30, angle=-8)

    # ── Card centrale ──
    cw_c, ch_c = 320, 440
    card_c = Image.new("RGBA", (cw_c, ch_c), (0, 0, 0, 0))
    cd_c = ImageDraw.Draw(card_c)
    draw_rounded_rect(cd_c, [0, 0, cw_c, ch_c], 24, fill=BG_CARD + (255,))
    grad_c = horizontal_gradient_block(cw_c - 4, int(ch_c * 0.62), (204, 51, 0), ACCENT)
    card_c.paste(grad_c.convert("RGBA"), (2, 2))
    draw_rounded_rect(cd_c, [0, 0, cw_c, ch_c], 24, outline=ACCENT + (255,), width=2)
    text_line(cd_c, 16, int(ch_c * 0.66), int(cw_c * 0.73), 13, TEXT_PRIMARY + (200,))
    text_line(cd_c, 16, int(ch_c * 0.66) + 20, int(cw_c * 0.52), 9, TEXT_SEC + (140,))
    paste_card(card_c, 0, 0)

    draw = ImageDraw.Draw(img)

    # Particules orange
    for _ in range(12):
        px = random.randint(150, W - 150)
        py = random.randint(H // 4, 3 * H // 4)
        pr = random.randint(2, 4)
        pa = random.randint(80, 160)
        draw.ellipse([px - pr, py - pr, px + pr, py + pr], fill=ACCENT + (pa,))

    img.convert("RGB").save(f"{OUT_ONBOARDING}/onboarding_1.png")
    print(f"  ✓ onboarding_1.png (1080×1920)")


# ─── Image 2 : onboarding_2.png (Collection grille) ─────────────────────────

def gen_onboarding_2():
    W, H = 1080, 1920
    img = Image.new("RGB", (W, H), BG_DEEP)
    draw = ImageDraw.Draw(img)
    vertical_gradient(draw, W, H, BG_DEEP, (14, 14, 25))

    COLS, ROWS = 3, 4
    margin_x, margin_y = 60, 280
    gap = 16
    card_w = (W - 2 * margin_x - (COLS - 1) * gap) // COLS
    card_h = int(card_w * 1.15)

    CARD_GRADS = [
        ((92, 43, 226), PRIMARY), ((255, 101, 0), (255, 140, 0)),
        ((126, 171, 201), (70, 130, 180)), ((155, 89, 182), (130, 60, 160)),
        ((204, 51, 0), ACCENT), ((34, 197, 94), (20, 150, 60)),
        ((239, 68, 68), (200, 30, 30)), ((92, 43, 226), (60, 20, 180)),
        ((126, 171, 201), (80, 140, 180)), ((255, 101, 0), (200, 80, 0)),
        ((155, 89, 182), (100, 50, 140)), ((34, 197, 94), (15, 120, 50)),
    ]

    for row in range(ROWS):
        for col in range(COLS):
            idx = row * COLS + col
            x0 = margin_x + col * (card_w + gap)
            y0 = margin_y + row * (card_h + gap)
            x1, y1 = x0 + card_w, y0 + card_h
            is_center = (row == 1 and col == 1)

            draw.rounded_rectangle([x0, y0, x1, y1], radius=12,
                                    fill=BG_CARD, outline=BORDER_SUBTLE, width=1)

            # Bloc couleur haut
            gh = int(card_h * 0.70)
            grad = horizontal_gradient_block(card_w - 4, gh - 2,
                                             CARD_GRADS[idx][0], CARD_GRADS[idx][1])
            img_rgba = img.convert("RGBA")
            img_rgba.paste(grad.convert("RGBA"), (x0 + 2, y0 + 2))
            img = img_rgba.convert("RGB")
            draw = ImageDraw.Draw(img)

            # Lignes texte
            ty = y0 + gh + 8
            draw.rectangle([x0 + 8, ty, x0 + card_w - 8, ty + 7],
                            fill=(180, 180, 200) if is_center else (140, 140, 160))
            draw.rectangle([x0 + 8, ty + 13, x0 + card_w - 35, ty + 19],
                            fill=(100, 100, 130))

            if is_center:
                draw.rounded_rectangle([x0, y0, x1, y1], radius=12,
                                        fill=None, outline=ACCENT, width=2)

            # Icône cœur simulée
            if idx in [0, 2, 6, 10]:
                draw.rectangle([x1 - 22, y1 - 20, x1 - 8, y1 - 10], fill=ERROR)

    # Barre recherche
    sb_x0, sb_y0 = margin_x, margin_y - 80
    sb_x1, sb_y1 = W - margin_x, sb_y0 + 56
    draw.rounded_rectangle([sb_x0, sb_y0, sb_x1, sb_y1], radius=28,
                            fill=BG_ELEVATED, outline=(61, 43, 138), width=1)
    lx, ly = sb_x0 + 22, sb_y0 + 16
    draw.ellipse([lx, ly, lx + 22, ly + 22], fill=None, outline=TEXT_SEC, width=2)
    draw.line([lx + 17, ly + 17, lx + 28, ly + 28], fill=TEXT_SEC, width=2)
    draw.rectangle([sb_x0 + 58, sb_y0 + 23, sb_x0 + 280, sb_y0 + 33], fill=TEXT_DIS)

    img.save(f"{OUT_ONBOARDING}/onboarding_2.png")
    print(f"  ✓ onboarding_2.png (1080×1920)")


# ─── Image 3 : onboarding_3.png (Rangs RPG) ──────────────────────────────────

def gen_onboarding_3():
    W, H = 1080, 1920
    img = Image.new("RGBA", (W, H), (8, 8, 16, 255))
    draw = ImageDraw.Draw(img)

    # Glow radial orange très subtil
    glow = radial_glow_layer((W, H), W // 2, H // 2, 600, ACCENT, 18, steps=20)
    img.alpha_composite(glow)
    draw = ImageDraw.Draw(img)

    # Cercles concentriques fond
    cx_bg, cy_bg = W // 2, H - 100
    for r, a in [(200, 35), (400, 25), (600, 15)]:
        draw.ellipse([cx_bg - r, cy_bg - r, cx_bg + r, cy_bg + r],
                     fill=None, outline=BORDER_SUBTLE + (a,), width=1)

    cw = 900
    mx = (W - cw) // 2

    # ── GENIN ──
    yg = 520
    draw.rounded_rectangle([mx, yg, mx + cw, yg + 220], radius=20,
                            fill=(18, 32, 46), outline=RANK_GENIN + (180,), width=1)
    bx, by = mx + 24, yg + 60
    draw.ellipse([bx, by, bx + 80, by + 80], fill=RANK_GENIN)
    draw.ellipse([bx + 28, by + 28, bx + 52, by + 52], fill=(255, 255, 255))
    draw.rectangle([bx + 100, by + 12, bx + 380, by + 34], fill=TEXT_PRIMARY + (200,))
    draw.rectangle([bx + 100, by + 50, bx + 300, by + 66], fill=TEXT_DIS + (180,))
    draw.rounded_rectangle([mx + cw - 160, yg + 78, mx + cw - 20, yg + 118],
                            radius=10, fill=SUCCESS + (40,))
    draw.rectangle([mx + cw - 148, yg + 90, mx + cw - 32, yg + 106], fill=SUCCESS + (100,))

    # ── JONIN ──
    yj = 780
    draw.rounded_rectangle([mx, yj, mx + cw, yj + 220], radius=20,
                            fill=(30, 21, 53), outline=RANK_JONIN + (200,), width=2)
    bx2, by2 = mx + 24, yj + 60
    draw.ellipse([bx2, by2, bx2 + 80, by2 + 80], fill=RANK_JONIN)
    draw.ellipse([bx2 + 28, by2 + 28, bx2 + 52, by2 + 52], fill=(255, 255, 255))
    draw.rectangle([bx2 + 100, by2 + 12, bx2 + 380, by2 + 34], fill=TEXT_PRIMARY + (210,))
    draw.rectangle([bx2 + 100, by2 + 50, bx2 + 300, by2 + 66], fill=RANK_JONIN + (160,))
    draw.rounded_rectangle([mx + cw - 210, yj - 22, mx + cw - 10, yj + 22],
                            radius=12, fill=RANK_JONIN)
    draw.rectangle([mx + cw - 196, yj - 10, mx + cw - 24, yj + 10], fill=(255, 255, 255, 180))

    # ── KAGE (glow externe) ──
    yk = 1050
    for gstep in range(10, 0, -2):
        a_glow = max(0, 35 - gstep * 3)
        draw.rounded_rectangle(
            [mx - gstep, yk - gstep, mx + cw + gstep, yk + 260 + gstep],
            radius=24 + gstep, fill=None, outline=RANK_KAGE + (a_glow,), width=2)

    grad_kage = horizontal_gradient_block(cw, 260, (26, 16, 0), (45, 31, 0))
    img_rgb = img.convert("RGB")
    img_rgb.paste(grad_kage, (mx, yk))
    img = img_rgb.convert("RGBA")
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([mx, yk, mx + cw, yk + 260], radius=20,
                            fill=None, outline=RANK_KAGE + (255,), width=2)
    bx3, by3 = mx + 24, yk + 70
    draw.ellipse([bx3, by3, bx3 + 90, by3 + 90], fill=RANK_KAGE)
    for angle in range(0, 360, 45):
        ex = int(bx3 + 45 + 20 * math.cos(math.radians(angle)))
        ey = int(by3 + 45 + 20 * math.sin(math.radians(angle)))
        draw.ellipse([ex - 4, ey - 4, ex + 4, ey + 4], fill=(255, 255, 255, 180))
    draw.rectangle([bx3 + 110, by3 + 12, bx3 + 420, by3 + 40], fill=RANK_KAGE + (255,))
    draw.rectangle([bx3 + 110, by3 + 56, bx3 + 320, by3 + 76], fill=TEXT_SEC + (200,))
    draw.rounded_rectangle([mx + cw - 175, yk - 24, mx + cw - 10, yk + 22],
                            radius=12, fill=RANK_KAGE + (255,))
    draw.rectangle([mx + cw - 162, yk - 12, mx + cw - 24, yk + 10], fill=(20, 10, 0, 200))
    for ci in range(3):
        cky = yk + 80 + ci * 44
        draw.rounded_rectangle([mx + cw - 55, cky, mx + cw - 26, cky + 22],
                                radius=4, fill=RANK_KAGE + (180,))

    img.convert("RGB").save(f"{OUT_ONBOARDING}/onboarding_3.png")
    print(f"  ✓ onboarding_3.png (1080×1920)")


# ─── Image 4 : splash_illustration.png ───────────────────────────────────────

def gen_splash_illustration():
    W, H = 1080, 1920
    img = Image.new("RGBA", (W, H), BG_DEEP + (255,))
    draw = ImageDraw.Draw(img)

    # Motif hexagonal (stroke violet très transparent)
    hex_s = 80
    hex_w_step = int(hex_s * 1.5)
    hex_h_step = int(hex_s * math.sqrt(3))

    def hex_pts(cx, cy, s):
        return [(int(cx + s * math.cos(math.radians(60 * i - 30))),
                 int(cy + s * math.sin(math.radians(60 * i - 30))))
                for i in range(6)]

    rows = H // hex_h_step + 3
    cols = W // hex_w_step + 3
    for row in range(-1, rows):
        for col in range(-1, cols):
            cx_h = col * hex_w_step + hex_s
            cy_h = row * hex_h_step + (hex_h_step // 2 if col % 2 == 1 else 0)
            pts = hex_pts(cx_h, cy_h, hex_s - 4)
            draw.polygon(pts, fill=None, outline=PRIMARY + (15,))

    # Glow radial orange
    glow = radial_glow_layer((W, H), W // 2, H // 2, int(W * 0.42),
                              ACCENT, 28, steps=25)
    img.alpha_composite(glow)
    draw = ImageDraw.Draw(img)

    # Cercles concentriques fins
    cx, cy = W // 2, H // 2
    for r, a in [(150, 18), (280, 13), (400, 9), (520, 6)]:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r],
                     fill=None, outline=ACCENT + (a,), width=1)

    # 8 étincelles
    rng2 = random.Random(7)
    for _ in range(8):
        ang = rng2.uniform(0, 360)
        dist = rng2.uniform(180, 450)
        ex = int(cx + dist * math.cos(math.radians(ang)))
        ey = int(cy + dist * math.sin(math.radians(ang)))
        length = rng2.randint(20, 40)
        a2 = rng2.uniform(-20, 20)
        ex2 = int(ex + length * math.cos(math.radians(ang + a2)))
        ey2 = int(ey + length * math.sin(math.radians(ang + a2)))
        alpha = rng2.randint(100, 200)
        draw.line([ex, ey, ex2, ey2], fill=ACCENT + (alpha,), width=2)

    img.convert("RGB").save(f"{OUT_SPLASH}/splash_illustration.png")
    print(f"  ✓ splash_illustration.png (1080×1920)")


# ─── Image 5 : rank_bg_kage.png ──────────────────────────────────────────────

def gen_rank_bg_kage():
    W, H = 800, 200
    img = horizontal_gradient_block(W, H, (26, 16, 0), (45, 31, 0))
    draw = ImageDraw.Draw(img.convert("RGBA"))

    # Croisillons diagonaux
    step = 20
    img_rgba = img.convert("RGBA")
    d2 = ImageDraw.Draw(img_rgba)
    for i in range(-H, W + H, step):
        d2.line([(i, 0), (i + H, H)], fill=ACCENT + (10,), width=1)
        d2.line([(i + H, 0), (i, H)], fill=ACCENT + (10,), width=1)

    # Glow centrale
    glow = radial_glow_layer((W, H), W // 2, H // 2, W // 3, ACCENT, 22, steps=15)
    img_rgba.alpha_composite(glow)
    img_rgba.convert("RGB").save(f"{OUT_SPLASH}/rank_bg_kage.png")
    print(f"  ✓ rank_bg_kage.png (800×200)")


# ─── Main ─────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("\n🎨 OTADEX Asset Generator — Task #02")
    print("=" * 45)
    gen_onboarding_1()
    gen_onboarding_2()
    gen_onboarding_3()
    gen_splash_illustration()
    gen_rank_bg_kage()
    print("=" * 45)
    print("✅ Tous les assets ont été générés avec succès !\n")
