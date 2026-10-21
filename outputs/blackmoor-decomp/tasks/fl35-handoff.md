# FL-35 handoff (batches `fl35a` and `fl35b`)

Cloud thread, 2026-10-21 PDT. Branch `claude/project-thread-0nrqkz`. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only). Implementer and reviewer: Claude Sonnet (one diff review of commit `1e11fbd3`, no P1/P2; its P3 documentation items were fixed). Ledger entries: `tasks/fl35a-acceptances.json` (28) and `tasks/fl35b-acceptances.json` (36), appended to `function-ledger-overrides.json`.

## Ported (64 of 64)

Batch a, `src/original_methods_fl35a.c/.h`, world `Fl35aWorld` (the thirty words 0x5ec2d6..0x5ec310): the 28 tag readers 0x40a5c1..0x40af0b (span 82) that FL-32 batch b did not take. Batch b, `src/original_methods_fl35b.c/.h`, world `Fl35bWorld` (the thirty-six words 0x5ec28c..0x5ec2d2): the toggle 0x4080fc (span 50) and the 35 text readers 0x40812e..0x408904 (span 59). One exported symbol `m<va>_<name>` per row, citing its own address, over one static shared body per batch; the three (batch a) or two (batch b) constants of every row (string field offset, tag address, stored word address) were parsed from that row's own disassembly by the generator, which also asserted that all rows of a batch have the identical masked instruction stream and end with a plain `ret` at their span. Every row: 0x51d5b2(this = self + field, buf, 0x13), [batch a only: compare 4 bytes of the buffer with the tag at a fixed original address], low 16 bits of 0x50cb1b(buf) stored in the row's word (batch a: only when the tags differ), return eax of the last callee (0x4090ab for batch a, 0x407ca7 for batch b). 0x4080fc: signed 16-bit read of 0x5ec28c, non-zero becomes 0, zero becomes 1, then 0x407ca7(this).

Oracle (`python3 tests/fl35a_original_oracle.py`, `fl35b_original_oracle.py`; original bytes only under Unicorn, hooks are recording stubs at the call boundary): every instruction of every row executed and both directions of every conditional jump taken (batch a: 30/30 instructions, the one `je` both ways; 0x4080fc: 15/15, its `je` both ways; the 35 readers: 20/20 and no conditional jump), so there is no untaken-edge allowlist and nothing to flag for the owner. None of the rows has an unreachable block. Ledger window for each acceptance is [va, va+span].

