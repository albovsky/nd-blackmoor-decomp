#!/usr/bin/env python3
"""Alias for audit_port_candidates.py (same options); kept under the name FL-6 notes use."""

import runpy
from pathlib import Path

if __name__ == "__main__":
    runpy.run_path(str(Path(__file__).with_name("audit_port_candidates.py")), run_name="__main__")
