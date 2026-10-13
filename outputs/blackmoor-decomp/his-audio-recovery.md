# HIS audio recovery and native PCM adapter

The source game directory is recorded in `work/analysis/game-source.json`. Its `CDSound` folder contains 2,509 `.HIS` files totaling 103,775,676 bytes. A read-only corpus scan found that all files have the `HIS\0` signature, a version-2 header, and a payload starting at byte 30. Of these, 2,406 use header marker 2 and start with `OggS`; 103 use marker 1 and contain raw PCM. The full format counts and example names are in `his-audio-recovery.json`.

For this corpus, the 30-byte wrapper fields observed are: version at offset 4, a fixed value 1 at offset 8, channel count at offset 10, sample rate at 12, average bytes per second at 16, bytes per frame at 20, sample-depth metadata at 22, declared decoded PCM byte count at 24, and payload marker at 28. The header identifies 8-bit or 16-bit PCM output. Every raw PCM file's declared byte count equals its payload length. The marker-2 files have `OggS` at byte 30 and include mono/stereo Vorbis. Four Ogg files carry legacy 8-bit output metadata, so the marker and actual Ogg stream must be read together; this adapter checks the decoded Vorbis stream's rate and channel count and uses the header's declared frame count.

## Original executable boundary

`GAME.EXE` is PE32 x86. Its imports list `DSOUND.dll` and `binkw32.dll`, among other platform libraries, but no Ogg or Vorbis DLL. The shipped executable also contains Ogg/Vorbis strings and codec routines, so the original HIS path is not an external Vorbis DLL call.

The Ghidra pseudocode recovered from the shipped executable shows this path:

- `0x4fc341` opens a sound channel, calls `0x4fc62d`, and then calls `0x4fb2e3` for playback. `0x4fc62d` reaches `0x4fadc4` for a requested file load.
- `0x4f379c` opens the sound file and reads a 0x1e-byte header. It checks the HIS signature, version, decoded byte count, and marker. It chooses the in-memory path at `0x4f3c26` for decoded sizes below `0x56221`, otherwise the streaming path at `0x4f438f`.
- Both paths create a DirectSound buffer and call `0x4fdb90` for marker-2 Ogg content. The in-image codec path continues through `0x4fcff0` / `0x4fd040`; `0x4fe870` recognizes `vorbis` packets and `0x4fe2d0` converts decoded floats to 8- or 16-bit PCM.

These findings are based on the unverified decompiler listings in `outputs/blackmoor-decomp/unverified-pseudocode/4fc341.c.txt`, `4fc62d.c.txt`, `4f379c.c.txt`, `4f3c26.c.txt`, `4f438f.c.txt`, `4fdb90.c.txt`, `4fe870.c.txt`, and `4fe2d0.c.txt`, plus the PE import table. Those listings are analysis evidence, not source code. The boundary is therefore clear: the original engine owns HIS channel/loading behavior, internal Vorbis decode, and DirectSound buffers; Bink video uses the separately imported Bink DLL.

## Native host adapter

`src/his_audio.[ch]` exposes a local-file API and an in-memory API. Marker-1 payloads are already decoded PCM and are normalized directly to interleaved `float`; marker-2 payloads go through FFmpeg's in-process `libavformat`, `libavcodec`, and `libswresample` APIs. Ogg bytes are presented through a bounded custom memory AVIO reader, so FFmpeg receives only the HIS payload and cannot open a URL. The adapter caps input at 256 MiB, float output at 512 MiB, channels at two, and sample rate at 192 kHz. On success, `HisAudio` owns `interleaved_pcm`; `his_audio_destroy` releases it.

The wrapper's decoded-byte count determines the output frame count. The decoder trims extra Vorbis packet padding to that count and fails if the stream ends early. The raw PCM path also requires the payload length to match the declared byte count. `scripts/build_his_audio.sh` builds an ARM64 dylib and links the installed FFmpeg 9.0.1 libraries. This local build has a macOS 27 deployment target and links the Homebrew dylibs under `/opt/homebrew`; dependency packaging remains host-specific.

## Validation and limits

`python3 outputs/blackmoor-decomp/tests/test_his_audio.py` passed all three test methods. The suite compares the adapter's interleaved float PCM exactly with FFmpeg CLI output after extracting the Ogg payload, then checks raw 8-bit and 16-bit PCM samples and malformed versions, lengths, and signatures.

The Ogg CLI comparisons covered `Ndsig.his` (44.1 kHz mono, 2,780,558 frames), `NSHT01.his` (44.1 kHz mono, 494,792 frames), `Pot02.HIS` (44.1 kHz stereo, 11,869 frames), and `Icant.his` (22.05 kHz mono with 8-bit header metadata, 23,918 frames). Their adapter output SHA-256 values are recorded in the JSON evidence. Raw PCM checks covered `CardFlip05.HIS` (16-bit) and `ComputerGameBeep01.HIS` (8-bit).

These comparisons show agreement with this installed FFmpeg build, not byte equivalence with the executable's original Vorbis implementation. The native app's `--inspect-audio` diagnostic now decodes the actual S0 music and renders 4,096 frames through an offline AVAudioEngine graph at diagnostic unity gain. Gameplay playback and the original DirectSound channel controls remain unimplemented.
