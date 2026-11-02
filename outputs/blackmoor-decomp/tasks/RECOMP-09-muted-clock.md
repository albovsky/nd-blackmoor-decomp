# RECOMP-09: correct the muted mixer cadence

The silent producer previously rendered441frames, then slept10ms. Work and late wakes accumulated into the sound clock. It now renders the same quantum against fixed steady-clock deadlines. If work misses a deadline, rebase once to finished+10ms; no historical mixes, debt queue or catch-up loop. Guest/movie clocks, capture, audible engine, stop gates and joins are unchanged. Root retains the original chat's implementation/review/squash-merge authority; delegates prepared private candidates only.

Diagnostics collect producer-local timestamps/calls/frames/render/wake/rebase counts, publish once at thread exit and read after join. A single requested capture/log summary follows callback drain and WAV finalization. No producer logging, new lock or guest call is added. Start-to-start rate excludes the immediate first441-frame quantum; raw counters permit independent calculation.

## Acceptance at 2026-11-02, 02:33 Pacific

Instrumentation-only baseline and fixed candidate each ran15-second native background probes in independent data clones, with no output device. Both exit0 through controlled Quit and stay hidden/inactive. Baseline active rate32928.319fps (74.67% of44100); fixed44098.620fps (99.997%), no rebases. Baseline mean render209.7us, mean wake lateness3.184ms: late waking dominates, and fixed deadlines prevent accumulation. Finalized PCM11.21s→15.01s, with44100Hz target and unchanged441-frame blocks. `muted-clock-comparison.json` records independently calculated values.

The fixed candidate also repeats actual New Game/Junior/intro→S2010/view5/held-1. All5steps complete, own stop, exit0, hidden/inactive. Its active rate44098.884fps over193.47s,0rebases;8532468captured frames/193.48s,peak30528,0clipped. Final logical frame SHA `94825bb0eb129aaf50c98247a7b557866997086d9eca97536ed9e14840feb2d0` matches the earlier app opening exactly. External probe elapsed194.80s includes post-run PCM inspection; do not treat it as mixer-active duration. No per-frame audio/video parity is claimed.

One discoverable finite C++ fixture checks regular work, jitter, exact deadlines, shifted epoch and bounded overruns using supplied times. It passes in0.746s (compile included), creates no worker/device/game and never sleeps or faults. Source/native receipts are under `work/muted-clock-tests/`; root log `muted-clock-pacer-root-tests.log`. Existing headless/game/input code is unchanged, so its12-run New Game→m12 evidence remains applicable; it was not rerun for this Mac-only pacing policy.

Private evidence under `work/recomp-playability-20261101/`: `muted-clock-probe-baseline/`, `muted-clock-probe-fixed/`, `muted-clock-fixed-opening/` contain commands, source/native pins, logs, finalized WAVs and frames. Baseline app source is9e07f4f3…; final fixed executable SHA `a47a476b95b58b414f48118560f81d5a5e63a45d73803f5cbdcd522617ddb452`. Original GAME.EXE remains afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. All source data/executable pins remain unchanged during probes.

## Limits and review

Overruns and suspend/resume can still lose audio wall-time alignment; the policy deliberately does not reconstruct historical Play/Stop state. Sustained over-budget work, fallback/hardware callbacks, synchronization and media parity are unverified. No actual stall/fault or audible test was introduced. Synthetic overrun cases test only the pure scheduling helper. Probe wall times include Python inspection; use the producer counters for rate claims. Independent Sonnet review is pending against the frozen final candidate.

Registered test inputs are regenerated in a clean checkout, excluding parked files. Every function status/class/count and native lifter field matches the parent (`muted-clock-refresh-receipt.json`); no new port acceptance. Parallel story evidence continues privately beyond publicm12 through Moon columnm17/Nigel computerm18; those routes are queued separately and are not this clock slice's reviewed gameplay claim. Full campaigns and final native credits remain incomplete.

## Source pins

- `recomp/macos_recomp.mm`: `99753f84496a64ffd822aad2b794d74ccfe92663768823364fde6d61471d6441`
- `recomp/muted_audio_pacer.h`: `cbcd00eb1d1e5b5e0b34b066f9f26ab890fd3de0a6aa7235c03efe37891c25fd`
- `tests/muted_audio_pacer_fixture.cpp`: `9ab9add96aa0140e8c7ac73d0ac72f25563236d08af238c7ba99f61e91f9297b`
- `tests/test_muted_audio_pacer.py`: `e38edf685b18d4654e6b0f4e46c7175f0410ff2a93085dc162ff3adab94ba830`

Independent Sonnet high review accepts frozen684dee5b with no P1 or blocking P2 (`muted-clock-review.txt`). Static evidence and ledger freshness checks pass. The measured99.997% ratio is an endpoint-jitter measurement with0rebases, not evidence of residual long-term drift or guaranteed headroom. Future long runs must record rebases; actual overruns remain outside this runtime proof. `muted-clock-shared-object-pins.json` pins the current24shared lifted objects, all predating the baseline link; no headless/core rebuild was claimed. Post-review changes clarify evidence only.
