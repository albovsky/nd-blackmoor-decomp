# Local Blackmoor decompilation map

This directory contains a static, offline treemap snapshot and its generator. Open index.html in a local browser. The page makes no network requests and embeds no game assets or executable bytes.

## Refresh

Run:

    python3 outputs/blackmoor-decomp/progress-map/generate.py \
      --project-root /path/to/blackmoor-reconstruction \
      --evidence-root /path/to/blackmoor-reconstruction/work/analysis/slices

The generator reads the function index, selected-range report, validation reports, slice registry, and private claim receipts. It writes only progress-map/snapshot.json and progress-map/index.html. The template is app-template.html. The snapshot records project HEAD separately from each report path and SHA-256; report presence does not prove the report was produced from that source ref.

## Reading the map

The 4,188-entry function index contains starts, not complete body extents. For all but the last start, tile area is proportional to the span ending at the next indexed start. Such spans can include padding, data, or gaps. Internal gaps cannot be quantified from this index. The final indexed start has unknown extent; the map separately reports the trailing .text bytes. Address-unit filters are high-16-bit VA bands derived from addresses, not recovered code modules.

Exported pseudocode remains UNVERIFIED. Dashed report tiles show original-oracle evidence without a current-source file hash binding. Solid orange is reserved for evidence whose native source file and library hashes match the validation report. Purple dashed tiles mark the six S08 complete instruction ranges, all with compiler byte mismatches. Cyan marks two selected exact byte ranges (14 bytes total) inside indexed spans; selected ranges do not establish whole-function matches. No whole-file rebuild or completion percentage is claimed.

The saved action-census count is omitted when its parser hash does not match current parser-source candidates. Packet READY status and claim receipts are displayed separately. The coordination file is shown with its own hash and can lag individual receipts. History controls are disabled because no historical snapshots were supplied.

The snapshot is a review index, not a completion metric. Oracle comparisons are bounded to their recorded cases and boundaries. Refreshing creates a new static snapshot; there is no live polling or fabricated history.
