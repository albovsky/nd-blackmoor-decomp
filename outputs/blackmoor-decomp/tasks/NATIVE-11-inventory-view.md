# NATIVE-11: render the native inventory and close control

## Authorization and ownership

The original human in this /root chat authorized native ARM64 macOS playability, real-data room navigation, focused tests, one reviewed PR per slice then merge. Latest direct request: "Keep going with room navigation beyond S3397 and fix the next blocker. Keep the game muted and avoid the tests that caused crash popups." This original chat alone publishes; delegates prepare tests/research only. Base main09da79c23f0d9793fc8371c72b55800cc36317e1. Root owns shared app, new compositor and build inventory. Tests-only worker40a2ad95f637b9b7768adbd11619bd6a3e88d929 collected as1474bb51; read-only static researcher supplied geometry/asset/control anchors.

Original game files/GAME.EXE/game-source and reserved function ledger/evidence/extract/build outputs, tests/fl40_* and tasks/flNN-handoff.md remain unchanged. Persistent game mute1; other Mac sound settings unchanged. No broad discovery, sanitizer/mutation/Unicorn/original-x86/deliberate-fault/output-device tests. Focused normal checks use CHECK/exit1 and signal handlers. GUI tool last reports locked despite owner confirmation; no repeated unlock prompt or new GUI claim.

## Reproduction and resulting behavior

The real post-piano route collects item17 inS3398 using actual0x62/0x78 and walks3380->3381..3391->3307 (55distinct scenes). The hall and bedroom door route3308->3340->3341 also works (58distinct). Jane's door remains closed under actual story gates, not assumed a port defect. The nearbyS3448 lock route opens inventory and selects the genuinely owned key through ordinary input, but the app explicitly logged view NOT RENDERED: a GUI player saw no panel or item.

The slice supplies a preflighted opaque draw plan in native_inventory_render.[ch] and composes it after caption-to-RGBA in the normal app update. It uses original BOOT assets, frame, close/slider artwork, tabs/title and16 item/empty-slot crops. Existing item hover/pick/put logic is unchanged. Supported view is state3, mode2/3, tab100/page0. Invalid mode/item/rectangles return an explicit composition failure before any inventory draw. There are no invented inventory labels or assets. Logical input remains640x480; existing fit/stretch window mapping is untouched.

The stock X is usable with native system-cursor coordinates. One owned DOWN/UP queues a close; next update prepares/plays the actual click01 descriptor, draws pressed art, then waits for strict now>deadline and real channel idle before inventory_view_close. No sound unload is invented. The timer and sound gate follow original button completion; producer ownership and hitting the drawn rectangle with the native OS hot point are explicit HOST policies, not a recovered original message-map claim. Adding the offset of an undrawn legacy cursor made lower/right X pixels unclickable; a focused ordinary RED caught that, then the native hit region was corrected. Existing item hit testing retains its recovered CURS projection. Once close is accepted, moving outside does not cancel completion. The view/list/held item are not changed by X close.

## Original metadata and anchors

Read-only research: work/analysis/NATIVE-11-inventory-render-research.md. Original draw0x4e97ad invokes popup0x4ee86f (frame/close/slider), enabled panels and selected title, then16slots. Transfers are inclusive opaque0x4c5377. No fresh original-x86 or REA execution/decoder/DirectDraw/full-frame parity is claimed.

- UIIV length2860, frame nameUIInventory_OVL (548x377 RGB555); src+0x27=(1,1,375,375), dst+0x47=(0,0,374,374), relative+0x67=1. With VIEWorigin10,10:375x375 at10,10..384,384.
- INV length25727, item sheet name at+2:TOOL (379x1465 RGB555). Records+0xb1+0x16d*item; normal/lit sources+0x36/+0x46. Item17Slider_Key: normal127,306..188,365; lit316,306..377,365. Slot0 from existinglayout27,74..88,133 (62x60). Empty sourceUIIV+0x2f0+16*slot; slot0=18,65..79,124. Existing slot_lit selects exact original crop.
- Close configUIIV+0x137, enabled+0x133. Destination356,16..375,34 is absolute. Artstates0normal441,93..460,111;1hover462,93..481,111;2pressed483,93..502,111. Original0x4e8dc8 first calls popup0x4ee517; button0x4e26fc starts pending close,0x4e29ec waits strict timer and sound idle;0x4ee6c7/0x4e94c1 complete then0x4e7d04 resets mode/tab/screen. Downstream timer200ms and49-byte descriptorUIIV+0x1f5:click01/channel3/flags2/loop1/control1/gains100,100. Native uses existing PuzzleSound/live_audio; authoritative loaded state is refreshed before busy.
- Slider config+0x22a: restore source302,48..316,336 ->track301,47..315,335 plusorigin; normal thumb377,93..391,116 goes at tracktop, page0. Slider transparency is+0xbe, unlike buttons+0xb2; the first candidate refused this valid layout until that field offset was corrected.
- Panels+0x4f2+0xf7*i: enabled+0, id+4, buttonconfig+8. Active IDs100/101/102; selected100 artstate0, unselected101/102 kind1 artstate2. Selected titleUIIV+0xabc ->+0xb1c is absolute80,20..249,41, with no origin addition. Title is emitted inside its panel loop in original order.

