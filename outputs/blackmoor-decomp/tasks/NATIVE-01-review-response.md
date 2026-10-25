# NATIVE-01 review response

Independent slice-reviewer reviewed frozen 2caa5a65 against b4cbef99. No P1 defects. ASan/UBSan random descriptor validation was clean (2 million records/lengths), and the reviewer verified offsets, independent gain clamps and category table against immutable original bytes. Private review: work/playability-20261024/independent-review.txt.

P2.1 accepted. The extended native app fixture now creates a real SessionAd1Binding for every original D1 scene and solves/exits every row with the actual app audio callbacks, advancing offline audio between visits. All11 solve paths and11 exit paths complete; win sound yields38–39 waiting ticks before phase2; completion unloads record0, and WIN_SOUND unloads record1. Only render handles, inventory and transition/event sinks are fixture host boundaries. The existing D1 x86 oracle separately validates the kernel's ordered effects.

P2.2 accepted as a reporting gap. PLAYABILITY-LOG now records exact commands, normal/test-hook binary hashes, immutable original hash, named baseline build failures and unverified branches. Canonical rebuild was attempted; full discovery is running after the independent build audit. No passing full-suite claim. Final results will be recorded before publication.

P2.3 policy retained deliberately: NO_RESOURCE is a silent absence, while malformed/unsupported descriptors and backend errors are explicit failures. This is the packet's required failure contract, consistent with native conversation sound handling and the project rule against silently completing unsupported paths. The final glue test injects load/unload/busy backend failures, checks the app returns an error and preserves a failed busy query's caller output. No original host-failure parity is claimed.

P3 limits recorded: PCM overshoot, hardware audibility/completion/suspension and GUI D1 input. Backend is created once and outlives the binding; any future backend recreation must reset the cached adapter.

Final P3 test details: each named win clip must be observed busy on its own solve path; counters are actual successful solve/exit counts; all lifecycle PCM stats reject nonfinite samples. Exit explicitly verifies the win clip stays prepared/unstarted, and the subsequent manual unload is labeled test isolation with channels derived from the body. Play-backend error propagation is also injected and checked. Native callbacks and adapter production code are unchanged from both independent reviews.
