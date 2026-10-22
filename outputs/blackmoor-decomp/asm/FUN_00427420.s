# FUN_00427420
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00427420
# extent:       0x00427420-0x00427a32 (1554 code bytes)
# span:         0x00427420-0x00427a40 (code 1554, tables 0, padding 14)
# sha256:       de93c05731a70e9f7041b6b43d11c38e8530864454adda08affa6677b303d2c0
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m427420_lifted
# naming:       native port src/original_methods_fl40.c:m427420_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 349/349 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00445e0f, FUN_0041458b, FUN_004caeef, FUN_004ccd8f, FUN_004bf61f, FUN_0044afd6, FUN_00447e46, FUN_004dbf6e, FUN_00423467, FUN_004ac8be, FUN_0049c59f, FUN_00490547, FUN_004cc946, FUN_004a9f0b, FUN_0046b56e, FUN_004a7c5e and 68 more
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m427420_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 349 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004110d7, .text + (0x004110d7 - 0x401000)
.set FUN_0041458b, .text + (0x0041458b - 0x401000)
.set FUN_00414ccf, .text + (0x00414ccf - 0x401000)
.set FUN_00416f2d, .text + (0x00416f2d - 0x401000)
.set FUN_0041bebc, .text + (0x0041bebc - 0x401000)
.set FUN_00423467, .text + (0x00423467 - 0x401000)
.set FUN_00426346, .text + (0x00426346 - 0x401000)
.set FUN_0043772f, .text + (0x0043772f - 0x401000)
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)
.set FUN_00445e0f, .text + (0x00445e0f - 0x401000)
.set FUN_00446faa, .text + (0x00446faa - 0x401000)
.set FUN_00447d2f, .text + (0x00447d2f - 0x401000)
.set FUN_00447e46, .text + (0x00447e46 - 0x401000)
.set FUN_0044883f, .text + (0x0044883f - 0x401000)
.set FUN_0044afd6, .text + (0x0044afd6 - 0x401000)
.set FUN_0044bea7, .text + (0x0044bea7 - 0x401000)
.set FUN_0044d0eb, .text + (0x0044d0eb - 0x401000)
.set FUN_0044e74b, .text + (0x0044e74b - 0x401000)
.set FUN_0044f66f, .text + (0x0044f66f - 0x401000)
.set FUN_00454d6e, .text + (0x00454d6e - 0x401000)
.set FUN_00456ceb, .text + (0x00456ceb - 0x401000)
.set FUN_00457f5e, .text + (0x00457f5e - 0x401000)
.set FUN_00459ace, .text + (0x00459ace - 0x401000)
.set FUN_0045b3ce, .text + (0x0045b3ce - 0x401000)
.set FUN_0045dc6e, .text + (0x0045dc6e - 0x401000)
.set FUN_0046180b, .text + (0x0046180b - 0x401000)
.set FUN_00463ffe, .text + (0x00463ffe - 0x401000)
.set FUN_00465aeb, .text + (0x00465aeb - 0x401000)
.set FUN_004674ff, .text + (0x004674ff - 0x401000)
.set FUN_00468e3e, .text + (0x00468e3e - 0x401000)
.set FUN_0046b56e, .text + (0x0046b56e - 0x401000)
.set FUN_0046e66a, .text + (0x0046e66a - 0x401000)
.set FUN_00470d5e, .text + (0x00470d5e - 0x401000)
.set FUN_00472f95, .text + (0x00472f95 - 0x401000)
.set FUN_004757be, .text + (0x004757be - 0x401000)
.set FUN_004781de, .text + (0x004781de - 0x401000)
.set FUN_0047b21f, .text + (0x0047b21f - 0x401000)
.set FUN_0047d4db, .text + (0x0047d4db - 0x401000)
.set FUN_0047e23e, .text + (0x0047e23e - 0x401000)
.set FUN_0048215e, .text + (0x0048215e - 0x401000)
.set FUN_00483f4e, .text + (0x00483f4e - 0x401000)
.set FUN_00487afe, .text + (0x00487afe - 0x401000)
.set FUN_00488d89, .text + (0x00488d89 - 0x401000)
.set FUN_0048a6ee, .text + (0x0048a6ee - 0x401000)
.set FUN_0048bafb, .text + (0x0048bafb - 0x401000)
.set FUN_0048d04b, .text + (0x0048d04b - 0x401000)
.set FUN_0048e26e, .text + (0x0048e26e - 0x401000)
.set FUN_00490547, .text + (0x00490547 - 0x401000)
.set FUN_0049c59f, .text + (0x0049c59f - 0x401000)
.set FUN_004a1c2b, .text + (0x004a1c2b - 0x401000)
.set FUN_004a376e, .text + (0x004a376e - 0x401000)
.set FUN_004a636e, .text + (0x004a636e - 0x401000)
.set FUN_004a7c5e, .text + (0x004a7c5e - 0x401000)
.set FUN_004a9f0b, .text + (0x004a9f0b - 0x401000)
.set FUN_004ab38b, .text + (0x004ab38b - 0x401000)
.set FUN_004ac8be, .text + (0x004ac8be - 0x401000)
.set FUN_004afd1e, .text + (0x004afd1e - 0x401000)
.set FUN_004b3c3e, .text + (0x004b3c3e - 0x401000)
.set FUN_004b5b6e, .text + (0x004b5b6e - 0x401000)
.set FUN_004b71db, .text + (0x004b71db - 0x401000)
.set FUN_004b7f1f, .text + (0x004b7f1f - 0x401000)
.set FUN_004b9e1f, .text + (0x004b9e1f - 0x401000)
.set FUN_004bed99, .text + (0x004bed99 - 0x401000)
.set FUN_004bf61f, .text + (0x004bf61f - 0x401000)
.set FUN_004c139a, .text + (0x004c139a - 0x401000)
.set FUN_004caeef, .text + (0x004caeef - 0x401000)
.set FUN_004cc946, .text + (0x004cc946 - 0x401000)
.set FUN_004ccd8f, .text + (0x004ccd8f - 0x401000)
.set FUN_004d3b6e, .text + (0x004d3b6e - 0x401000)
.set FUN_004d527f, .text + (0x004d527f - 0x401000)
.set FUN_004d58cf, .text + (0x004d58cf - 0x401000)
.set FUN_004db27f, .text + (0x004db27f - 0x401000)
.set FUN_004dbf6e, .text + (0x004dbf6e - 0x401000)
.set FUN_004dd3cf, .text + (0x004dd3cf - 0x401000)
.set FUN_004de1a4, .text + (0x004de1a4 - 0x401000)
.set FUN_004de66e, .text + (0x004de66e - 0x401000)
.set FUN_004e048f, .text + (0x004e048f - 0x401000)
.set FUN_004e2d63, .text + (0x004e2d63 - 0x401000)
.set FUN_004e7684, .text + (0x004e7684 - 0x401000)
.set FUN_004e7b37, .text + (0x004e7b37 - 0x401000)
.set FUN_004eb8fe, .text + (0x004eb8fe - 0x401000)
.set FUN_004f001f, .text + (0x004f001f - 0x401000)
.set FUN_004fa9e7, .text + (0x004fa9e7 - 0x401000)
.set FUN_00524e1f, .text + (0x00524e1f - 0x401000)

