# Claude next task: S03-1 AVF decoder

Move to [S03-1: original AVF container and frame decoder](tasks/S03-1-avf-decoder.md). Recover the game's own AVF decompression and delta algorithms into portable C, and compare every frame of all 32 installed AVF files with the original x86 decoder.

Use a separate worktree and claim; own only the new decoder, its tests/build script and S03-1 evidence. Boot owns shared app/parser/executor integration. Root reviews and collects. Record your completed caption commit/handoff before switching; its review proceeds independently. Playback timing and engine wiring are the next child, S03-2.

Return a committed decoder, original/native comparison counts, pinned hashes, malformed-input/sanitizer results, explicit unsupported branches and an integration proposal. Read the full packet before implementation.
