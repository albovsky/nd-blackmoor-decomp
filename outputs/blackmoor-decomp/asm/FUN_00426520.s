# FUN_00426520
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426520
# extent:       0x00426520-0x00426b4e (1582 code bytes)
# span:         0x00426520-0x00426b4e (code 1582, tables 0, padding 0)
# sha256:       480e588e60d1c4fee21accebf3c5b7b4a5b876d7350366d712355231bae44a7f
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426520_lifted
# naming:       native port src/original_methods_fl40.c:m426520_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 356/356 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00524c59, FUN_004d5260, FUN_004e0410, FUN_004e7a70, FUN_004e2ce0, FUN_004eb870, FUN_004e7630, FUN_004db260, FUN_004f0000, FUN_00447d10, FUN_00437710, FUN_004de5f0, FUN_00426300, FUN_004fa980, FUN_004f2640, FUN_004c0f70 and 69 more
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426520_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 356 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00411080, .text + (0x00411080 - 0x401000)
.set FUN_00414537, .text + (0x00414537 - 0x401000)
.set FUN_00414cb0, .text + (0x00414cb0 - 0x401000)
.set FUN_00416e90, .text + (0x00416e90 - 0x401000)
.set FUN_0041be1a, .text + (0x0041be1a - 0x401000)
.set FUN_00423450, .text + (0x00423450 - 0x401000)
.set FUN_00426300, .text + (0x00426300 - 0x401000)
.set FUN_00437710, .text + (0x00437710 - 0x401000)
.set FUN_0043ef10, .text + (0x0043ef10 - 0x401000)
.set FUN_00445df0, .text + (0x00445df0 - 0x401000)
.set FUN_00446f77, .text + (0x00446f77 - 0x401000)
.set FUN_00447d10, .text + (0x00447d10 - 0x401000)
.set FUN_00447e27, .text + (0x00447e27 - 0x401000)
.set FUN_00448820, .text + (0x00448820 - 0x401000)
.set FUN_0044afb7, .text + (0x0044afb7 - 0x401000)
.set FUN_0044be90, .text + (0x0044be90 - 0x401000)
.set FUN_0044d097, .text + (0x0044d097 - 0x401000)
.set FUN_0044e6f7, .text + (0x0044e6f7 - 0x401000)
.set FUN_0044f650, .text + (0x0044f650 - 0x401000)
.set FUN_00454d1a, .text + (0x00454d1a - 0x401000)
.set FUN_00456c97, .text + (0x00456c97 - 0x401000)
.set FUN_00457f0a, .text + (0x00457f0a - 0x401000)
.set FUN_00459a7a, .text + (0x00459a7a - 0x401000)
.set FUN_0045b37a, .text + (0x0045b37a - 0x401000)
.set FUN_0045dc1a, .text + (0x0045dc1a - 0x401000)
.set FUN_004617b7, .text + (0x004617b7 - 0x401000)
.set FUN_00463faa, .text + (0x00463faa - 0x401000)
.set FUN_00465a97, .text + (0x00465a97 - 0x401000)
.set FUN_004674e0, .text + (0x004674e0 - 0x401000)
.set FUN_00468dea, .text + (0x00468dea - 0x401000)
.set FUN_0046b51a, .text + (0x0046b51a - 0x401000)
.set FUN_0046e5fa, .text + (0x0046e5fa - 0x401000)
.set FUN_00470d0a, .text + (0x00470d0a - 0x401000)
.set FUN_00472f21, .text + (0x00472f21 - 0x401000)
.set FUN_0047576a, .text + (0x0047576a - 0x401000)
.set FUN_0047818a, .text + (0x0047818a - 0x401000)
.set FUN_0047b200, .text + (0x0047b200 - 0x401000)
.set FUN_0047d487, .text + (0x0047d487 - 0x401000)
.set FUN_0047e1ea, .text + (0x0047e1ea - 0x401000)
.set FUN_0048210a, .text + (0x0048210a - 0x401000)
.set FUN_00483efa, .text + (0x00483efa - 0x401000)
.set FUN_00487aaa, .text + (0x00487aaa - 0x401000)
.set FUN_00488d6a, .text + (0x00488d6a - 0x401000)
.set FUN_0048a69a, .text + (0x0048a69a - 0x401000)
.set FUN_0048baa7, .text + (0x0048baa7 - 0x401000)
.set FUN_0048cff7, .text + (0x0048cff7 - 0x401000)
.set FUN_0048e21a, .text + (0x0048e21a - 0x401000)
.set FUN_004904fa, .text + (0x004904fa - 0x401000)
.set FUN_0049c53a, .text + (0x0049c53a - 0x401000)
.set FUN_004a1bd7, .text + (0x004a1bd7 - 0x401000)
.set FUN_004a371a, .text + (0x004a371a - 0x401000)
.set FUN_004a631a, .text + (0x004a631a - 0x401000)
.set FUN_004a7c0a, .text + (0x004a7c0a - 0x401000)
.set FUN_004a9eb7, .text + (0x004a9eb7 - 0x401000)
.set FUN_004ab337, .text + (0x004ab337 - 0x401000)
.set FUN_004ac86a, .text + (0x004ac86a - 0x401000)
.set FUN_004afcca, .text + (0x004afcca - 0x401000)
.set FUN_004b3bea, .text + (0x004b3bea - 0x401000)
.set FUN_004b5b1a, .text + (0x004b5b1a - 0x401000)
.set FUN_004b7187, .text + (0x004b7187 - 0x401000)
.set FUN_004b7f00, .text + (0x004b7f00 - 0x401000)
.set FUN_004b9e00, .text + (0x004b9e00 - 0x401000)
.set FUN_004bed70, .text + (0x004bed70 - 0x401000)
.set FUN_004bf600, .text + (0x004bf600 - 0x401000)
.set FUN_004c0f70, .text + (0x004c0f70 - 0x401000)
.set FUN_004caed0, .text + (0x004caed0 - 0x401000)
.set FUN_004cc927, .text + (0x004cc927 - 0x401000)
.set FUN_004ccd70, .text + (0x004ccd70 - 0x401000)
.set FUN_004d3b1a, .text + (0x004d3b1a - 0x401000)
.set FUN_004d5260, .text + (0x004d5260 - 0x401000)
.set FUN_004d58b0, .text + (0x004d58b0 - 0x401000)
.set FUN_004db260, .text + (0x004db260 - 0x401000)
.set FUN_004dbf1a, .text + (0x004dbf1a - 0x401000)
.set FUN_004dd3b0, .text + (0x004dd3b0 - 0x401000)
.set FUN_004de150, .text + (0x004de150 - 0x401000)
.set FUN_004de5f0, .text + (0x004de5f0 - 0x401000)
.set FUN_004e0410, .text + (0x004e0410 - 0x401000)
.set FUN_004e2ce0, .text + (0x004e2ce0 - 0x401000)
.set FUN_004e7630, .text + (0x004e7630 - 0x401000)
.set FUN_004e7a70, .text + (0x004e7a70 - 0x401000)
.set FUN_004eb870, .text + (0x004eb870 - 0x401000)
.set FUN_004f0000, .text + (0x004f0000 - 0x401000)
.set FUN_004f2640, .text + (0x004f2640 - 0x401000)
.set FUN_004fa980, .text + (0x004fa980 - 0x401000)
.set FUN_00524c59, .text + (0x00524c59 - 0x401000)