Original GAME.EXE1511424B SHA-256 afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Seven bounded original windows match annotated-source hashes (researcher verified against immutable bytes):

| Window | SHA-256 |
|---|---|
|4e97ad..4e9a2c|2c8b55f948f0ad2718589666c4b4339238d88634033f532cf0d52ec2d3b1c4fe|
|4ee86f..4ee943|6ecd8ef12223fbacdb4100f7e8f979c211ac70f584f48248c05020083f940dbc|
|4e8622..4e8994|47f48692cdc43abe891bc97857dcc63000337a0d01c9d8a26b8c60b8dcc9f5cc|
|4c5377..4c558b|c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b|
|4e1db3..4e204a|75576e41cf1200fbf5e75c6bab77167727d177b37eb44afd2d1abbcd1ec976f2|
|4e2b99..4e2ca8|8be99cbae32911990edbc59a14bfa2b5c880fafa242362a40bc78a8343285f7b|
|4eff03..4effcb|eb7b42525c1d74365548ec17d20837f7d9de743de4acee284e401f96a7a00bac|

BOOT bytes SHA-256167ca6479ac93f5e4465557549d663c46a1ad48cf376ca81a4e6e6248191f6ac; click01 file SHA-25659dc138f9f05ba7adb2935a48007fe39096d4b7c587cebf101d924c71f734508. No original payloads are committed.

## Validation

- Final baseline open RED against09da79c2: ordinary CHECKexit1,15.751s; real BOOT/newgame and actualS3398 AddInventory78 payload owns17; icon3670/3720 and frame1111/1111 mismatches. Local inventory-view-worker-red.log (copied from worker scratch) records it. The corrected exact expected RGBA uses the existing HostImage CIF bit-replication adapter, not caption floor scaling; no tolerance threshold was introduced.
- Worker4checks pass16.287s; root collected4 pass16.199s. New native-X full-visible-region RED fails normally16.881s, then final root4/4 pass21.392s in inventory-view-tests-final.log. Checks cover exact original frame/item/lit/empty pixels, real pick/close restoring scene, close/reopen at200vs201ms, realclick01 busy beyond deadline then natural completion with8192finite zero-output PCMframes, unchanged model/no leaked release, invalidmode4/item70 preflight with fresh base and explicit failure. Components use actual BOOT/newgame/resources/real78 payload, unrelated scene actions pending; they are not a full story playthrough.
- Four narrow existing D1/IV/taskbar checks pass72.082s (inventory-view-regressions.log); they predate only the active-inventory close-hit correction. No affected non-inventory branch changed afterward.
- Normal ARM64 final build passes (inventory-view-final-build.log). App SHA-2567267a1bc90465d5e9e60569ca088035f86e55a4e7f1face986045913fc4922b9; native8c275b7e0480cf01df026dcd006f40c7ec5bcab7d27f3101b24ae6c531b63607. Plan C SHA-2563ac54228cfdbf972fdf1dd1924655d905ccd2b66f25446a666e901ffcd83ffeb; header168b42d4117dcb6fb03ee65d0106cc07f5e14ca8c0b46df927ece536cc1f8c2e.
- Final active-worktree normal route in inventory-view-route-verified.log: actual piano solve/key pickup/hall/Jane-lock path,56distinct scenes/59entries,25 inventory blits, hover17, real owned-slot selection held17, endS3448status0/exit0. No world/flag/phase/inventory/candidate/target injection. --live-pick-item searches the already-owned slot and calls MOVE/DOWN/UP; it does not add items. Auto-review initially misclassified that flag; original source and actual pickup evidence were recovered and supported retry approved. No remaining approval issue. Earlier candidate-labelled inventory-view-route-green.log used canonical old binary because work is a symlink; it is BASELINE evidence, superseded by the final verified active-worktree run.
- Private offscreen framebuffer inventory-open-offscreen.png,640x480,SHA-256f0ebaa25f7bbe9775a58bf2f9069d73ca736ab8029290c781ace88de3776e94c shows the original panel/key. It is a component render, NOT a desktop GUI capture. No image/resource bytes are committed.
- Mute preference1 verified, no output device. Historical full suite remains notgreen and was not rerun because the owner prohibits crash-producing paths. Root diff/whitespace review and independent frozen Sonnet review are required before publication.

## Remaining limits

Tab100/page0 only: derived tabs, paging/slider input, keyboard arrows and original open/close fades remain unmodeled; rendered other-tab art does not claim those interactions. Existing item pickup still uses the earlier app DOWN-based receiver (original release handling not reconstructed here). Original cursor sprites, complete popup/event producer parity, caption/taskbar/exit-effect layer ordering, forced scene changes while inventory is open/closing, real wall-clock/speaker listening and full-frame original parity are unverified. Late RGBA composition and native X producer are explicit host policies. No new whole-game, ledger, original-code counterpart or whole-file claim. Further lock use/progression afterS3448 and both campaigns remain unfinished. Frozen independent review/publication pending.

Before frozen review, integrated concurrent mainf0725f795c52be13e626b098cd8e9dd5411ba9a0. It changed no src file or native build script; the verified native tree and inventory tests remain unchanged. Those ledger/decompilation updates belong to the other agent and are not changes made by this slice.
