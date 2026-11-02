#!/usr/bin/env python3
"""Ordinary earned-ending input; no game, save, or state access.

The recorded Junior and Senior routes start at S3844 with held item15 and
flag2004=1. Their native/build evidence is recorded separately in RECOMP-30.
Place beside story_route.py, or add its existing directory to PYTHONPATH.
"""
import argparse
from story_route import R, load_save_prefix


def leg_earned_ending(save=None):
    """Return the exact observed38-step ending body, without a Load prefix.

    No save tail: preserve the original pre-ending UI checkpoint separately.
    Source indicates award alternatives6520..6531 share a continuation hotspot
    and target6560; gameplay exercised6527 and6529. The second award click
    anchors6517 rather than a particular award. The original game owns every
    transition and timer.
    """
    if save is not None:
        raise ValueError("earned-ending has no save tail; use the genuine pre-ending save")
    r = R().at("S3844.CIF", 12000).clicks("331,199", 0)
    r.at("S3903.CIF", 8000).clicks("150,422", 0)
    # Original camera-pan escape window: an ordinary short bottom click.
    r.o.extend(["S3909.CIF+100:move:311,355", "S3909.CIF+200:click:311,355,80",
                "S3909.CIF+12000:shot:0,0"])
    r.at("S3908.CIF", 14000).clicks("150,434", 0)
    r.o.append("S1940.CIF+16000:shot:0,0")
    r.at("S1940.CIF", 18000).clicks("150,434", 0)
    r.o.append("S3912.CIF+15000:shot:0,0")
    r.at("S3912.CIF", 18000).clicks("116,163 318,162", 5000)
    r.at("S3813.CIF", 5000).clicks("314,183", 0)
    # Actual closed post-win board: r7,c3, no banks. Legal N1,N2,W2,W2→r4,c-1.
    for at, x, y in [(6000, 504, 171), (10000, 504, 131),
                     (14000, 416, 224), (18000, 416, 224)]:
        r.o.extend([f"S3940.CIF+{at}:move:{x},{y}",
                    f"S3940.CIF+{at + 100}:click:{x},{y},300",
                    f"S3940.CIF+{at + 3500 if at < 18000 else 36000}:shot:0,0"])
    r.at("S6517.CIF", 2000).clicks("300,200", 0)
    r.o.append("S6517.CIF+8000:shot:0,0")
    r.at("S6517.CIF", 10000).clicks("300,200", 0)
    r.o.extend(["S6562.CIF+18000:shot:0,0", "S6562.CIF+21000:shot:0,0"])
    return r.text()


def earned_ending_input(include_load=True, slot_y=105):
    body = leg_earned_ending()
    return load_save_prefix(slot_y) + ";" + body if include_load else body


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--without-load", action="store_true")
    parser.add_argument("--slot-y", type=int, default=105)
    args = parser.parse_args()
    print(earned_ending_input(not args.without_load, args.slot_y))