.org 0x00426520 - 0x401000
.globl FUN_00426520
FUN_00426520:
    # block 0x00426520: entry, 356 instruction(s), calls FUN_00524c59, FUN_004d5260, FUN_004e0410, FUN_004e7a70, FUN_004e2ce0, FUN_004eb870, FUN_004e7630,..., ends with ret
    push ebp                                     # 00426520
    {load} mov ebp, esp                          # 00426521
    push -0x1                                    # 00426523
    push 0x5278e7                                # 00426525
    mov eax, dword ptr fs:[0x0]                  # 0042652a
    push eax                                     # 00426530
    mov dword ptr fs:[0x0], esp                  # 00426531
    push ecx                                     # 00426538
    mov dword ptr [ebp - local_10], ecx          # 00426539
    push 0x0                                     # 0042653c
    mov ecx, dword ptr [ebp - local_10]          # 0042653e
    call FUN_00524c59                            # 00426541
    mov dword ptr [ebp - local_4], 0x0           # 00426546
    mov ecx, dword ptr [ebp - local_10]          # 0042654d
    add ecx, 0xc8                                # 00426550
    call FUN_004d5260                            # 00426556
    mov byte ptr [ebp - local_4], 0x1            # 0042655b
    mov ecx, dword ptr [ebp - local_10]          # 0042655f
    add ecx, 0x180                               # 00426562
    call FUN_004e0410                            # 00426568
    mov byte ptr [ebp - local_4], 0x2            # 0042656d
    mov ecx, dword ptr [ebp - local_10]          # 00426571
    add ecx, 0x10ba                              # 00426574
    call FUN_004e7a70                            # 0042657a
    mov byte ptr [ebp - local_4], 0x3            # 0042657f
    mov ecx, dword ptr [ebp - local_10]          # 00426583
    add ecx, 0x93d4                              # 00426586
    call FUN_004e2ce0                            # 0042658c
    mov byte ptr [ebp - local_4], 0x4            # 00426591
    mov ecx, dword ptr [ebp - local_10]          # 00426595
    add ecx, 0xf9ac                              # 00426598
    call FUN_004eb870                            # 0042659e
    mov byte ptr [ebp - local_4], 0x5            # 004265a3
    mov ecx, dword ptr [ebp - local_10]          # 004265a7
    add ecx, 0x12389                             # 004265aa
    call FUN_004e7630                            # 004265b0
    mov byte ptr [ebp - local_4], 0x6            # 004265b5
    mov ecx, dword ptr [ebp - local_10]          # 004265b9
    add ecx, 0x12d46                             # 004265bc
    call FUN_004db260                            # 004265c2
    mov byte ptr [ebp - local_4], 0x7            # 004265c7
    mov ecx, dword ptr [ebp - local_10]          # 004265cb
    add ecx, 0x12dfa                             # 004265ce
    call FUN_004f0000                            # 004265d4
    mov byte ptr [ebp - local_4], 0x8            # 004265d9
    mov ecx, dword ptr [ebp - local_10]          # 004265dd
    add ecx, 0x12e78                             # 004265e0
    call FUN_00447d10                            # 004265e6
    mov byte ptr [ebp - local_4], 0x9            # 004265eb
    mov ecx, dword ptr [ebp - local_10]          # 004265ef
    add ecx, 0x12e80                             # 004265f2
    call FUN_00437710                            # 004265f8
    mov byte ptr [ebp - local_4], 0xa            # 004265fd
    mov ecx, dword ptr [ebp - local_10]          # 00426601
    add ecx, 0x12ead                             # 00426604
    call FUN_004de5f0                            # 0042660a
    mov byte ptr [ebp - local_4], 0xb            # 0042660f
    mov ecx, dword ptr [ebp - local_10]          # 00426613
    add ecx, 0x135f1                             # 00426616
    call FUN_00426300                            # 0042661c
    mov byte ptr [ebp - local_4], 0xc            # 00426621
    mov ecx, dword ptr [ebp - local_10]          # 00426625
    add ecx, 0x536df                             # 00426628
    call FUN_004fa980                            # 0042662e
    mov byte ptr [ebp - local_4], 0xd            # 00426633
    mov ecx, dword ptr [ebp - local_10]          # 00426637
    add ecx, 0x5ee63                             # 0042663a
    call FUN_004f2640                            # 00426640
    mov ecx, dword ptr [ebp - local_10]          # 00426645
    add ecx, 0x5f2d1                             # 00426648
    call FUN_004c0f70                            # 0042664e
    mov byte ptr [ebp - local_4], 0xe            # 00426653
    mov ecx, dword ptr [ebp - local_10]          # 00426657
    add ecx, 0x62ba5                             # 0042665a
    call FUN_0043ef10                            # 00426660
    mov byte ptr [ebp - local_4], 0xf            # 00426665
    mov ecx, dword ptr [ebp - local_10]          # 00426669
    add ecx, 0x62ba9                             # 0042666c
    call FUN_00416e90                            # 00426672
    mov byte ptr [ebp - local_4], 0x10           # 00426677
    mov ecx, dword ptr [ebp - local_10]          # 0042667b
    add ecx, 0x72a36                             # 0042667e
    call FUN_00414cb0                            # 00426684
    mov byte ptr [ebp - local_4], 0x11           # 00426689
    mov ecx, dword ptr [ebp - local_10]          # 0042668d
    add ecx, 0x72ae8                             # 00426690
    call FUN_004d58b0                            # 00426696
    mov byte ptr [ebp - local_4], 0x12           # 0042669b
    mov ecx, dword ptr [ebp - local_10]          # 0042669f
    add ecx, 0xa63f7                             # 004266a2
    call FUN_004dd3b0                            # 004266a8
    mov byte ptr [ebp - local_4], 0x13           # 004266ad
    mov ecx, dword ptr [ebp - local_10]          # 004266b1
    add ecx, 0xa672a                             # 004266b4
    call FUN_00468dea                            # 004266ba
    mov byte ptr [ebp - local_4], 0x14           # 004266bf
    mov ecx, dword ptr [ebp - local_10]          # 004266c3
    add ecx, 0xa6cde                             # 004266c6
    call FUN_004b3bea                            # 004266cc
    mov byte ptr [ebp - local_4], 0x15           # 004266d1
    mov ecx, dword ptr [ebp - local_10]          # 004266d5
    add ecx, 0xa7460                             # 004266d8
    call FUN_0041be1a                            # 004266de
    mov byte ptr [ebp - local_4], 0x16           # 004266e3
    mov ecx, dword ptr [ebp - local_10]          # 004266e7
    add ecx, 0xa954f                             # 004266ea
    call FUN_00446f77                            # 004266f0
    mov byte ptr [ebp - local_4], 0x17           # 004266f5
    mov ecx, dword ptr [ebp - local_10]          # 004266f9
    add ecx, 0xa95ad                             # 004266fc
    call FUN_00488d6a                            # 00426702
    mov byte ptr [ebp - local_4], 0x18           # 00426707
    mov ecx, dword ptr [ebp - local_10]          # 0042670b
    add ecx, 0xa967d                             # 0042670e
    call FUN_00448820                            # 00426714
    mov byte ptr [ebp - local_4], 0x19           # 00426719
    mov ecx, dword ptr [ebp - local_10]          # 0042671d
    add ecx, 0xa96b9                             # 00426720
    call FUN_00411080                            # 00426726
    mov byte ptr [ebp - local_4], 0x1a           # 0042672b
    mov ecx, dword ptr [ebp - local_10]          # 0042672f
    add ecx, 0xabfff                             # 00426732
    call FUN_004d3b1a                            # 00426738
    mov byte ptr [ebp - local_4], 0x1b           # 0042673d
    mov ecx, dword ptr [ebp - local_10]          # 00426741
    add ecx, 0xac465                             # 00426744
    call FUN_00459a7a                            # 0042674a
    mov byte ptr [ebp - local_4], 0x1c           # 0042674f
    mov ecx, dword ptr [ebp - local_10]          # 00426753
    add ecx, 0xac547                             # 00426756
    call FUN_004a371a                            # 0042675c
    mov byte ptr [ebp - local_4], 0x1d           # 00426761
    mov ecx, dword ptr [ebp - local_10]          # 00426765
    add ecx, 0xacd87                             # 00426768
    call FUN_0048a69a                            # 0042676e
    mov byte ptr [ebp - local_4], 0x1e           # 00426773
    mov ecx, dword ptr [ebp - local_10]          # 00426777
    add ecx, 0xacf55                             # 0042677a
    call FUN_004a1bd7                            # 00426780
    mov byte ptr [ebp - local_4], 0x1f           # 00426785
    mov ecx, dword ptr [ebp - local_10]          # 00426789
    add ecx, 0xacfbd                             # 0042678c
    call FUN_0048cff7                            # 00426792
    mov byte ptr [ebp - local_4], 0x20           # 00426797
    mov ecx, dword ptr [ebp - local_10]          # 0042679b
    add ecx, 0xad019                             # 0042679e
    call FUN_004a631a                            # 004267a4
    mov byte ptr [ebp - local_4], 0x21           # 004267a9
    mov ecx, dword ptr [ebp - local_10]          # 004267ad
    add ecx, 0xad0c1                             # 004267b0
    call FUN_004b5b1a                            # 004267b6
    mov byte ptr [ebp - local_4], 0x22           # 004267bb
    mov ecx, dword ptr [ebp - local_10]          # 004267bf
    add ecx, 0xad339                             # 004267c2
    call FUN_004ab337                            # 004267c8
    mov byte ptr [ebp - local_4], 0x23           # 004267cd
    mov ecx, dword ptr [ebp - local_10]          # 004267d1
    add ecx, 0xad39b                             # 004267d4
    call FUN_00465a97                            # 004267da
    mov byte ptr [ebp - local_4], 0x24           # 004267df
    mov ecx, dword ptr [ebp - local_10]          # 004267e3
    add ecx, 0xad3f1                             # 004267e6
    call FUN_004617b7                            # 004267ec
    mov byte ptr [ebp - local_4], 0x25           # 004267f1
    mov ecx, dword ptr [ebp - local_10]          # 004267f5
    add ecx, 0xad450                             # 004267f8
    call FUN_00487aaa                            # 004267fe
    mov byte ptr [ebp - local_4], 0x26           # 00426803
    mov ecx, dword ptr [ebp - local_10]          # 00426807
    add ecx, 0xad4eb                             # 0042680a
    call FUN_0044f650                            # 00426810
    mov byte ptr [ebp - local_4], 0x27           # 00426815
    mov ecx, dword ptr [ebp - local_10]          # 00426819
    add ecx, 0xadbce                             # 0042681c
    call FUN_004b9e00                            # 00426822
    mov byte ptr [ebp - local_4], 0x28           # 00426827
    mov ecx, dword ptr [ebp - local_10]          # 0042682b
    add ecx, 0xae010                             # 0042682e
    call FUN_0047b200                            # 00426834
    mov byte ptr [ebp - local_4], 0x29           # 00426839
    mov ecx, dword ptr [ebp - local_10]          # 0042683d
    add ecx, 0xae2d4                             # 00426840
    call FUN_004674e0                            # 00426846
    mov byte ptr [ebp - local_4], 0x2a           # 0042684b
    mov ecx, dword ptr [ebp - local_10]          # 0042684f
    add ecx, 0xae5d4                             # 00426852
    call FUN_00472f21                            # 00426858
    mov byte ptr [ebp - local_4], 0x2b           # 0042685d
    mov ecx, dword ptr [ebp - local_10]          # 00426861
    add ecx, 0xae9f3                             # 00426864
    call FUN_00457f0a                            # 0042686a
    mov byte ptr [ebp - local_4], 0x2c           # 0042686f
    mov ecx, dword ptr [ebp - local_10]          # 00426873
    add ecx, 0xaeae6                             # 00426876
    call FUN_004b7f00                            # 0042687c
    mov byte ptr [ebp - local_4], 0x2d           # 00426881
    mov ecx, dword ptr [ebp - local_10]          # 00426885
    add ecx, 0xaf129                             # 00426888
    call FUN_0045dc1a                            # 0042688e
    mov byte ptr [ebp - local_4], 0x2e           # 00426893
    mov ecx, dword ptr [ebp - local_10]          # 00426897
    add ecx, 0xaf4d8                             # 0042689a
    call FUN_0044be90                            # 004268a0
    mov byte ptr [ebp - local_4], 0x2f           # 004268a5
    mov ecx, dword ptr [ebp - local_10]          # 004268a9
    add ecx, 0xaf4dc                             # 004268ac
    call FUN_004de150                            # 004268b2
    mov byte ptr [ebp - local_4], 0x30           # 004268b7
    mov ecx, dword ptr [ebp - local_10]          # 004268bb
    add ecx, 0xafe71                             # 004268be
    call FUN_004bed70                            # 004268c4
    mov byte ptr [ebp - local_4], 0x31           # 004268c9
    mov ecx, dword ptr [ebp - local_10]          # 004268cd
    add ecx, 0xb0139                             # 004268d0
    call FUN_004afcca                            # 004268d6
    mov byte ptr [ebp - local_4], 0x32           # 004268db
    mov ecx, dword ptr [ebp - local_10]          # 004268df
    add ecx, 0xb167a                             # 004268e2
    call FUN_0047818a                            # 004268e8
    mov byte ptr [ebp - local_4], 0x33           # 004268ed
    mov ecx, dword ptr [ebp - local_10]          # 004268f1
    add ecx, 0xb2c1a                             # 004268f4
    call FUN_0047576a                            # 004268fa
    mov byte ptr [ebp - local_4], 0x34           # 004268ff
    mov ecx, dword ptr [ebp - local_10]          # 00426903
    add ecx, 0xb34f4                             # 00426906
    call FUN_00470d0a                            # 0042690c
    mov byte ptr [ebp - local_4], 0x35           # 00426911
    mov ecx, dword ptr [ebp - local_10]          # 00426915
    add ecx, 0xb42fe                             # 00426918
    call FUN_0048baa7                            # 0042691e
    mov byte ptr [ebp - local_4], 0x36           # 00426923
    mov ecx, dword ptr [ebp - local_10]          # 00426927
    add ecx, 0xb4354                             # 0042692a
    call FUN_0047d487                            # 00426930
    mov byte ptr [ebp - local_4], 0x37           # 00426935
    mov ecx, dword ptr [ebp - local_10]          # 00426939
    add ecx, 0xb43ac                             # 0042693c
    call FUN_0045b37a                            # 00426942
    mov byte ptr [ebp - local_4], 0x38           # 00426947
    mov ecx, dword ptr [ebp - local_10]          # 0042694b
    add ecx, 0xb4565                             # 0042694e
    call FUN_00456c97                            # 00426954
    mov byte ptr [ebp - local_4], 0x39           # 00426959
    mov ecx, dword ptr [ebp - local_10]          # 0042695d
    add ecx, 0xb45a9                             # 00426960
    call FUN_0044e6f7                            # 00426966
    mov byte ptr [ebp - local_4], 0x3a           # 0042696b
    mov ecx, dword ptr [ebp - local_10]          # 0042696f
    add ecx, 0xb4618                             # 00426972
    call FUN_004b7187                            # 00426978
    mov byte ptr [ebp - local_4], 0x3b           # 0042697d
    mov ecx, dword ptr [ebp - local_10]          # 00426981
    add ecx, 0xb4654                             # 00426984
    call FUN_00454d1a                            # 0042698a
    mov byte ptr [ebp - local_4], 0x3c           # 0042698f
    mov ecx, dword ptr [ebp - local_10]          # 00426993
    add ecx, 0xb47c8                             # 00426996
    call FUN_00463faa                            # 0042699c
    mov byte ptr [ebp - local_4], 0x3d           # 004269a1
    mov ecx, dword ptr [ebp - local_10]          # 004269a5
    add ecx, 0xb48a2                             # 004269a8
    call FUN_0046e5fa                            # 004269ae
    mov byte ptr [ebp - local_4], 0x3e           # 004269b3
    mov ecx, dword ptr [ebp - local_10]          # 004269b7
    add ecx, 0xb4937                             # 004269ba
    call FUN_0044d097                            # 004269c0
    mov byte ptr [ebp - local_4], 0x3f           # 004269c5
    mov ecx, dword ptr [ebp - local_10]          # 004269c9
    add ecx, 0xb498a                             # 004269cc
    call FUN_0048210a                            # 004269d2
    mov byte ptr [ebp - local_4], 0x40           # 004269d7
    mov ecx, dword ptr [ebp - local_10]          # 004269db
    add ecx, 0xb4a41                             # 004269de
    call FUN_0048e21a                            # 004269e4
    mov byte ptr [ebp - local_4], 0x41           # 004269e9
    mov ecx, dword ptr [ebp - local_10]          # 004269ed
    add ecx, 0xb4f25                             # 004269f0
    call FUN_00483efa                            # 004269f6
    mov byte ptr [ebp - local_4], 0x42           # 004269fb
    mov ecx, dword ptr [ebp - local_10]          # 004269ff
    add ecx, 0xb5b60                             # 00426a02
    call FUN_0047e1ea                            # 00426a08
    mov byte ptr [ebp - local_4], 0x43           # 00426a0d
    mov ecx, dword ptr [ebp - local_10]          # 00426a11
    add ecx, 0xb6fad                             # 00426a14
    call FUN_004a7c0a                            # 00426a1a
    mov byte ptr [ebp - local_4], 0x44           # 00426a1f
    mov ecx, dword ptr [ebp - local_10]          # 00426a23
    add ecx, 0xb83aa                             # 00426a26
    call FUN_0046b51a                            # 00426a2c
    mov byte ptr [ebp - local_4], 0x45           # 00426a31
    mov ecx, dword ptr [ebp - local_10]          # 00426a35
    add ecx, 0xc06ac                             # 00426a38
    call FUN_004a9eb7                            # 00426a3e
    mov byte ptr [ebp - local_4], 0x46           # 00426a43
    mov ecx, dword ptr [ebp - local_10]          # 00426a47
    add ecx, 0xc06f6                             # 00426a4a
    call FUN_004cc927                            # 00426a50
    mov byte ptr [ebp - local_4], 0x47           # 00426a55
    mov ecx, dword ptr [ebp - local_10]          # 00426a59
    add ecx, 0xc0712                             # 00426a5c
    call FUN_004904fa                            # 00426a62
    mov byte ptr [ebp - local_4], 0x48           # 00426a67
    mov ecx, dword ptr [ebp - local_10]          # 00426a6b
    add ecx, 0xc5810                             # 00426a6e
    call FUN_0049c53a                            # 00426a74
    mov byte ptr [ebp - local_4], 0x49           # 00426a79
    mov ecx, dword ptr [ebp - local_10]          # 00426a7d
    add ecx, 0xc665c                             # 00426a80
    call FUN_004ac86a                            # 00426a86
    mov byte ptr [ebp - local_4], 0x4a           # 00426a8b
    mov ecx, dword ptr [ebp - local_10]          # 00426a8f
    add ecx, 0xc74e5                             # 00426a92
    call FUN_00423450                            # 00426a98
    mov byte ptr [ebp - local_4], 0x4b           # 00426a9d
    mov ecx, dword ptr [ebp - local_10]          # 00426aa1
    add ecx, 0xc7afd                             # 00426aa4
    call FUN_004dbf1a                            # 00426aaa
    mov byte ptr [ebp - local_4], 0x4c           # 00426aaf
    mov ecx, dword ptr [ebp - local_10]          # 00426ab3
    add ecx, 0xc7c07                             # 00426ab6
    call FUN_00447e27                            # 00426abc
    mov byte ptr [ebp - local_4], 0x4d           # 00426ac1
    mov ecx, dword ptr [ebp - local_10]          # 00426ac5
    add ecx, 0xc7c29                             # 00426ac8
    call FUN_0044afb7                            # 00426ace
    mov byte ptr [ebp - local_4], 0x4e           # 00426ad3
    mov ecx, dword ptr [ebp - local_10]          # 00426ad7
    add ecx, 0xc7c47                             # 00426ada
    call FUN_004bf600                            # 00426ae0
    mov byte ptr [ebp - local_4], 0x4f           # 00426ae5
    mov ecx, dword ptr [ebp - local_10]          # 00426ae9
    add ecx, 0xc7e95                             # 00426aec
    call FUN_004ccd70                            # 00426af2
    mov byte ptr [ebp - local_4], 0x50           # 00426af7
    mov ecx, dword ptr [ebp - local_10]          # 00426afb
    add ecx, 0xc80f3                             # 00426afe
    call FUN_004caed0                            # 00426b04
    mov byte ptr [ebp - local_4], 0x51           # 00426b09
    mov ecx, dword ptr [ebp - local_10]          # 00426b0d
    add ecx, 0xc8253                             # 00426b10
    call FUN_00414537                            # 00426b16
    mov byte ptr [ebp - local_4], 0x52           # 00426b1b
    mov ecx, dword ptr [ebp - local_10]          # 00426b1f
    add ecx, 0xc827b                             # 00426b22
    call FUN_00445df0                            # 00426b28
    mov eax, dword ptr [ebp - local_10]          # 00426b2d
    mov dword ptr [eax], 0x52c710                # 00426b30
    mov dword ptr [ebp - local_4], 0xffffffff    # 00426b36
    mov eax, dword ptr [ebp - local_10]          # 00426b3d
    mov ecx, dword ptr [ebp - local_c]           # 00426b40
    mov dword ptr fs:[0x0], ecx                  # 00426b43
    {load} mov esp, ebp                          # 00426b4a
    pop ebp                                      # 00426b4c
    ret                                          # 00426b4d

