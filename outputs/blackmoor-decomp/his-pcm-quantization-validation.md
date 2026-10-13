# HIS float-to-PCM quantization recovery

The recovered boundary is the original GAME.EXE routine at VA `0x004fe2d0` (file offset `0x000fe2d0`, 862 bytes through the `ret` at `0x004fe62d`). The source executable is `work/original/GAME.EXE`, SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.

The production caller at `0x004f5b50` chooses one byte/sample and `param6=0` for an 8-bit HIS stream, or two bytes/sample and `param6=1` for a 16-bit HIS stream; both pass `param4=0`. The converter's 8-bit loop loads planar floats, multiplies by the float constant at `0x0052e580` (`128.0f`), converts with x87 `FISTP`, clamps the signed integer to `[-128,127]`, adds 128, and writes unsigned offset-binary bytes. The 16-bit production branch multiplies by the float constant at `0x0052e57c` (`32768.0f`), uses `FISTP`, clamps to `[-32768,32767]`, then writes signed words in x86 little-endian order. Both branches produce frame-interleaved samples: the 8-bit loop visits channels inside each frame; the signed 16-bit loop advances each channel's output address by `channels * 2` bytes per sample. The original loops use the reported channel count; the isolated native API is bounded to mono/stereo for the host adapter. Other branches in `0x4fe2d0` (such as unsigned 16-bit, signed 8-bit, or byte-swapped output modes) are outside this production caller path and are not represented by the C API.

`FISTP` obeys the current x87 rounding-control bits. With control word `0x037f` (round-to-nearest-even, exceptions masked), positive and negative halfway cases in both bit depths match ties-to-even. The converter itself does not change the x87 control word. The oracle explicitly initializes it to `0x037f`, so the tie behavior is established for that mode; this check does not prove which mode every possible caller leaves active at runtime.

Masked x87 invalid conversion stores the integer-indefinite value `INT32_MIN`; the routine's following clamp therefore maps NaN, infinities, and scaled values outside the signed 32-bit conversion range to the PCM minimum. This includes positive overflow: for example, `65536.0f * 32768.0f` is beyond `INT32_MAX`, so the 16-bit result is `-32768`, rather than ordinary positive saturation to `32767`. The native C function reproduces this distinction under the tested control word.

The portable implementation is isolated in `outputs/blackmoor-decomp/src/his_pcm_quantize.[ch]`; it does not call FFmpeg and does not claim Ogg/Vorbis decoding parity. It accepts one planar float array per channel, supports mono or stereo 8-bit unsigned and 16-bit signed PCM, interleaves by frame, and writes only the largest whole-frame prefix that fits the caller's output buffer.

## Original-machine-code comparison

`tests/his_pcm_quantize_original_oracle.py` maps the hash-verified PE image and executes the original routine body at `0x004fe2d0` in Unicorn. It stubs only three inputs outside the conversion boundary: the planar-queue read at `0x004ff9a0`, the channel-metadata lookup at `0x004fe290`, and the queue-consume call at `0x004ffa00`. The oracle injects synthetic binary32 planar samples, then compares the returned byte count and every output byte with the native C function. It does not execute the Vorbis decoder or establish decoder/codec equivalence.

All eight oracle cases matched byte for byte. The cases cover mono/stereo, frame interleaving, 8-bit offset-binary and signed 16-bit little-endian output, both signs of halfway ties, clipping extrema, NaN/infinities, signed-32 conversion boundaries, and capacity truncation at a whole-frame boundary. Machine-readable hashes and per-case outcomes are in `work/analysis/his-pcm-quantization-validation.json`.

The native tests pass with:

```sh
outputs/blackmoor-decomp/scripts/build_his_pcm_quantize.sh
python3 outputs/blackmoor-decomp/tests/test_his_pcm_quantize.py
work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/his_pcm_quantize_original_oracle.py --json work/analysis/his-pcm-quantization-validation.json
```

In this host environment the Unicorn command must run outside the workspace sandbox: the sandboxed process exits with SIGILL before emulation starts. The scoped run is local and read-only with respect to `GAME.EXE`; it writes only the evidence JSON.
