# FL-37 handoff: 57 flag-toggle near-copies at 0x406b3f..0x407ac7

Cloud thread, 2026-10-21 PDT. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle loader on every run). Packet `tasks/FL-37-toggle-near-copies.md`. Implementer and reviewer: Claude Sonnet (one diff review of commit `f0c0c5b0`: no P1, no P2; three P3 items, two fixed, one noted below). Acceptances `tasks/fl37-acceptances.json` (57), reviewer `Sonnet slice-reviewer, diff review, no P1 (FL-37)`, appended to `function-ledger-overrides.json`.

## Ported (57 of 57, none dropped)

All in `src/original_methods_fl37.c` / `.h` (symbols `m<va>_toggle_<flag>`, world `Fl37World` with 57 flag dwords and `word_5e335e`, host convention `Fl18Host` as in FL-34 batch b). One symbol per row, written out separately and citing its own address. Every row was disassembled on its own (Capstone over the original image) and checked against one 18-instruction shape: `push ebp; mov ebp,esp; push ecx; mov [ebp-4],ecx; cmp dword [flag],1; jne A; mov dword [flag],0; jmp C; A: mov dword [flag],1; movsx eax, word [0x5e335e]; cmp eax,k; jne C; mov word [0x5e335e],0xffff; C: mov ecx,[ebp-4]; call 0x404be1; mov esp,ebp; pop ebp; ret`. The flag is the same dword in the compare and both stores, and `flag = 0x5e353e + 4*n`, `k = 0xd + n` for n = 0..56. 56 rows have span 71; `0x407ac7` has span 73 (71 code bytes plus two `int3`; window = the span, code = 71). Semantics: when `dword [flag] == 1` it becomes 0 and nothing else is stored; otherwise it becomes 1 and, when the signed word `[0x5e335e]` equals k, the word becomes 0xffff; then `0x404be1(this self)` (thiscall, no arguments).

