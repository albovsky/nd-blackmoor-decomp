#!/usr/bin/env python3
"""Track M coverage report built on the M02 image composer.

``report_image_coverage.py`` composes the image (or reads a report the composer
already wrote), checks that the report is internally consistent and prints the
single Track M progress number: bytes generated from committed sources
(``structured`` + ``reconstructed``) against bytes still ``referenced`` from the
local original.  Referenced bytes are listed with offset, length and SHA-256 and
are never counted as matched.

Examples::

    report_image_coverage.py                       # compose, print, write build/image/coverage-report.*
    report_image_coverage.py --from-report r.json  # re-print an existing report
    report_image_coverage.py --publish             # also write image/coverage-report.{json,md}
    report_image_coverage.py --baseline old.json   # show the change since an earlier report
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path
from typing import Any, Optional, Iterable

SCRIPT_DIR = Path(__file__).resolve().parent


def load_composer() -> Any:
    path = SCRIPT_DIR / "compose_image.py"
    spec = importlib.util.spec_from_file_location("compose_image", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault("compose_image", module)
    spec.loader.exec_module(module)
    return module


def check_report(report: dict[str, Any]) -> list[str]:
    """Internal-consistency problems of a coverage report (empty when sound)."""
    problems: list[str] = []
    total = report["progress"]["total_bytes"]
    by_class = report["by_class"]
    class_sum = sum(entry["bytes"] for entry in by_class.values())
    if class_sum != total:
        problems.append(f"class totals sum to {class_sum}, image is {total} bytes")
    if by_class["missing"]["bytes"]:
        problems.append(f"{by_class['missing']['bytes']} bytes are missing")
    section_sum = sum(sum(entry.values()) for entry in report["by_section"].values())
    if section_sum != total:
        problems.append(f"section totals sum to {section_sum}, image is {total} bytes")
    listed = report["referenced_ranges"]
    if sum(item["length"] for item in listed["list"]) != listed["bytes"]:
        problems.append("referenced range list does not add up to its byte count")
    if listed["count"] != len(listed["list"]):
        problems.append("referenced range count does not match the list")
    staged = report.get("stage_referenced_bytes", 0)
    if by_class["referenced"]["bytes"] != listed["bytes"] + staged:
        problems.append("referenced class bytes differ from the listed referenced ranges plus staged groups")
    if report["whole_file_hash_match"] != (report["composed_sha256"] == report["original_sha256"]):
        problems.append("whole_file_hash_match disagrees with the recorded hashes")
    return problems


def format_text(report: dict[str, Any], baseline: Optional[dict[str, Any]] = None) -> str:
    progress = report["progress"]
    lines = [
        f"image {progress['total_bytes']:,} bytes  sha256 {report['composed_sha256']}",
        f"whole-file hash match: {report['whole_file_hash_match']}",
        "",
        f"{'class':<15}{'bytes':>12}{'ranges':>9}",
    ]
    for cls in ("structured", "reconstructed", "referenced", "missing"):
        entry = report["by_class"][cls]
        lines.append(f"{cls:<15}{entry['bytes']:>12,}{entry['ranges']:>9,}")
    lines += [
        "",
        f"generated (structured + reconstructed): {progress['generated_bytes']:,} bytes = {progress['generated_fraction'] * 100:.3f}%",
        f"still referenced from the local original (NOT matched): {progress['referenced_bytes']:,} bytes",
        f"code: {progress['code_bytes']:,} bytes; reconstructed {progress['code_bytes_reconstructed']:,}; referenced {progress['code_bytes_referenced']:,}",
        "",
        f"{'code region':<14}{'reconstructed':>15}{'referenced':>14}",
    ]
    for name, entry in report["by_code_region"].items():
        lines.append(f"{name:<14}{entry['reconstructed']:>15,}{entry['referenced']:>14,}")
    lines += ["", f"{'section':<12}{'structured':>12}{'reconstructed':>15}{'referenced':>14}"]
    for name, entry in report["by_section"].items():
        lines.append(f"{name:<12}{entry['structured']:>12,}{entry['reconstructed']:>15,}{entry['referenced']:>14,}")
    if baseline is not None:
        old = baseline["progress"]
        lines += [
            "",
            f"since baseline: generated {progress['generated_bytes'] - old['generated_bytes']:+,} bytes, "
            f"referenced {progress['referenced_bytes'] - old['referenced_bytes']:+,} bytes",
        ]
    return "\n".join(lines) + "\n"


def main(argv: Optional[Iterable[str]] = None) -> int:
    composer = load_composer()
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--original", type=Path, default=composer.DEFAULT_ORIGINAL)
    parser.add_argument("--image-dir", type=Path, default=composer.DEFAULT_IMAGE_DIR)
    parser.add_argument("--build-dir", type=Path, default=composer.DEFAULT_BUILD_DIR)
    parser.add_argument("--assembler", type=Path, default=composer.DEFAULT_ASSEMBLER)
    parser.add_argument("--from-report", type=Path, help="print an existing coverage-report.json instead of composing")
    parser.add_argument("--baseline", type=Path, help="earlier coverage-report.json to compare against")
    parser.add_argument("--publish", action="store_true", help="also write image/coverage-report.json and .md")
    args = parser.parse_args(list(argv) if argv is not None else None)

    if args.from_report:
        report = json.loads(args.from_report.read_text(encoding="utf-8"))
    else:
        try:
            comp = composer.compose(args.image_dir, args.original, args.build_dir, composer.GROUPS, args.assembler)
        except composer.ComposeError as exc:
            print(f"report_image_coverage: {exc}", file=sys.stderr)
            return 2
        report = composer.coverage_report(comp)
        composer.write_json(args.build_dir / "coverage-report.json", report)
        (args.build_dir / "coverage-report.md").write_text(composer.render_markdown(report), encoding="utf-8")
        if args.publish:
            slim = dict(report)
            slim["referenced_ranges"] = {
                "count": report["referenced_ranges"]["count"],
                "bytes": report["referenced_ranges"]["bytes"],
                "list_source": "image/ranges.json",
            }
            composer.write_json(args.image_dir / "coverage-report.json", slim)
            (args.image_dir / "coverage-report.md").write_text(composer.render_markdown(report), encoding="utf-8")

    baseline = json.loads(args.baseline.read_text(encoding="utf-8")) if args.baseline else None
    problems = check_report(report)
    sys.stdout.write(format_text(report, baseline))
    if problems:
        for problem in problems:
            print(f"report_image_coverage: INCONSISTENT: {problem}", file=sys.stderr)
        return 1
    return 0 if report["whole_file_hash_match"] else 1


if __name__ == "__main__":
    sys.exit(main())
