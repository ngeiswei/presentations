#!/usr/bin/env python3
"""
Build a "graph portrait" of Kurt Goedel: several thousand nodes and links that,
seen from a distance, resolve into his face.  Source portrait is the
public-domain photo from Wikimedia Commons (figs/godel_a.jpg).

Outputs
  figs/goedel-graph.tex    tikzpicture fragment, \\input by the last frame
  /tmp/goedel-preview.png  fast raster preview (not used by LaTeX)

Usage:  python3 figs/make-goedel-graph.py
"""
import math
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))

CONFIG = dict(
    image="godel_a.jpg",   # source portrait
    canvas_w=6.6,          # cm, drawing area (square; = globe diameter)
    canvas_h=6.6,          # cm
    face_h=5.8,            # cm, portrait height
    face_dx=0.35,          # cm, horizontal nudge of the portrait
    face_dy=-0.25,         # cm, vertical nudge
    crop=(0.02, 0.00, 0.98, 0.80),  # l,t,r,b fractions of the photo to keep
    margin=0.7,            # cm, nodes/links extend this far past the canvas
    clip=True,             # clip to the canvas (keeps the page furniture clean)
    circle=dict(r=3.3, cx=3.3, cy=3.3),   # dict(r=..., cx=..., cy=...) -> "globe"
    n_face=5200,           # nodes sampled from the portrait (before globe crop)
    n_bg=3600,             # uniform background nodes (fills the globe)
    k_near=2,              # nearest-neighbour links per node
    k_rand=1,              # extra random short link per node (0 disables)
    r_rand=1.1,            # cm, max length of a random link
    gamma=3.6,             # tone curve driving the sampling density
    soft_sigma=6.0,        # px, blur of the density (soft silhouette)
    soft_mix=0.10,         # 0 = crisp silhouette, 1 = very soft
    edge_fade=20,          # px, fade the portrait out at its own border
    bg_floor=0.004,        # uniform density floor inside the portrait box
    seed=7,
)

# sampled-tone quantiles -> (TikZ colour, node radius in pt); darkest first
BUCKET_Q = [(0.92, "black!90", 1.30),
            (0.75, "black!70", 1.05),
            (0.45, "black!45", 0.85),
            (0.00, "black!22", 0.70)]
BG_COLOUR, BG_RADIUS = "black!18", 0.55
EDGE_COLOUR, EDGE_WIDTH = "black!35", "0.10pt"
PREVIEW_GRAY = {"black!90": 25, "black!70": 85, "black!45": 155,
                "black!22": 200, "black!18": 212}


def load(path, crop=(0.0, 0.0, 1.0, 1.0)):
    im = Image.open(path).convert("L")
    w0, h0 = im.size
    box = (int(crop[0] * w0), int(crop[1] * h0),
           math.ceil(crop[2] * w0), math.ceil(crop[3] * h0))
    im = im.crop(box).filter(ImageFilter.GaussianBlur(0.6))
    im = im.resize((288, int(288 * im.size[1] / im.size[0])), Image.LANCZOS)
    a = np.asarray(im, dtype=np.float64) / 255.0
    hist, _ = np.histogram(a, bins=256, range=(0, 1))
    eq = np.interp(a, np.linspace(0, 1, 256), hist.cumsum() / hist.sum())
    return a, eq, im.size


def density(tone, cfg):
    """Sampling density: raw-darkness^gamma, softly faded at the photo border."""
    w = tone ** cfg["gamma"]
    w /= w.max() + 1e-9
    blurred = np.asarray(
        Image.fromarray((255 * w).astype(np.uint8))
        .filter(ImageFilter.GaussianBlur(cfg["soft_sigma"])), dtype=np.float64) / 255.0
    w = (1 - cfg["soft_mix"]) * w + cfg["soft_mix"] * blurred
    f = cfg["edge_fade"]
    ramp = 0.5 - 0.5 * np.cos(np.linspace(0, math.pi, f))
    win = np.ones_like(w)
    win[:f] *= ramp[:, None]
    win[-f:] *= ramp[::-1][:, None]
    win[:, :f] *= ramp[None, :]
    win[:, -f:] *= ramp[::-1][None, :]
    return w * win


