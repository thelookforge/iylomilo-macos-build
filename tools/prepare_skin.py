"""Normalize the supplied iylomilo UI artwork for embedding in the plugin.

    python tools/prepare_skin.py [Resources/iylomilo_design_base_v2.png]

The clean UI base is scaled to 1024 x 1080 and written as both an editable normalized source
and embedded skin. Knob and footswitch PNGs are embedded separately. Control coordinates are
maintained in Source/SkinLayout.h.
"""
import pathlib
import sys

import matplotlib.image as mpimg
import numpy as np
from scipy import ndimage

ROOT = pathlib.Path(__file__).resolve().parent.parent
WIDTH, HEIGHT = 1024, 1080


def main():
    source = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "Resources/iylomilo_design_base_v2.png"
    image = mpimg.imread(source)
    image = image[:, :, :3].astype(np.float64)
    h, w = image.shape[:2]
    if (w, h) != (WIDTH, HEIGHT):
        image = ndimage.zoom(image, (HEIGHT / h, WIDTH / w, 1.0), order=3)
    image = np.clip(image[:HEIGHT, :WIDTH], 0.0, 1.0)
    for name in ("iylomilo_skin_clean_source_v2.png", "iylomilo_skin_clean_v2.png"):
        mpimg.imsave(ROOT / "Resources" / name, image)
    print(f"wrote 1024 x 1080 skin artwork from {source}")


if __name__ == "__main__":
    main()
