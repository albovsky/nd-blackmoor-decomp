# RECOMP-15: cached widescreen renderer checks

Extend the existing opt-in hidden AppKit fixture to check the production view's rendered pixels in proportional (`fit`) and stretched modes. The owner requested both modes. This is a test slice; production rendering, input, game logic and display preferences are unchanged. Root retains integration/review/publication under the original pasted request; delegates prepared private test candidates and compile evidence only.

## Acceptance, 2026-11-02 06:37 Pacific

The actual public-path `BLACKMOOR_BACKGROUND_UI_TEST=1 python3 outputs/blackmoor-decomp/tests/test_recomp_background_platform.py -v` passes: one test, two separate normal exit0 fixture runs, 2.261s. Each mode keeps all10 direct hidden-view pointer callbacks,4ticks/5presentations and zero observed activation/key/visibility, and adds one actual `cacheDisplayInRect:` render with8 independently specified interior pixel checks. This Mac's measured960x480 logical view has1920x960 backing pixels (2x); sampling uses measured backing dimensions. The fixed red/green/blue/white quadrants distinguish fit's black side bars from stretch. Alpha is checked, with unchanged2/255 component tolerance.

Private root output: `work/background-platform-test-results/native-9flj6hlb/receipt.json`, `run-fit.log`, `run-stretch.log`; wrapper log: `work/recomp-playability-20261101/widescreen-render-public-root-tests.log`. Both production input hashes match before/after. Native fixture SHA256 `0de80964e014e360d97c5da003b14a74659264e0446dd10bf22feffb9ebde1ed`. The earlier private corrected candidate also passes both modes (`native-73qup49m`); no game or audio execution is needed for this renderer-only fixture.

## Test-oracle diagnosis

The initial private pixel assertion failed normally in both modes, while geometry/bars were correct. It interpreted `NSBitmapImageRep colorAtX:y:` components tagged GenericRGB as if they described the actual ColorLCD cache. Root's guarded diagnostic establishes that production already tags its source CGImage named sRGB; independent known/source sRGB controls pass. The cache is tagged ColorLCD (4076-byte ICC), whereas `colorAtX:y:` returned the same components under GenericRGB (1992-byte ICC). Proper tagged CGImage interpretation recovers red/blue correctly; a second round trip back to sRGB introduces green quantization of3/255. Evidence is retained in `widescreen-color-root-probe/`, including normal exit1 logs; these are assertion failures, not crashes.

The collected oracle preserves the cache's actual RGB8 profile. It compares actual samples against independent literal sRGB reference colors transformed once into that profile at the same8-bit precision. It neither retags observed data nor widens tolerance, and keeps all8 fixed positions/colors/opaque checks. Unsupported cache formats fail normally. No production color-management change is warranted. `widescreen-render-candidate/profile-corrected/sampler-correction.diff` preserves the minimal oracle correction separately from the complete candidate patch.

## Source pins and remaining verification

- `tests/recomp_background_platform_fixture.mm`: `b077b09aa80ae38b845dad38c8751389f44c979b9cf839c60de4f183f2302477`
- `tests/test_recomp_background_platform.py`: `96c11797857df7f33f5866df08ea60077bf759c9ef2761b1f394120322e65411`
- unchanged `src/macos_platform.mm`: `8d0d38127bb460f6ffb4a65461f5f0d6a1c989d85db25f8e670229c986422caf`
- unchanged `src/native_display_geometry.c`: `09e67a37f976d8c436e3598051dd2aec5062178b39a164446f7df6b41fadc28d`

Original GAME.EXE remains `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`; no original/resource data is used or changed by these synthetic fixtures. Current reviewed game app remains `cbb2ef85b3953d8d41b9796c290426b4ea5b1a250e5d65833ca1ddd81511d51c`, and headless `cc7ce16f33aee31714b8d8586adeffcc6e2036e58f6522394626ed6f2e0eed56`; neither is rebuilt by this test-only change.

This proves cached own-view rendering and direct view input only. Physical input, WindowServer composition/displayed-window pixels, HDR/other cache bit depths, other display profiles and actual game frames at varied window sizes remain unverified. Only this Mac's measured2x backing was exercised. It adds no function-port acceptance or full-campaign claim. Broad/fault/crash-producing suites are excluded under the owner's restriction. Required registered-test metadata refresh and frozen independent Sonnet high review remain pending collection.