| va | span | symbol | flag | k | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes) |
|---|---|---|---|---|---|---|---|---|---|
| 0x406b3f | 71 | m406b3f_toggle_5e353e | 0x5e353e | 0xd | 18/18 | 4/4 | 156 | b192e3ecf4b921dbf1bf98ab908d81566e88390989c234946414b626fc7f2e7c | 3fb7cd07a14dc56bd10c90426f581b1dd71c3c725be8efd2e9d515fa8e4b1dd3 |
| 0x406b86 | 71 | m406b86_toggle_5e3542 | 0x5e3542 | 0xe | 18/18 | 4/4 | 168 | ef5c64c44268433230be700f417e6feb0a4e57478743dcdd614ef726c234f48c | 8501977ff4ef36bd0549c6b87914f5072df5b98b9455a3dcabb16f28573a9db0 |
| 0x406bcd | 71 | m406bcd_toggle_5e3546 | 0x5e3546 | 0xf | 18/18 | 4/4 | 180 | 767f3185bf6c7247194ff533df3c2917fe66aafc673b898c0d3c0044816380fd | 21a4da378b9b9bf699a48f5153059371cc26d5200f7996a9483bb42e667f81d3 |
| 0x406c14 | 71 | m406c14_toggle_5e354a | 0x5e354a | 0x10 | 18/18 | 4/4 | 180 | 0bfeef791fd8337af311ee55b56c3754849b2ec1ffec160f30af5adbc7bb133c | cd4dad786d2891a86969847c2a28ff1b62bfec53548ea5da55029dcd23700bf6 |
| 0x406c5b | 71 | m406c5b_toggle_5e354e | 0x5e354e | 0x11 | 18/18 | 4/4 | 180 | c9acb1c0a171175478497e45f0131beea5145cfde8fd43d0b4015b6d1a251e48 | e9b31850b06f006cb12475953e2c4fb40a0f7e31e23ffd94e758e2faa880a9b2 |
| 0x406ca2 | 71 | m406ca2_toggle_5e3552 | 0x5e3552 | 0x12 | 18/18 | 4/4 | 180 | feb39224e6edd2aa14beced7fa1dc0ae9d028976034d95b962c71e270b9ba2a4 | 33b3829d6df1ef1ad4e13d236e2cfd92b1da96538c7bb8674f237c14145b6dbb |
| 0x406ce9 | 71 | m406ce9_toggle_5e3556 | 0x5e3556 | 0x13 | 18/18 | 4/4 | 180 | 5eeb05d6859cb209686dde67f567aa239c82222526d1fc91778a2e68b74169d6 | 0cb31517ab08a08a7a81eef7851cb960e4bd075ea867b17961c2ad92ea50fd43 |
| 0x406d30 | 71 | m406d30_toggle_5e355a | 0x5e355a | 0x14 | 18/18 | 4/4 | 180 | a19050dbff19f3f32ba2c00020ca4d7534ac551d626c5dbdfe265fa5b18512de | 42c1d03a5988774f2e48cdf74a5a895e179b506f73eca6ddded95c88f8155bbe |
| 0x406d77 | 71 | m406d77_toggle_5e355e | 0x5e355e | 0x15 | 18/18 | 4/4 | 180 | 83812be5771c404b3a3b86dbfb4ace0eaf5b669bb8d6e0f7010c9b4ce9b69005 | aec4db864608fac5b66a8135fb11180d4cb0832fa67ab9be0f27f19b22df37b9 |
| 0x406dbe | 71 | m406dbe_toggle_5e3562 | 0x5e3562 | 0x16 | 18/18 | 4/4 | 180 | 65798d248840affade32f942706ca26c2fc2931cb7f5d81beaf4e7856efa0681 | ac996f6b0701df981d6e45d72809ee0d399373f9fce64e4401fd7a9e8b8b6030 |
| 0x406e05 | 71 | m406e05_toggle_5e3566 | 0x5e3566 | 0x17 | 18/18 | 4/4 | 180 | 3c548440a22c134a43ba7f657a5557a5470aba5cebfbd2d055940416e76eea28 | ad32360bc41771698c9b35de754a41038dd777667e436059724bef0306b3e911 |
| 0x406e4c | 71 | m406e4c_toggle_5e356a | 0x5e356a | 0x18 | 18/18 | 4/4 | 180 | 7032deb5f1e96ea6f7270406b2d1ca88a753389550188729d92507e487d1b052 | 82add8b5dac548d0c669b1f604ce7d43cd4cb0d7d3b9d779e40a93433cbc4105 |
| 0x406e93 | 71 | m406e93_toggle_5e356e | 0x5e356e | 0x19 | 18/18 | 4/4 | 180 | 013c3dd5ca8bafd802c0651b1b41a43579361c68ab9b8ab794fd183b116a3b73 | 142fe015a73f05f594375e435d6c69964bd5a51633856d0286826869f9a673b9 |
| 0x406eda | 71 | m406eda_toggle_5e3572 | 0x5e3572 | 0x1a | 18/18 | 4/4 | 180 | e584e410a8d12ddcc564142d9bb88260b0138c20a34a82d62efaa93e4618478b | b95c6ce6f7b99c78835649794b8b84167fa210eed175cd2023e6b1825d24d75a |
| 0x406f21 | 71 | m406f21_toggle_5e3576 | 0x5e3576 | 0x1b | 18/18 | 4/4 | 180 | e25da2dd6d850586711eff6277a287563ea0db7b9ca63e2459fa888daa048763 | d77365a760dc8ca5ef19a11bee35081250b0fbbd8c9949531507188a248fd83b |
| 0x406f68 | 71 | m406f68_toggle_5e357a | 0x5e357a | 0x1c | 18/18 | 4/4 | 180 | e2d276dfd091aa136be755ece4ada8482d0f8d46022ab43c90d62790cae365f3 | e58b135b68f256d604db0164df49df3639bf6d53f6ffe292abc2afd784a9945f |
| 0x406faf | 71 | m406faf_toggle_5e357e | 0x5e357e | 0x1d | 18/18 | 4/4 | 180 | 046614f7e7cd7c40b7090c8a451c418e433a125b832e2f9ebc8f07ef6ef7fac7 | f61fdd478fa0c2fe7853c1c8eeebe92fb0bb14745d8f2e7468c52327ba65073c |
| 0x406ff6 | 71 | m406ff6_toggle_5e3582 | 0x5e3582 | 0x1e | 18/18 | 4/4 | 180 | 09e2d9e412eb246f5b4bec9109ad153b20c45f46fc46b31b15cf69e900a698cc | 7cbc243fad395df6e94eaec1f7bd52f716eaf84f5319bc5a02e54f4b64f7d16d |
| 0x40703d | 71 | m40703d_toggle_5e3586 | 0x5e3586 | 0x1f | 18/18 | 4/4 | 180 | f1b1bcf78b85d9d9c696d54cff7284d0d89fda58ef88d0a812b54ff1ac12a7bf | 3c88f8579236616ff50b95c2b6f61c238548e4dfec0424c1d2f668936e96d5c8 |
| 0x407084 | 71 | m407084_toggle_5e358a | 0x5e358a | 0x20 | 18/18 | 4/4 | 180 | 1bbcab5fe42439e9c0bbf51aef1298397db2859ab740baaa1eb1bedecb44e3d2 | 6055b422c3e2fb9789c0dce8fbc140b18377919854c45c4e2fe62ed051d20fb7 |
| 0x4070cb | 71 | m4070cb_toggle_5e358e | 0x5e358e | 0x21 | 18/18 | 4/4 | 180 | bd83353d775c120afbe333d85c60aae6a3b3915b6b5c89035b92b944ade69866 | 7df5c297a004c98c3ba968a1d83aa4aba871b5ea8e22c2b30f1bf1e90b8ca81f |
| 0x407112 | 71 | m407112_toggle_5e3592 | 0x5e3592 | 0x22 | 18/18 | 4/4 | 180 | 578932d4be7f13e55d03403cd13da59ce9af858d3f0676fd9f36f2091c0ca19c | c462c0d72e76779c9e4cf066c87b1cd59fec3ff7a7249d95f792fd79a1fc2036 |
| 0x407159 | 71 | m407159_toggle_5e3596 | 0x5e3596 | 0x23 | 18/18 | 4/4 | 180 | 327980ac63a2122089778bfd94a8c322a26e70f6af3379780bbdf4330b776e33 | 9448bf2098deb7d0347f81ec7f5546a9157b1a35b2b2fa83d1b2d177265324fa |
| 0x4071a0 | 71 | m4071a0_toggle_5e359a | 0x5e359a | 0x24 | 18/18 | 4/4 | 180 | 123b3bb6fb72d517c105c724082b1addc08b8410780439f8dc7f8833bd694c94 | cc82049210c1067de18d77ef581f874dd16cb5fe38029ebb343e2e72bed9d4a8 |
| 0x4071e7 | 71 | m4071e7_toggle_5e359e | 0x5e359e | 0x25 | 18/18 | 4/4 | 180 | 5345e569f3e4cdf4db3be705daac72fd8ae34ac5101972257a8cfb3231d6a31c | 9045f2ac5cc73fdf1f1497c27eae76d886bedaaacefedc33ed76d0e53551be6d |
| 0x40722e | 71 | m40722e_toggle_5e35a2 | 0x5e35a2 | 0x26 | 18/18 | 4/4 | 180 | 281227de6c110ce8601d08b2b6b7bc3f3b4a4abc2ffe28ce1a2119f9cbc04d41 | 0f5f51c1be3667255204822185b80e1a981236f7dd7958a8e1e160cb54794190 |
| 0x407275 | 71 | m407275_toggle_5e35a6 | 0x5e35a6 | 0x27 | 18/18 | 4/4 | 180 | 4c97cd0187e6c7b6a794cc78f83814842c8c13985c1c4797bb929bf47e09da69 | 990770f7bac7b69061795d964f85f68a323a4019efb7b01406e22f0366d38900 |
| 0x4072bc | 71 | m4072bc_toggle_5e35aa | 0x5e35aa | 0x28 | 18/18 | 4/4 | 180 | 24e64ccd05780bc16591f5bd3d6e80c7be55aad253d05dd32409d689ec90ac9a | f25b8cea4c41bb53d6c15a6e58b0adf4bca5c1d76b588e79ed64a2d10bb021a5 |
| 0x407303 | 71 | m407303_toggle_5e35ae | 0x5e35ae | 0x29 | 18/18 | 4/4 | 180 | 5c8eef9326903b7181226965155a3e0402ce9cf00d1e805ce423d314542133a4 | 0a480393c63cfb0e61742cc577b4c68f4c25a56023469ff2dc8b9cd85bf84783 |
| 0x40734a | 71 | m40734a_toggle_5e35b2 | 0x5e35b2 | 0x2a | 18/18 | 4/4 | 180 | 9523f139cc63734f71c4ced81d8154ffb5439548aa6085a82eb85987a32405ac | 09d6de6378cb8ae80f8a8d17560f0cf46f1acaeeef6f8792978de426254929f5 |
| 0x407391 | 71 | m407391_toggle_5e35b6 | 0x5e35b6 | 0x2b | 18/18 | 4/4 | 180 | ab42cc5d57eb4f293ef057aa7fcedc37aa8d74a2a9857fdb66cf8f23480f719b | 33424d2ff9e4353dcdef72a965ac7c5d3f48cb682267725d5014565b421c2744 |
| 0x4073d8 | 71 | m4073d8_toggle_5e35ba | 0x5e35ba | 0x2c | 18/18 | 4/4 | 180 | 3161c5e9e2ebfe0fae2b61bb965e05b38c7b7ea41cef53c0f5cdf47939ccff50 | dfd7a6b0fc6070763d78ec17c7549ce6fc86c16440d04d037f0e72c55e8b43a0 |
| 0x40741f | 71 | m40741f_toggle_5e35be | 0x5e35be | 0x2d | 18/18 | 4/4 | 180 | 71c7c6b3b6aec606ece72e3e1ae097c59a4320ad93c9c85f83c64e24733b1d6e | 6191cf13f1b614796aa4957d635f13f67dc3d4425347c5d57f8c3531137fc7bb |
| 0x407466 | 71 | m407466_toggle_5e35c2 | 0x5e35c2 | 0x2e | 18/18 | 4/4 | 180 | 8dc256adeadca66e3fa78a4c8598d2c9604efaa0903248cda95a17e96683642d | 72fdccd87dec639639b4e065592c518f1378c7aad502d98e37e26152212acae0 |
| 0x4074ad | 71 | m4074ad_toggle_5e35c6 | 0x5e35c6 | 0x2f | 18/18 | 4/4 | 180 | 2052f707d413a9557dfbae4b70037e7e361249f07637e3cf3afb31fb08e162da | bf16daf7998add845a80662b108dba5b16e2accdc2305f4c6d8eba0a23e82539 |
| 0x4074f4 | 71 | m4074f4_toggle_5e35ca | 0x5e35ca | 0x30 | 18/18 | 4/4 | 180 | 7d0489925ddbecee8fb68aca42ef0d179b67d647052c2ef0c837a3d0786ad172 | 25f94bf406317f69ede10f8e5940784539793580ae2cf40b4f041a87bcd93ec3 |
| 0x40753b | 71 | m40753b_toggle_5e35ce | 0x5e35ce | 0x31 | 18/18 | 4/4 | 180 | a7b58c05648f172db9c07a607a9f7ccc2e8781854cda08afa3b9d5256a5b7c17 | ef2487eca40acb62ec002b68198cc80094fc0ae29e457b40951e84c950b536b2 |
| 0x407582 | 71 | m407582_toggle_5e35d2 | 0x5e35d2 | 0x32 | 18/18 | 4/4 | 180 | 81b178272ae01a2e832d0b11c86541d6fd6eee756d170471facf6bbb193c8caa | 37e0f4d49bf77ce5870315211fac4c45484975b097b7f25ce0f132a4705211e9 |
| 0x4075c9 | 71 | m4075c9_toggle_5e35d6 | 0x5e35d6 | 0x33 | 18/18 | 4/4 | 180 | dd8950e24fe4485b19d24c684d352252d6f5126d20d3ed77279a982405fcb695 | f03ee1d2c0ecaef6345734f937eaba101afb39430b670aea3db3327682bbece3 |
| 0x407610 | 71 | m407610_toggle_5e35da | 0x5e35da | 0x34 | 18/18 | 4/4 | 180 | 79418e857f4b6d2a176ffa992c518a5f2c66832cb32bf05312776753b9469361 | 6f541ebc9169ccda1abda89e77e2a0e9b2fe9867f81f169347b9919568f6c889 |
| 0x407657 | 71 | m407657_toggle_5e35de | 0x5e35de | 0x35 | 18/18 | 4/4 | 180 | debffb02a43652133e16027777ea4affc841b6a9e2cb502c7a44f54f5febbf7f | 935da61b59fa464e491b00aa773d143b896908cc57138cfadeff2465a8d410eb |
| 0x40769e | 71 | m40769e_toggle_5e35e2 | 0x5e35e2 | 0x36 | 18/18 | 4/4 | 180 | a9a123c25ddbd32a1c8f0cb44ba93f60193f009b370345bc65609765d77a5323 | a2fdf1a2360884fdac3fd105261be332ecb05aac2cc3667301e67337651b4240 |
| 0x4076e5 | 71 | m4076e5_toggle_5e35e6 | 0x5e35e6 | 0x37 | 18/18 | 4/4 | 180 | 5d39adf6a96f4600445a70645e6f2ee821062135a9a54c2f02e93cf6ee1ee76a | bf5dc8aafe3c584980250e8d109e85c746e4e667ba616ef327cbfc4c812bc377 |
| 0x40772c | 71 | m40772c_toggle_5e35ea | 0x5e35ea | 0x38 | 18/18 | 4/4 | 180 | 1c323fab505740c88b31325398212ff3e8f7e01a526ea3ee0df3fe2bc68f4160 | 568231ed2d1b44a370d40be74c0b5cf84762b3a07359640e37aad060f206cdd6 |
| 0x407773 | 71 | m407773_toggle_5e35ee | 0x5e35ee | 0x39 | 18/18 | 4/4 | 180 | cf7a1f7b034d5a904c34cee487df784d49dcf31a13768ee647b4c808422b309b | 3c8cbd49ae481ef86782f03e8fc6c31315ff5de739c5ec8d7b1eab642147c4e9 |
| 0x4077ba | 71 | m4077ba_toggle_5e35f2 | 0x5e35f2 | 0x3a | 18/18 | 4/4 | 180 | 96eed492d081ed218cc6a5cce4e7e4822801e910a6aedef4e28a23c60b28bb77 | d5c6f2a4c02a2fe31d54f421802af3f6c66e4eda495c9a221950bf6e4e8dbd06 |
| 0x407801 | 71 | m407801_toggle_5e35f6 | 0x5e35f6 | 0x3b | 18/18 | 4/4 | 180 | c593699c6cca6ae9adea7caeae54374d6579fca21d95f3769d2af52ebe2ec511 | b7b7b25b5c9294787ab813380ce043c756c2bdfcfa29e9d4036bc570644c8509 |
| 0x407848 | 71 | m407848_toggle_5e35fa | 0x5e35fa | 0x3c | 18/18 | 4/4 | 180 | 9b2000f9f327ddd84f98cf041c9856927165dfd5fd52361f086ad0ccc7d85468 | 579eb0a0b14b5ac8977f6d92808e1feaa54711118ce4d07ff00f45d5e9af51bb |
| 0x40788f | 71 | m40788f_toggle_5e35fe | 0x5e35fe | 0x3d | 18/18 | 4/4 | 180 | f83ddb370afe63ea8b31220a244796115f981a9a6889e5637228bc376421f9bd | 4915d4ac979913b78b49736430fa3577acc72ba4bef8367c68bda256075f68f0 |
| 0x4078d6 | 71 | m4078d6_toggle_5e3602 | 0x5e3602 | 0x3e | 18/18 | 4/4 | 180 | e4ef98f5a469263e72a15c7bc0ea91fed723ff7ccf61665cd3078aaefbdc1efc | 790bd89508d0c309499546aa8a907b6fd918aab671373aa124d75ed114840eb9 |
| 0x40791d | 71 | m40791d_toggle_5e3606 | 0x5e3606 | 0x3f | 18/18 | 4/4 | 180 | ee16d3afc9e1e26fe7acc7169b06381d0e7b0bdbb79702f25a8f0c265eba1f73 | 8001d9f611eb515970c4b6eff4fbd37a26ea32466f372c19498b4fb5770d1a5e |
| 0x407964 | 71 | m407964_toggle_5e360a | 0x5e360a | 0x40 | 18/18 | 4/4 | 180 | 90d3e03705e0f76695c8b13bbfcc17ef6f5822d5a96a1f670aed59d1fa75d83b | 3a5f9fd5a952ca4e4ad76ac690146c4c497f6fe0f0897c6422d04265325ff500 |
| 0x4079ab | 71 | m4079ab_toggle_5e360e | 0x5e360e | 0x41 | 18/18 | 4/4 | 180 | a42f460c75134b7f0a2b2d15fb09f6cf16aa082dba3ee79631a15c57e778a745 | 683a48e18ee1e1634e036ba9c1e0b3d6108e500c3be31928e76391383a40a48e |
| 0x4079f2 | 71 | m4079f2_toggle_5e3612 | 0x5e3612 | 0x42 | 18/18 | 4/4 | 180 | 94137c4c75ffaa0f26af50582d2dde1a2472784126bce2144f7860a81eea9751 | a90c424075b121e25eec0599763efeb30ba57dcce03192d9709154b1cb77a8ba |
| 0x407a39 | 71 | m407a39_toggle_5e3616 | 0x5e3616 | 0x43 | 18/18 | 4/4 | 180 | 43f8a8005efcde7f05c106c99e1ac76334ef39e44bf7b237a1df9f922b8a848d | 3989660f8e6c3177185fdd38d91f19cd4ed57655f323a7bec4035491d5c619c1 |
| 0x407a80 | 71 | m407a80_toggle_5e361a | 0x5e361a | 0x44 | 18/18 | 4/4 | 168 | 022d0f3b3a312b12a5788ba5355edd6ade34af83c9aa7a7a1a0f0b279b68db88 | d1dc969580fa3b297502685eba85db0e0a21b15fcfeb03b78042f50fb5070e76 |
| 0x407ac7 | 73 | m407ac7_toggle_5e361e | 0x5e361e | 0x45 | 18/18 | 4/4 | 168 | 4eddfa9d084b0b41c4d3a9a196134381af86f4df730a6f762d9d63443a57aac2 | 6e944be68b9c9105cfb7d34dcd5324184d39bec27181bfd2dfb8f8899d9fe257 |

