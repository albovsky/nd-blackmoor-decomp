# Earned story evidence

These manifests contain hashes, scene/flag observations and lineage metadata. Private game data, saves, framebuffer images and audio are not committed.

- `junior-earned-story.json` preserves the historical76-checkpoint Junior New Game→earned-credits chain. Its build boundary is f8→cc7.
- `senior-earned-story.json` projects the historical84-checkpoint Senior chain and its fresh reloads from the pinned full private audit. Its boundaries are660→0c→cc7.
- `current-earned-endings.json` records two new ending-only replays on reviewed native b49, starting with genuine Junior m77 and Senior s85 UI saves. Both consume all45 ordinary input events, reach earned story credits and stop normally. Root inspected two different scrolling-credit captures for each difficulty.

The historical manifests are snapshots. Their optional-game descriptions and unverified current-build fields describe that evidence, rather than the latest overall project state. New Memory/Cake results are separate branches, not edits to historical campaigns. Artifact equality across builds does not prove equivalent host behavior; these files retain actual build transitions and missing historical fields.

`../route_tools/earned_ending_route.py` generates the exact common ending input. It uses real key15, the short S3909 escape, the observed post-win Aeolus walk and the original award/teaser continuation. It never chooses menu Credits or writes a save. Run it with the only incoming save in the original Load list, or pass `--slot-y` for its observed list row.

Both whole-story native campaigns and both reviewed-b49 ending replays are evidenced. A single-current-build full campaign, all optional/retry variants and final background Mac app acceptance remain unproved. These manifests do not mark the game complete.