def knn_edges(pts, k):
    d = ((pts[:, None, :] - pts[None, :, :]) ** 2).sum(-1)
    np.fill_diagonal(d, np.inf)
    nbrs = np.argsort(d, axis=1)[:, :k]
    return {(min(i, int(j)), max(i, int(j))) for i in range(len(pts)) for j in nbrs[i]}


def build(cfg):
    rng = np.random.default_rng(cfg["seed"])
    a, _eq, (iw, ih) = load(os.path.join(HERE, cfg["image"]), cfg["crop"])
    h, _ = a.shape
    tone = 1.0 - a          # 0 = white, 1 = black
    w = density(tone, cfg)

    W, H = cfg["canvas_w"], cfg["canvas_h"]
    fh = cfg["face_h"]
    fw = fh * iw / ih
    x0 = (W - fw) / 2.0 + cfg["face_dx"]
    y0 = (H - fh) / 2.0 + cfg["face_dy"]

    # ---- portrait nodes ---------------------------------------------------
    p = (w.ravel() ** 0.75) + cfg["bg_floor"]
    p /= p.sum()
    idx = rng.choice(p.size, size=cfg["n_face"], replace=False, p=p)
    iy, ix = np.divmod(idx, iw)
    u = (ix + rng.random(cfg["n_face"])) / iw     # 0..1 inside the photo
    v = (iy + rng.random(cfg["n_face"])) / h
    tone_nodes = tone[(v * h).clip(0, h - 1).astype(int),
                      (u * iw).clip(0, iw - 1).astype(int)]
    face = np.stack([x0 + u * fw, H - (y0 + v * fh)], axis=1)

    # ---- background nodes -------------------------------------------------
    m = cfg["margin"]
    bg = np.stack([rng.uniform(-m, W + m, cfg["n_bg"]),
                   rng.uniform(-m, H + m, cfg["n_bg"])], axis=1)
    if cfg["circle"]:
        # background nodes fill a disk (slightly larger than the clip) so the
        # globe reads as a uniform network right up to its rim
        R = cfg["circle"]["r"] + m
        rr = R * np.sqrt(rng.random(cfg["n_bg"]))
        th = rng.uniform(0, 2 * math.pi, cfg["n_bg"])
        bg = np.stack([cfg["circle"]["cx"] + rr * np.cos(th),
                       cfg["circle"]["cy"] + rr * np.sin(th)], axis=1)

    pts = np.vstack([face, bg])
    tones = np.concatenate([tone_nodes, np.zeros(cfg["n_bg"])])
    if cfg["circle"]:
        # keep only portrait nodes inside the globe, then pad with extra bg nodes
        c, R = cfg["circle"], cfg["circle"]["r"]
        inside = np.hypot(face[:, 0] - c["cx"], face[:, 1] - c["cy"]) <= R * 0.995
        face, tones = face[inside], tones[:cfg["n_face"]][inside]
        keep = np.ones(len(pts), bool)
        keep[:cfg["n_face"]] = inside
        pts = np.vstack([face, bg])
        tones = np.concatenate([tones, np.zeros(len(bg))])
        cfg["n_face"] = len(face)

    # ---- links ------------------------------------------------------------
    edges = knn_edges(pts, cfg["k_near"])
    if cfg["k_rand"]:
        for i in range(len(pts)):
            for _ in range(cfg["k_rand"]):
                ang, r = rng.uniform(0, 2 * math.pi), rng.uniform(0.25, cfg["r_rand"])
                q = pts[i] + r * np.array([math.cos(ang), math.sin(ang)])
                d = ((pts - q) ** 2).sum(1)
                d[i] = np.inf
                j = int(np.argmin(d))
                if d[j] < 2 * cfg["r_rand"] ** 2:
                    edges.add((min(i, j), max(i, j)))
    return pts, tones, sorted(edges), cfg


def bucket_of(t, qs):
    """tone -> (colour, radius) using quantile thresholds qs."""
    for (q, colour, radius), thr in zip(BUCKET_Q, qs):
        if t >= thr:
            return colour, radius
    return BUCKET_Q[-1][1], BUCKET_Q[-1][2]