Untaken jump edges: none (`fl37_fixtures.UNTAKEN_ALLOWED` is empty; each function has two conditional jumps, taken both ways, 57 x 4 = 228 of 228 directions). No row has an unreachable block, a receipt blocker, x87 or an indirect jump, so nothing is flagged for the owner and nothing stays pending from this pool.

## Dropped

None. The family `0x4067a5..0x407ac7` is now fully ported (FL-32 batch a, FL-34 batch b, FL-37).

## Files

`src/original_methods_fl37.h`, `.c`; `tests/fl37_direct_test.c`, `test_fl37_direct.py`, `fl37_fixtures.py`, `fl37_differential_shim.c`, `test_fl37_differential.py`, `fl37_original_oracle.py`, `fl37_mutation_check.py`, `fl37_hand_mutants.py`; `tasks/fl37-acceptances.json`; this file. They were generated from the fl34b files and each row's own constants by a throwaway script (not committed); the generic parts are byte-identical to fl34b after renaming. Differences from fl34b outside the row lists: `SPECS` gives `0x407ac7` `code=71`; the fixed word list of `words_for` ends `0xc, 0xd, 0x45` instead of `0x4, 0xc, 0xd`; the sweep word range is `% 0x46`; `NFLAGS` is 57.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed)

- Slice tests: `python3 -m unittest tests.test_fl37_direct tests.test_fl37_differential` -> 116 tests, OK (59 direct: 57 functions, the run-all check and the sweep; 57 differential).
- Oracle: `python3 tests/fl37_original_oracle.py` -> 57 lines as in the table, exit 0 (about 40 s). Recorded with `record_function_execution.py run --only fl37_original` and `collect --merge --write` (174 runs).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl37_direct_test.c src/original_methods_fl37.c -lm` -> 58 PASS (57 functions + the bounded sweep), no report.
- Mutation: `python3 tests/fl37_mutation_check.py` -> mutants 285: caught by the direct test 285, differential only 0, survivors 0. `python3 tests/fl37_hand_mutants.py` -> hand mutants 513, survivors 0 (9 per row: byte-wide compare of the word, stored word 0x7fff, k + 1, `<=` instead of `==`, a masked and a loosened flag compare, a store to another flag, the word store also in the "flag was 1" arm, the call made first). The review noted that fl34b had 16 to 19 per row; the dropped shapes (stored 0, `!= k`, `>= k`, `(flag & 1)`, flag stored 2, word store moved into the "flag was 1" arm) are caught by the same generic direct and differential checks (`check_flag` compares the word and every flag exactly) and are not separately applied here.

## Hooks, divergences, unverified

One recording stub entered by address: `0x404be1` thiscall(0) (not run; pops nothing, returns a scripted `eax`, logs ecx, `self` bytes 0..0x20 and all 57 flags and the word at the call, which proves that both stores come before the call). Globals are patched into the image per scenario; every global of `Fl37World` is random in every scenario and read back, so a store to a neighbouring flag or with the wrong width shows. The oracle checks that the function pops 0 bytes. No deliberate divergences; nothing is bounds checked, as in the original. Unverified: the convention of `0x404be1` (no argument, plain `ret`) is taken from FL-32a/FL-34, not re-derived; a callee that changes a flag or the word that the function reads again is not exercised (nothing is read after the call). Nothing in the macOS glue was built or run and no kernel calls these symbols yet. The names are descriptions, not recovered source names.

## Source and test hashes (sha256, at collection)

| file | sha256 |
|---|---|
| src/original_methods_fl37.c | 1c4c5a78517e4e457c08a78637929904809870cf8f4afa0b716e2b527ae28c86 |
| src/original_methods_fl37.h | a56e1b92a07b4e9662bb4b1ea4f3d1378541230060632b60f82929a3a47a62a5 |
| tests/fl37_differential_shim.c | 4290edcf8f7656645ddca8b25e68938f3fd62b42dc0736a6120f94cf07848e99 |
| tests/fl37_direct_test.c | 6f39afd538a9d231c42021f8ea59ee9b6d1e049227da8feabc57f34846365c83 |
| tests/fl37_fixtures.py | d6b195e9cfa7e064461d2eed006f4a8975a7a7e0912db95ec93eb4dc492e1e73 |
| tests/fl37_hand_mutants.py | 1ab1e0f196b40501620625ebe07cbfb5406b76c3d2614970924048668c344fbb |
| tests/fl37_mutation_check.py | 6a9a4d4c333f9bb827b18ea01a6e065c448efa910d555b5e977b3551a30f6a63 |
| tests/fl37_original_oracle.py | 899a078d45f6cc044d16aebfa1da61cbbd92f6f79ede0ff125be847fa763c43a |
| tests/test_fl37_differential.py | cc1f37c11c690e5895ff9f0f9cef08557d529a18146bfa1f4d6b14d68e2925eb |
| tests/test_fl37_direct.py | 7b7d68806bb015936f7765c2f53183aa76a7c373e280ef2c1f558a74f16cecc5 |
| tasks/fl37-acceptances.json | 4964fbb092b9ee5747750c6101038740ebbd1796d4e70f56b2269b43bba546d9 |
