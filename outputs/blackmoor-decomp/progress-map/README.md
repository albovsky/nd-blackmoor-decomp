# Local Blackmoor decompilation map

This directory contains a generated, static, offline treemap. Open `index.html` in a local browser. The page makes no network requests and embeds no game assets, executable bytes, or generated resource dumps.

## Refresh

The accepted S08-2 and S08-3 objects are supplied from their source worktrees. Pass each current object and its report-binding root explicitly:

    python3 outputs/blackmoor-decomp/progress-map/generate.py \
      --project-root /path/to/blackmoor-reconstruction \
      --evidence-root /path/to/blackmoor-reconstruction/work/analysis/slices \
      --artifact-root /path/to/output-project \
      --assembly-object /path/to/s08-2-worktree/outputs/blackmoor-decomp/build/matching_s08_2_x86.obj \
      --assembly-binding-root /path/to/s08-2-report-binding-root \
      --s08-3-report /path/to/blackmoor-reconstruction/work/analysis/slices/S08-3-x86-report.json \
      --s08-3-object /path/to/s08-3-worktree/outputs/blackmoor-decomp/build/matching_s08_3_x86.obj \
      --s08-3-binding-root /path/to/s08-3-report-binding-root

Each family has its own schema validator. It checks the accepted report digest, original image, current reviewed source, manifest, assembler and supplied object, fresh-reassembly association, aggregate and per-function rows, indexed extent bounds, and the effective supplied-object manifest digest. A stale, alternate, equivalent-but-unreviewed, or mismatched source/object association is quarantined and contributes zero exact bytes.

## Reading the map

The 4,188-entry function index contains starts, not complete body extents. Most tile areas are estimated spans to the next indexed start and may include padding, data, or gaps. Internal gaps cannot be measured from this index. The final indexed start has unknown extent. Address-unit filters are high-16-bit VA bands, not recovered code modules. The map reports no decompilation percentage or whole-game completion.

The current pinned evidence selects nine complete x86 assembly functions / 288 bytes across the accepted S08-2 and S08-3 families. Two earlier selected ranges contribute 14 more bytes, but remain partial with unverified function completeness. That yields 302 unique exact bytes across 11 selected extents, grouped into five adjacent-address runs. The solid teal status identifies complete functions matched from reviewed, reconstructed mnemonic assembly; it does not establish original C or compiler provenance. The whole-executable rebuild remains incomplete.

C and C++ compiler-generated candidates remain separate mismatch evidence: six C functions have 62 differing byte offsets and six C++ functions have 66. The assembly matches do not promote those candidates. Bounded native original-oracle comparisons use separate filters and inspector sections. Exported pseudocode remains UNVERIFIED.

This view adapts a selected oracle-report subset only. S01, S02, A28, A51, coreCIF, HIFF, and pixels reports are omitted from those oracle metrics. The omission panel lists the selected adapters. Assembly-match families are separately pinned and included in the exact-byte map.

The snapshot records the source HEAD and each report, source, manifest, object, and assembler digest, including the effective supplied-object manifest binding. If the canonical `matching-report.json` contains build-root metadata that differs from the output checkout, the generator keeps an exact, size-bounded metadata copy under `evidence/` so its link still resolves after collection and its SHA-256 still matches the recorded source. Report links resolve to their pinned evidence; object or resource bytes are never copied here. Current-source reproducibility does not establish historical provenance.

The action-census count is omitted when its parser hash does not match current parser sources. Packet readiness and claim receipts are displayed separately. The coordination table may lag newer receipts. There is no live polling or generated history.