| va | symbol | instructions | branch directions | scenarios | oracle digest (sha256) |
|---|---|---|---|---|---|
| 0x40a5c1 | m40a5c1_read_tag_word | 30/30 | 2/2 | 102 | 257ad1f1694dbc2f65840e308d32dd91f4a70ed3367abd4a9ee0f79e16a23e7c |
| 0x40a6b7 | m40a6b7_read_tag_word | 30/30 | 2/2 | 102 | 109c0b2e6a76f1fe6c284610fbdfac2788dfe9e4d0f530d57b7741e28a76a6e9 |
| 0x40a709 | m40a709_read_tag_word | 30/30 | 2/2 | 102 | 5d8d2891d406f88b88fe50a4ed3b1cc604f4b0db2413a4fb6421bec4ab84c40b |
| 0x40a75b | m40a75b_read_tag_word | 30/30 | 2/2 | 102 | 7f5ddb6e39b345286c14fd2dd8efec9d2bc79c103bdb4b1776067f77d404474b |
| 0x40a7ad | m40a7ad_read_tag_word | 30/30 | 2/2 | 102 | 849b5930a48169fe7919bfea56cfd4a8840336bfeba74d71f2ae45d8962e27a0 |
| 0x40a7ff | m40a7ff_read_tag_word | 30/30 | 2/2 | 102 | af117ad99cbdc50e6cc63d026c3613f13d540872d3df9f2068225fd6b3c90abe |
| 0x40a851 | m40a851_read_tag_word | 30/30 | 2/2 | 102 | a1bb297ca73907896d4a725c3ada0661c66e0818478cc9fe63cb66e5143e0a65 |
| 0x40a8a3 | m40a8a3_read_tag_word | 30/30 | 2/2 | 102 | e3614e0802f7f061a8a264aa0bdb5e500764bec10033975a3ce6c6b349092536 |
| 0x40a8f5 | m40a8f5_read_tag_word | 30/30 | 2/2 | 102 | b2a163b1fa8c8555694f49bd5c0e92221d7f237114996f57dfcde0dee360cfb3 |
| 0x40a947 | m40a947_read_tag_word | 30/30 | 2/2 | 102 | a680baa3e3f59ecc23e6a636ccd27bd6861864b8ec77c8cba8c1f492b6ed0508 |
| 0x40a999 | m40a999_read_tag_word | 30/30 | 2/2 | 102 | c1670a288f5cee1cc6c4bdc6591f97df0d22024d787486588d39273fc70343af |
| 0x40a9eb | m40a9eb_read_tag_word | 30/30 | 2/2 | 102 | 086de2c48ccf08ea2e0f85bf5cceca798432a684e9a50fd9be75ce751eb6cf97 |
| 0x40aa3d | m40aa3d_read_tag_word | 30/30 | 2/2 | 102 | 148c19540575727c826ec14978c066d3fbcde9c82b9a14439cecfd827a393224 |
| 0x40aa8f | m40aa8f_read_tag_word | 30/30 | 2/2 | 102 | 865bca2723b513562f77347553e35e3a00aded33dd56bdde7ac065162e1827a0 |
| 0x40aae1 | m40aae1_read_tag_word | 30/30 | 2/2 | 102 | f341c702d7a625f917b72d813ba910d54b73ab70d0137233c16e0ce6baece713 |
| 0x40ab33 | m40ab33_read_tag_word | 30/30 | 2/2 | 102 | b53f75183f86d58779840de2bb50499addfac28068689bf9eb000756d8ae18bc |
| 0x40ab85 | m40ab85_read_tag_word | 30/30 | 2/2 | 102 | fb5ae01a9b1c5c59915d2f6fd97b68f52f42ffaf3c5f304676095074a852f65f |
| 0x40abd7 | m40abd7_read_tag_word | 30/30 | 2/2 | 102 | 458676da1c512fc3347fe0d4e8b072d257d2e76b47d7bd662343c841a82ade2a |
| 0x40ac29 | m40ac29_read_tag_word | 30/30 | 2/2 | 102 | 77a03029ab4c5a8dae32e4c6798f6a6520063b47d435fb5d7e5e7f8896c36669 |
| 0x40ac7b | m40ac7b_read_tag_word | 30/30 | 2/2 | 102 | 2cf84d91bf12675faac2aea627faeb6ce97081dae7931ddad4f14193977c9476 |
| 0x40accd | m40accd_read_tag_word | 30/30 | 2/2 | 102 | 09b74725c1acc384f89d91a0bd03bead9b637dcd12885436fa4a4037f15ca334 |
| 0x40ad1f | m40ad1f_read_tag_word | 30/30 | 2/2 | 102 | 4dac6ce568ca3eb7def52498f7dfd59f2c2af39f89f255e223db2252d5d0ee1f |
| 0x40ad71 | m40ad71_read_tag_word | 30/30 | 2/2 | 102 | a53a0c2a4d562606214c319d44f833ad9b660815376a2a59f949933cab95f582 |
| 0x40adc3 | m40adc3_read_tag_word | 30/30 | 2/2 | 102 | 4de1253474b9a131fcc7c4b786db06d266b05dc0ab0895f89fe2471f6a54c0b6 |
| 0x40ae15 | m40ae15_read_tag_word | 30/30 | 2/2 | 102 | e5eb3a91b71b259da5d966a80343edd512b0bf4459cf4c73749de5cea5495b95 |
| 0x40ae67 | m40ae67_read_tag_word | 30/30 | 2/2 | 102 | 8ef058ffcab7115698857356b33ef2bb66e5aad3b38464ae241cef609b652e16 |
| 0x40aeb9 | m40aeb9_read_tag_word | 30/30 | 2/2 | 102 | b980a5aa5100803269e5ce053c76c141169bb831ba66e0b39830ab1c5f4eb1b2 |
| 0x40af0b | m40af0b_read_tag_word | 30/30 | 2/2 | 102 | 5a29456d5016c8e84228a4c241c6674bbcea4317e7251ceeb14f60c441674594 |
| 0x4080fc | m4080fc_toggle_5ec28c | 15/15 | 2/2 | 24 | d3f6b7fd6133a0d44a578f407830d12006ff1db6c1af3a7ab5d3c91c0bb528bc |
| 0x40812e | m40812e_read_text_word | 20/20 | 0/0 | 32 | 44c2eecce121921b45fea55477fd1aa5bbb7ca20e3c00e7b2756f9e82d3881cc |
| 0x408169 | m408169_read_text_word | 20/20 | 0/0 | 32 | 8a0749ff5fa5311058bb71b9de5164c16dc41bc1af9dbb486da67471d4fa4a28 |
| 0x4081a4 | m4081a4_read_text_word | 20/20 | 0/0 | 32 | dc240ca1bb7058a7a8a1d72289b229b164787077bf7a1a63d513c746dec24817 |
| 0x4081df | m4081df_read_text_word | 20/20 | 0/0 | 32 | 1015083f5f0c76f845551b8c9d3104ad31f510e5079ad016a5223696ccd4dbfb |
| 0x40821a | m40821a_read_text_word | 20/20 | 0/0 | 32 | e32210e453921b621997ee3dce8b4d52c8e3a029ee501a9194e6c44ad424aa5a |
| 0x408255 | m408255_read_text_word | 20/20 | 0/0 | 32 | 4e193ef1d3d873d31261ca4ea0f6d79a35ab93b023ce23b9535b1b88a7692a23 |
| 0x408290 | m408290_read_text_word | 20/20 | 0/0 | 32 | fede1ef6844e1ace6ac9585a8113171645eb4459fb9ecbce2dd53d095918acd8 |
| 0x4082cb | m4082cb_read_text_word | 20/20 | 0/0 | 32 | a8507336588fd2eb27f92fd05362b9d8eef162618b1fb53c90e03a1ec4e6c393 |
| 0x408306 | m408306_read_text_word | 20/20 | 0/0 | 32 | a32a8ae1801af1b41ceb7f2fbeb0ae103769d6d61b433483a2c2bd5241c2948c |
| 0x408341 | m408341_read_text_word | 20/20 | 0/0 | 32 | f2e6dfb56f3673e0e5632b6b3dd3a5441982608ff7235616a2b3c5c086d31276 |
| 0x40837c | m40837c_read_text_word | 20/20 | 0/0 | 32 | be057ef296b18f14c54ece243f65368c513ff3632a3d81ffd8639a27afda727d |
| 0x4083b7 | m4083b7_read_text_word | 20/20 | 0/0 | 32 | c7f40ce4722a9bc4c020698ed5a0347d0ffd19d80a221def3bbd78628c4b9b8e |
| 0x4083f2 | m4083f2_read_text_word | 20/20 | 0/0 | 32 | 5a289577ecc9dba801e3e57453592adce09285c92ff1cf10d0ffc44a38010bfe |
| 0x40842d | m40842d_read_text_word | 20/20 | 0/0 | 32 | e901cef6275365cdfdf159ea454d9cedcd63e1b12132e21868246be142231932 |
| 0x408468 | m408468_read_text_word | 20/20 | 0/0 | 32 | 67560ef3c3577a435605fe7d303526ddc88d36cbd81f1f5a375ad8f0661c3efc |
| 0x4084a3 | m4084a3_read_text_word | 20/20 | 0/0 | 32 | 9e99153dbeb10b84c2dcc207513357835cec7931b65895b8110d0b5faf4f7f70 |
| 0x4084de | m4084de_read_text_word | 20/20 | 0/0 | 32 | 9867921863f86de6ad0cdf162e2cd69ead5d192ff5cd0cbd699b7f07b50371f5 |
| 0x408519 | m408519_read_text_word | 20/20 | 0/0 | 32 | 64f573feaac0f8830a6c699a0fd842f87c7ae0ba3d9c364729d15b6880463554 |
| 0x408554 | m408554_read_text_word | 20/20 | 0/0 | 32 | c97e93397a61167eaa40502eaba26fa6635734a170f841c1be5d9cb487478ca5 |
| 0x40858f | m40858f_read_text_word | 20/20 | 0/0 | 32 | 6193619517be2116e9b1fb3e6772c3243aa956cd454274e8eea39483d1be10e1 |
| 0x4085ca | m4085ca_read_text_word | 20/20 | 0/0 | 32 | abe3e2fc206271d1ab955c399cec2e9b2b837ae5b04f1c7374f0e064d6837c87 |
| 0x408605 | m408605_read_text_word | 20/20 | 0/0 | 32 | ed30eddd61d0379b8879359e5e7f57a1fbe8eedc96e974e12f98347f60e97c0c |
| 0x408640 | m408640_read_text_word | 20/20 | 0/0 | 32 | 2c64334d87fc04ad51cf6fbfdb8041821c91dceb70970eb345bcac89b951d3bf |
| 0x40867b | m40867b_read_text_word | 20/20 | 0/0 | 32 | f0f82b2ddd3ce454610a99fa5b62aae75df1c33dba7f2b5c368433df6dc0f089 |
| 0x4086b6 | m4086b6_read_text_word | 20/20 | 0/0 | 32 | ec26a415734ecd17aa2245437bda30cbd88ee7139c190ee75d1dc55dcb87d0f7 |
| 0x4086f1 | m4086f1_read_text_word | 20/20 | 0/0 | 32 | 2e01c3740582a8db118622029f802c6ebba212bcae0391caf2e786833e38b532 |
| 0x40872c | m40872c_read_text_word | 20/20 | 0/0 | 32 | 330d7b1db5b981580e2c7f4add8073246cafe5d6533abe817759ba151f691c42 |
| 0x408767 | m408767_read_text_word | 20/20 | 0/0 | 32 | a0ac51da9955f95e9431c4dcaaa18f7a5349cb882c4337e7bb3de24f1375fbbe |
| 0x4087a2 | m4087a2_read_text_word | 20/20 | 0/0 | 32 | 8a3d8a9212461a521ff720fe9ed6e023d8f247869f223bf483d3ceeae5b8e75e |
| 0x4087dd | m4087dd_read_text_word | 20/20 | 0/0 | 32 | eee134161ab6f9099bfbb84590a34065815df4aba299543d9225c7b2e8a040b6 |
| 0x408818 | m408818_read_text_word | 20/20 | 0/0 | 32 | c2a5ed7c1a6ffcb36a84ab6b84ab0b2544a16c678187b8dd209be4873f442583 |
| 0x408853 | m408853_read_text_word | 20/20 | 0/0 | 32 | 24c88cdfd611ee935eaffca254b04b617566abe8ce0c42eece7ef55f461f0a35 |
| 0x40888e | m40888e_read_text_word | 20/20 | 0/0 | 32 | ea567318f6324ab1d48ffa196f457946d5296cfd625d302f87b779ea9d1d840a |
| 0x4088c9 | m4088c9_read_text_word | 20/20 | 0/0 | 32 | e20e7cedff04a6870d5891219150894203f317629f5a2a8d2aaaa67d2f13fea1 |
| 0x408904 | m408904_read_text_word | 20/20 | 0/0 | 32 | 3831cde15a37f8b9f362e48f6af91caf94d74ae08db16858cfe74554f5d0a76b |