.org 0x00427420 - 0x401000
.globl FUN_00427420
FUN_00427420:
    # block 0x00427420: entry, 349 instruction(s), calls FUN_00445e0f, FUN_0041458b, FUN_004caeef, FUN_004ccd8f, FUN_004bf61f, FUN_0044afd6, FUN_00447e46,..., ends with ret
    push ebp                                     # 00427420
    {load} mov ebp, esp                          # 00427421
    push -0x1                                    # 00427423
    push 0x527dd7                                # 00427425
    mov eax, dword ptr fs:[0x0]                  # 0042742a
    push eax                                     # 00427430
    mov dword ptr fs:[0x0], esp                  # 00427431
    push ecx                                     # 00427438
    mov dword ptr [ebp - local_10], ecx          # 00427439
    mov dword ptr [ebp - local_4], 0x52          # 0042743c
    mov ecx, dword ptr [ebp - local_10]          # 00427443
    add ecx, 0xc827b                             # 00427446
    call FUN_00445e0f                            # 0042744c
    mov byte ptr [ebp - local_4], 0x51           # 00427451
    mov ecx, dword ptr [ebp - local_10]          # 00427455
    add ecx, 0xc8253                             # 00427458
    call FUN_0041458b                            # 0042745e
    mov byte ptr [ebp - local_4], 0x50           # 00427463
    mov ecx, dword ptr [ebp - local_10]          # 00427467
    add ecx, 0xc80f3                             # 0042746a
    call FUN_004caeef                            # 00427470
    mov byte ptr [ebp - local_4], 0x4f           # 00427475
    mov ecx, dword ptr [ebp - local_10]          # 00427479
    add ecx, 0xc7e95                             # 0042747c
    call FUN_004ccd8f                            # 00427482
    mov byte ptr [ebp - local_4], 0x4e           # 00427487
    mov ecx, dword ptr [ebp - local_10]          # 0042748b
    add ecx, 0xc7c47                             # 0042748e
    call FUN_004bf61f                            # 00427494
    mov byte ptr [ebp - local_4], 0x4d           # 00427499
    mov ecx, dword ptr [ebp - local_10]          # 0042749d
    add ecx, 0xc7c29                             # 004274a0
    call FUN_0044afd6                            # 004274a6
    mov byte ptr [ebp - local_4], 0x4c           # 004274ab
    mov ecx, dword ptr [ebp - local_10]          # 004274af
    add ecx, 0xc7c07                             # 004274b2
    call FUN_00447e46                            # 004274b8
    mov byte ptr [ebp - local_4], 0x4b           # 004274bd
    mov ecx, dword ptr [ebp - local_10]          # 004274c1
    add ecx, 0xc7afd                             # 004274c4
    call FUN_004dbf6e                            # 004274ca
    mov byte ptr [ebp - local_4], 0x4a           # 004274cf
    mov ecx, dword ptr [ebp - local_10]          # 004274d3
    add ecx, 0xc74e5                             # 004274d6
    call FUN_00423467                            # 004274dc
    mov byte ptr [ebp - local_4], 0x49           # 004274e1
    mov ecx, dword ptr [ebp - local_10]          # 004274e5
    add ecx, 0xc665c                             # 004274e8
    call FUN_004ac8be                            # 004274ee
    mov byte ptr [ebp - local_4], 0x48           # 004274f3
    mov ecx, dword ptr [ebp - local_10]          # 004274f7
    add ecx, 0xc5810                             # 004274fa
    call FUN_0049c59f                            # 00427500
    mov byte ptr [ebp - local_4], 0x47           # 00427505
    mov ecx, dword ptr [ebp - local_10]          # 00427509
    add ecx, 0xc0712                             # 0042750c
    call FUN_00490547                            # 00427512
    mov byte ptr [ebp - local_4], 0x46           # 00427517
    mov ecx, dword ptr [ebp - local_10]          # 0042751b
    add ecx, 0xc06f6                             # 0042751e
    call FUN_004cc946                            # 00427524
    mov byte ptr [ebp - local_4], 0x45           # 00427529
    mov ecx, dword ptr [ebp - local_10]          # 0042752d
    add ecx, 0xc06ac                             # 00427530
    call FUN_004a9f0b                            # 00427536
    mov byte ptr [ebp - local_4], 0x44           # 0042753b
    mov ecx, dword ptr [ebp - local_10]          # 0042753f
    add ecx, 0xb83aa                             # 00427542
    call FUN_0046b56e                            # 00427548
    mov byte ptr [ebp - local_4], 0x43           # 0042754d
    mov ecx, dword ptr [ebp - local_10]          # 00427551
    add ecx, 0xb6fad                             # 00427554
    call FUN_004a7c5e                            # 0042755a
    mov byte ptr [ebp - local_4], 0x42           # 0042755f
    mov ecx, dword ptr [ebp - local_10]          # 00427563
    add ecx, 0xb5b60                             # 00427566
    call FUN_0047e23e                            # 0042756c
    mov byte ptr [ebp - local_4], 0x41           # 00427571
    mov ecx, dword ptr [ebp - local_10]          # 00427575
    add ecx, 0xb4f25                             # 00427578
    call FUN_00483f4e                            # 0042757e
    mov byte ptr [ebp - local_4], 0x40           # 00427583
    mov ecx, dword ptr [ebp - local_10]          # 00427587
    add ecx, 0xb4a41                             # 0042758a
    call FUN_0048e26e                            # 00427590
    mov byte ptr [ebp - local_4], 0x3f           # 00427595
    mov ecx, dword ptr [ebp - local_10]          # 00427599
    add ecx, 0xb498a                             # 0042759c
    call FUN_0048215e                            # 004275a2
    mov byte ptr [ebp - local_4], 0x3e           # 004275a7
    mov ecx, dword ptr [ebp - local_10]          # 004275ab
    add ecx, 0xb4937                             # 004275ae
    call FUN_0044d0eb                            # 004275b4
    mov byte ptr [ebp - local_4], 0x3d           # 004275b9
    mov ecx, dword ptr [ebp - local_10]          # 004275bd
    add ecx, 0xb48a2                             # 004275c0
    call FUN_0046e66a                            # 004275c6
    mov byte ptr [ebp - local_4], 0x3c           # 004275cb
    mov ecx, dword ptr [ebp - local_10]          # 004275cf
    add ecx, 0xb47c8                             # 004275d2
    call FUN_00463ffe                            # 004275d8
    mov byte ptr [ebp - local_4], 0x3b           # 004275dd
    mov ecx, dword ptr [ebp - local_10]          # 004275e1
    add ecx, 0xb4654                             # 004275e4
    call FUN_00454d6e                            # 004275ea
    mov byte ptr [ebp - local_4], 0x3a           # 004275ef
    mov ecx, dword ptr [ebp - local_10]          # 004275f3
    add ecx, 0xb4618                             # 004275f6
    call FUN_004b71db                            # 004275fc
    mov byte ptr [ebp - local_4], 0x39           # 00427601
    mov ecx, dword ptr [ebp - local_10]          # 00427605
    add ecx, 0xb45a9                             # 00427608
    call FUN_0044e74b                            # 0042760e
    mov byte ptr [ebp - local_4], 0x38           # 00427613
    mov ecx, dword ptr [ebp - local_10]          # 00427617
    add ecx, 0xb4565                             # 0042761a
    call FUN_00456ceb                            # 00427620
    mov byte ptr [ebp - local_4], 0x37           # 00427625
    mov ecx, dword ptr [ebp - local_10]          # 00427629
    add ecx, 0xb43ac                             # 0042762c
    call FUN_0045b3ce                            # 00427632
    mov byte ptr [ebp - local_4], 0x36           # 00427637
    mov ecx, dword ptr [ebp - local_10]          # 0042763b
    add ecx, 0xb4354                             # 0042763e
    call FUN_0047d4db                            # 00427644
    mov byte ptr [ebp - local_4], 0x35           # 00427649
    mov ecx, dword ptr [ebp - local_10]          # 0042764d
    add ecx, 0xb42fe                             # 00427650
    call FUN_0048bafb                            # 00427656
    mov byte ptr [ebp - local_4], 0x34           # 0042765b
    mov ecx, dword ptr [ebp - local_10]          # 0042765f
    add ecx, 0xb34f4                             # 00427662
    call FUN_00470d5e                            # 00427668
    mov byte ptr [ebp - local_4], 0x33           # 0042766d
    mov ecx, dword ptr [ebp - local_10]          # 00427671
    add ecx, 0xb2c1a                             # 00427674
    call FUN_004757be                            # 0042767a
    mov byte ptr [ebp - local_4], 0x32           # 0042767f
    mov ecx, dword ptr [ebp - local_10]          # 00427683
    add ecx, 0xb167a                             # 00427686
    call FUN_004781de                            # 0042768c
    mov byte ptr [ebp - local_4], 0x31           # 00427691
    mov ecx, dword ptr [ebp - local_10]          # 00427695
    add ecx, 0xb0139                             # 00427698
    call FUN_004afd1e                            # 0042769e
    mov byte ptr [ebp - local_4], 0x30           # 004276a3
    mov ecx, dword ptr [ebp - local_10]          # 004276a7
    add ecx, 0xafe71                             # 004276aa
    call FUN_004bed99                            # 004276b0
    mov byte ptr [ebp - local_4], 0x2f           # 004276b5
    mov ecx, dword ptr [ebp - local_10]          # 004276b9
    add ecx, 0xaf4dc                             # 004276bc
    call FUN_004de1a4                            # 004276c2
    mov byte ptr [ebp - local_4], 0x2e           # 004276c7
    mov ecx, dword ptr [ebp - local_10]          # 004276cb
    add ecx, 0xaf4d8                             # 004276ce
    call FUN_0044bea7                            # 004276d4
    mov byte ptr [ebp - local_4], 0x2d           # 004276d9
    mov ecx, dword ptr [ebp - local_10]          # 004276dd
    add ecx, 0xaf129                             # 004276e0
    call FUN_0045dc6e                            # 004276e6
    mov byte ptr [ebp - local_4], 0x2c           # 004276eb
    mov ecx, dword ptr [ebp - local_10]          # 004276ef
    add ecx, 0xaeae6                             # 004276f2
    call FUN_004b7f1f                            # 004276f8
    mov byte ptr [ebp - local_4], 0x2b           # 004276fd
    mov ecx, dword ptr [ebp - local_10]          # 00427701
    add ecx, 0xae9f3                             # 00427704
    call FUN_00457f5e                            # 0042770a
    mov byte ptr [ebp - local_4], 0x2a           # 0042770f
    mov ecx, dword ptr [ebp - local_10]          # 00427713
    add ecx, 0xae5d4                             # 00427716
    call FUN_00472f95                            # 0042771c
    mov byte ptr [ebp - local_4], 0x29           # 00427721
    mov ecx, dword ptr [ebp - local_10]          # 00427725
    add ecx, 0xae2d4                             # 00427728
    call FUN_004674ff                            # 0042772e
    mov byte ptr [ebp - local_4], 0x28           # 00427733
    mov ecx, dword ptr [ebp - local_10]          # 00427737
    add ecx, 0xae010                             # 0042773a
    call FUN_0047b21f                            # 00427740
    mov byte ptr [ebp - local_4], 0x27           # 00427745
    mov ecx, dword ptr [ebp - local_10]          # 00427749
    add ecx, 0xadbce                             # 0042774c
    call FUN_004b9e1f                            # 00427752
    mov byte ptr [ebp - local_4], 0x26           # 00427757
    mov ecx, dword ptr [ebp - local_10]          # 0042775b
    add ecx, 0xad4eb                             # 0042775e
    call FUN_0044f66f                            # 00427764
    mov byte ptr [ebp - local_4], 0x25           # 00427769
    mov ecx, dword ptr [ebp - local_10]          # 0042776d
    add ecx, 0xad450                             # 00427770
    call FUN_00487afe                            # 00427776
    mov byte ptr [ebp - local_4], 0x24           # 0042777b
    mov ecx, dword ptr [ebp - local_10]          # 0042777f
    add ecx, 0xad3f1                             # 00427782
    call FUN_0046180b                            # 00427788
    mov byte ptr [ebp - local_4], 0x23           # 0042778d
    mov ecx, dword ptr [ebp - local_10]          # 00427791
    add ecx, 0xad39b                             # 00427794
    call FUN_00465aeb                            # 0042779a
    mov byte ptr [ebp - local_4], 0x22           # 0042779f
    mov ecx, dword ptr [ebp - local_10]          # 004277a3
    add ecx, 0xad339                             # 004277a6
    call FUN_004ab38b                            # 004277ac
    mov byte ptr [ebp - local_4], 0x21           # 004277b1
    mov ecx, dword ptr [ebp - local_10]          # 004277b5
    add ecx, 0xad0c1                             # 004277b8
    call FUN_004b5b6e                            # 004277be
    mov byte ptr [ebp - local_4], 0x20           # 004277c3
    mov ecx, dword ptr [ebp - local_10]          # 004277c7
    add ecx, 0xad019                             # 004277ca
    call FUN_004a636e                            # 004277d0
    mov byte ptr [ebp - local_4], 0x1f           # 004277d5
    mov ecx, dword ptr [ebp - local_10]          # 004277d9
    add ecx, 0xacfbd                             # 004277dc
    call FUN_0048d04b                            # 004277e2
    mov byte ptr [ebp - local_4], 0x1e           # 004277e7
    mov ecx, dword ptr [ebp - local_10]          # 004277eb
    add ecx, 0xacf55                             # 004277ee
    call FUN_004a1c2b                            # 004277f4
    mov byte ptr [ebp - local_4], 0x1d           # 004277f9
    mov ecx, dword ptr [ebp - local_10]          # 004277fd
    add ecx, 0xacd87                             # 00427800
    call FUN_0048a6ee                            # 00427806
    mov byte ptr [ebp - local_4], 0x1c           # 0042780b
    mov ecx, dword ptr [ebp - local_10]          # 0042780f
    add ecx, 0xac547                             # 00427812
    call FUN_004a376e                            # 00427818
    mov byte ptr [ebp - local_4], 0x1b           # 0042781d
    mov ecx, dword ptr [ebp - local_10]          # 00427821
    add ecx, 0xac465                             # 00427824
    call FUN_00459ace                            # 0042782a
    mov byte ptr [ebp - local_4], 0x1a           # 0042782f
    mov ecx, dword ptr [ebp - local_10]          # 00427833
    add ecx, 0xabfff                             # 00427836
    call FUN_004d3b6e                            # 0042783c
    mov byte ptr [ebp - local_4], 0x19           # 00427841
    mov ecx, dword ptr [ebp - local_10]          # 00427845
    add ecx, 0xa96b9                             # 00427848
    call FUN_004110d7                            # 0042784e
    mov byte ptr [ebp - local_4], 0x18           # 00427853
    mov ecx, dword ptr [ebp - local_10]          # 00427857
    add ecx, 0xa967d                             # 0042785a
    call FUN_0044883f                            # 00427860
    mov byte ptr [ebp - local_4], 0x17           # 00427865
    mov ecx, dword ptr [ebp - local_10]          # 00427869
    add ecx, 0xa95ad                             # 0042786c
    call FUN_00488d89                            # 00427872
    mov byte ptr [ebp - local_4], 0x16           # 00427877
    mov ecx, dword ptr [ebp - local_10]          # 0042787b
    add ecx, 0xa954f                             # 0042787e
    call FUN_00446faa                            # 00427884
    mov byte ptr [ebp - local_4], 0x15           # 00427889
    mov ecx, dword ptr [ebp - local_10]          # 0042788d
    add ecx, 0xa7460                             # 00427890
    call FUN_0041bebc                            # 00427896
    mov byte ptr [ebp - local_4], 0x14           # 0042789b
    mov ecx, dword ptr [ebp - local_10]          # 0042789f
    add ecx, 0xa6cde                             # 004278a2
    call FUN_004b3c3e                            # 004278a8
    mov byte ptr [ebp - local_4], 0x13           # 004278ad
    mov ecx, dword ptr [ebp - local_10]          # 004278b1
    add ecx, 0xa672a                             # 004278b4
    call FUN_00468e3e                            # 004278ba
    mov byte ptr [ebp - local_4], 0x12           # 004278bf
    mov ecx, dword ptr [ebp - local_10]          # 004278c3
    add ecx, 0xa63f7                             # 004278c6
    call FUN_004dd3cf                            # 004278cc
    mov byte ptr [ebp - local_4], 0x11           # 004278d1
    mov ecx, dword ptr [ebp - local_10]          # 004278d5
    add ecx, 0x72ae8                             # 004278d8
    call FUN_004d58cf                            # 004278de
    mov byte ptr [ebp - local_4], 0x10           # 004278e3
    mov ecx, dword ptr [ebp - local_10]          # 004278e7
    add ecx, 0x72a36                             # 004278ea
    call FUN_00414ccf                            # 004278f0
    mov byte ptr [ebp - local_4], 0xf            # 004278f5
    mov ecx, dword ptr [ebp - local_10]          # 004278f9
    add ecx, 0x62ba9                             # 004278fc
    call FUN_00416f2d                            # 00427902
    mov byte ptr [ebp - local_4], 0xe            # 00427907
    mov ecx, dword ptr [ebp - local_10]          # 0042790b
    add ecx, 0x62ba5                             # 0042790e
    call FUN_0043ef27                            # 00427914
    mov byte ptr [ebp - local_4], 0xd            # 00427919
    mov ecx, dword ptr [ebp - local_10]          # 0042791d
    add ecx, 0x5f2d1                             # 00427920
    call FUN_004c139a                            # 00427926
    mov byte ptr [ebp - local_4], 0xc            # 0042792b
    mov ecx, dword ptr [ebp - local_10]          # 0042792f
    add ecx, 0x536df                             # 00427932
    call FUN_004fa9e7                            # 00427938
    mov byte ptr [ebp - local_4], 0xb            # 0042793d
    mov ecx, dword ptr [ebp - local_10]          # 00427941
    add ecx, 0x135f1                             # 00427944
    call FUN_00426346                            # 0042794a
    mov byte ptr [ebp - local_4], 0xa            # 0042794f
    mov ecx, dword ptr [ebp - local_10]          # 00427953
    add ecx, 0x12ead                             # 00427956
    call FUN_004de66e                            # 0042795c
    mov byte ptr [ebp - local_4], 0x9            # 00427961
    mov ecx, dword ptr [ebp - local_10]          # 00427965
    add ecx, 0x12e80                             # 00427968
    call FUN_0043772f                            # 0042796e
    mov byte ptr [ebp - local_4], 0x8            # 00427973
    mov ecx, dword ptr [ebp - local_10]          # 00427977
    add ecx, 0x12e78                             # 0042797a
    call FUN_00447d2f                            # 00427980
    mov byte ptr [ebp - local_4], 0x7            # 00427985
    mov ecx, dword ptr [ebp - local_10]          # 00427989
    add ecx, 0x12dfa                             # 0042798c
    call FUN_004f001f                            # 00427992
    mov byte ptr [ebp - local_4], 0x6            # 00427997
    mov ecx, dword ptr [ebp - local_10]          # 0042799b
    add ecx, 0x12d46                             # 0042799e
    call FUN_004db27f                            # 004279a4
    mov byte ptr [ebp - local_4], 0x5            # 004279a9
    mov ecx, dword ptr [ebp - local_10]          # 004279ad
    add ecx, 0x12389                             # 004279b0
    call FUN_004e7684                            # 004279b6
    mov byte ptr [ebp - local_4], 0x4            # 004279bb
    mov ecx, dword ptr [ebp - local_10]          # 004279bf
    add ecx, 0xf9ac                              # 004279c2
    call FUN_004eb8fe                            # 004279c8
    mov byte ptr [ebp - local_4], 0x3            # 004279cd
    mov ecx, dword ptr [ebp - local_10]          # 004279d1
    add ecx, 0x93d4                              # 004279d4
    call FUN_004e2d63                            # 004279da
    mov byte ptr [ebp - local_4], 0x2            # 004279df
    mov ecx, dword ptr [ebp - local_10]          # 004279e3
    add ecx, 0x10ba                              # 004279e6
    call FUN_004e7b37                            # 004279ec
    mov byte ptr [ebp - local_4], 0x1            # 004279f1
    mov ecx, dword ptr [ebp - local_10]          # 004279f5
    add ecx, 0x180                               # 004279f8
    call FUN_004e048f                            # 004279fe
    mov byte ptr [ebp - local_4], 0x0            # 00427a03
    mov ecx, dword ptr [ebp - local_10]          # 00427a07
    add ecx, 0xc8                                # 00427a0a
    call FUN_004d527f                            # 00427a10
    mov dword ptr [ebp - local_4], 0xffffffff    # 00427a15
    mov ecx, dword ptr [ebp - local_10]          # 00427a1c
    call FUN_00524e1f                            # 00427a1f
    mov ecx, dword ptr [ebp - local_c]           # 00427a24
    mov dword ptr fs:[0x0], ecx                  # 00427a27
    {load} mov esp, ebp                          # 00427a2e
    pop ebp                                      # 00427a30
    ret                                          # 00427a31

# --- data items (not part of the function) -------------------------
.org 0x00427a32 - 0x401000
PAD_00427a32:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