def preview(pts, tones, edges, cfg, qs, path="/tmp/goedel-preview.png"):
    sc = 100
    img = Image.new("RGB", (int(cfg["canvas_w"] * sc), int(cfg["canvas_h"] * sc)), "white")
    dr = ImageDraw.Draw(img)
    H = cfg["canvas_h"]
    for i, j in edges:
        dr.line([pts[i][0] * sc, (H - pts[i][1]) * sc,
                 pts[j][0] * sc, (H - pts[j][1]) * sc], fill=(214, 214, 214), width=1)
    for i, (pt, t) in enumerate(zip(pts, tones)):
        x, y = pt[0] * sc, (H - pt[1]) * sc
        if i >= cfg["n_face"]:
            colour, radius = BG_COLOUR, BG_RADIUS
        else:
            colour, radius = bucket_of(t, qs)
        r = max(1.2, radius * 2.6)
        g = PREVIEW_GRAY[colour]
        dr.ellipse([x - r, y - r, x + r, y + r], fill=(g, g, g))
    if cfg["circle"]:
        mask = Image.new("L", img.size, 0)
        md = ImageDraw.Draw(mask)
        c = cfg["circle"]
        md.ellipse([(c["cx"] - c["r"]) * sc, (H - c["cy"] - c["r"]) * sc,
                    (c["cx"] + c["r"]) * sc, (H - c["cy"] + c["r"]) * sc], fill=255)
        white = Image.new("RGB", img.size, "white")
        img = Image.composite(img, white, mask)
    img.save(path)
    print("preview ->", path)


def emit(pts, tones, edges, cfg, qs, path):
    n_face = cfg["n_face"]
    c = cfg["circle"]
    if c:
        bbox = "  \\useasboundingbox (%.3f,%.3f) rectangle (%.3f,%.3f);\n" % (
            c["cx"] - c["r"], c["cy"] - c["r"], c["cx"] + c["r"], c["cy"] + c["r"])
        clip = "  \\clip (%.3f,%.3f) circle (%.3f);\n" % (c["cx"], c["cy"], c["r"])
    else:
        bbox = "  \\useasboundingbox (0,0) rectangle (%.2f,%.2f);\n" % (
            cfg["canvas_w"], cfg["canvas_h"])
        clip = ("  \\clip (0,0) rectangle (%.2f,%.2f);\n"
                % (cfg["canvas_w"], cfg["canvas_h"])) if cfg["clip"] else ""
    o = ["% Generated by figs/make-goedel-graph.py -- do not edit by hand.\n",
         "\\begin{tikzpicture}[x=1cm,y=1cm]\n", bbox, clip,
         "  \\begin{scope}[draw=%s, line width=%s]\n" % (EDGE_COLOUR, EDGE_WIDTH)]
    for i, j in edges:
        o.append("    \\pgfpathmoveto{\\pgfqpoint{%.3fcm}{%.3fcm}}"
                 "\\pgfpathlineto{\\pgfqpoint{%.3fcm}{%.3fcm}}\n"
                 % (pts[i][0], pts[i][1], pts[j][0], pts[j][1]))
    o.append("    \\pgfusepath{stroke}\n  \\end{scope}\n")

    def circles(sel, colour, radius):
        if not len(sel):
            return
        o.append("  \\begin{scope}[fill=%s]\n" % colour)
        for x, y in sel:
            o.append("    \\pgfpathcircle{\\pgfqpoint{%.3fcm}{%.3fcm}}{%gpt}\n"
                     % (x, y, radius))
        o.append("    \\pgfusepath{fill}\n  \\end{scope}\n")

    circles(pts[n_face:], BG_COLOUR, BG_RADIUS)
    labels = np.array([bucket_of(t, qs)[0] if i < n_face else "" for i, t in
                       enumerate(tones[:n_face])])
    for _q, colour, radius in BUCKET_Q:
        circles(pts[:n_face][labels == colour], colour, radius)
    o.append("\\end{tikzpicture}\n")
    open(path, "w").write("".join(o))
    print("tikz -> %s (%d nodes, %d links, %.0f kB)"
          % (path, len(pts), len(edges), os.path.getsize(path) / 1024))


if __name__ == "__main__":
    cfg = CONFIG
    pts, tones, edges, cfg = build(cfg)
    qs = np.quantile(tones[:cfg["n_face"]], [q[0] for q in BUCKET_Q])
    print("tone quantiles:", np.round(qs, 3))
    preview(pts, tones, edges, cfg, qs)
    emit(pts, tones, edges, cfg, qs, os.path.join(HERE, "goedel-graph.tex"))