## Divergences and unverified

- The local 0x14-byte buffer is zero-filled by the port; the original leaves it uninitialised and the callee 0x51d5b2 writes it (same as FL-32 batch b). Only the first four bytes are compared and the whole buffer goes to 0x50cb1b (cdecl, one argument); a callee that writes fewer bytes would show a difference between the original (stack residue) and the port (zeros).
- Callee conventions (0x51d5b2 thiscall with two stack arguments and `ret 8`, 0x50cb1b cdecl, 0x4090ab and 0x407ca7 thiscall with no arguments and a plain `ret`) were read from the call sites; the last two bodies are not recovered here. 0x407ca7 reads the word 0x5ec28c that 0x4080fc toggles; both are stubs in the tests, so a callee that changes `self` or a word the function re-reads is not exercised (the functions re-read nothing).
- Tag bytes at 0x53ec58..0x53eccf are patched into the image per scenario (the first pass uses the 4 bytes `---` + NUL that FL-32 saw in the image, later passes random tags); the real tag contents of the other 26 slots were not read. The tag address must resolve through `Fl18Host.resolve` (a NULL answer faults natively like an unmapped read).
- Nothing is bounds checked, as in the original. The meaning of the fields is a description, not a recovered name. Nothing in the macOS glue was built or run and no kernel calls these symbols yet. FL-34 (parallel thread) owns the toggle family near 0x402962 and the FL-32 spill rows; this slice touches neither.

## Mutation evidence

`tests/fl35a_mutation_check.py --both`: 62 mechanical mutants, 61 caught by the direct test (all of those also by the Unicorn differential), one survivor `literal 0x14 -> 0x15` (the local buffer one byte larger: an equivalent mutant, as in FL-32). `tests/fl35b_mutation_check.py --both`: 40 mutants, 39 caught, the same equivalent survivor. `tests/fl35_word_mutants.py [--differential]`: 93 hand-shaped mutants (the stored word moved to its neighbour in each of the 63 rows, the tag moved to the next tag in each of the 28 batch-a rows, the toggle's values swapped and its test narrowed to the low byte); all 93 caught by the direct test and by the differential. ASan/UBSan build of both direct tests: 30 and 38 PASS, no report.

## Commands (from `outputs/blackmoor-decomp`)

- `python3 -m unittest tests.test_fl35a_direct tests.test_fl35b_direct tests.test_fl35a_differential tests.test_fl35b_differential` (134 tests, about 30 s).
- `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl35a_direct_test.c src/original_methods_fl35a.c -lm` (and `b`).
- Regeneration after a change of ports or main: `record_function_execution.py run --only fl35a_original --only fl35b_original` then `collect --merge --write`, `extract_function_evidence.py --write`, `build_function_ledger.py --write`, `function_names.py write`, `annotate_machine.py annotate --named` and `--derived --named`, `refresh`, a re-audit of the ten batches with `--report asm/batch-NNN-report.json`. The pinned binutils 2.43.1 was rebuilt in this container from the Ubuntu old-releases orig tarball (`http://old-releases.ubuntu.com/ubuntu/pool/main/b/binutils/binutils_2.43.1.orig.tar.xz`, SHA-512 equals the pin) with `bootstrap_matching_s08_2_gas.sh`.
