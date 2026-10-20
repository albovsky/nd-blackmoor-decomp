# FUN_0043d7f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043d7f0
# extent:       0x0043d7f0-0x0043da93 (675 code bytes)
# span:         0x0043d7f0-0x0043da93 (code 675, tables 0, padding 0)
# sha256:       07b1d252f1508c06d118b6aa71b6cbbb012853271bc96afadd9a468135e36fe8
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43d7f0_init_scenes
# naming:       native port src/original_methods_fl30c.c:m43d7f0_init_scenes (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Scene initialiser: [0x5d15a5]=1, 47 thiscall initialisers on fixed object addresses, two dword copy-and-clear flags and six byte-to-dword flags. See fl30c-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d3ced, FUN_00468f68, FUN_004a3910, FUN_0048a82e, FUN_004b3da2, FUN_00459bd6, FUN_004a1ce0, FUN_0048e393, FUN_0048d0e5, FUN_004a6477, FUN_004b5c11, FUN_004ab425, FUN_00465b9f, FUN_004618ab, FUN_00487b98, FUN_004afdc7 and 31 more
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30c.c:m43d7f0_init_scenes (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 139 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00446075, .text + (0x00446075 - 0x401000)
.set FUN_0044d19d, .text + (0x0044d19d - 0x401000)
.set FUN_0044e7d7, .text + (0x0044e7d7 - 0x401000)
.set FUN_0044fb54, .text + (0x0044fb54 - 0x401000)
.set FUN_00454e39, .text + (0x00454e39 - 0x401000)
.set FUN_00456d77, .text + (0x00456d77 - 0x401000)
.set FUN_00458045, .text + (0x00458045 - 0x401000)
.set FUN_00459bd6, .text + (0x00459bd6 - 0x401000)
.set FUN_0045b477, .text + (0x0045b477 - 0x401000)
.set FUN_0045dd96, .text + (0x0045dd96 - 0x401000)
.set FUN_004618ab, .text + (0x004618ab - 0x401000)
.set FUN_004640c9, .text + (0x004640c9 - 0x401000)
.set FUN_00465b9f, .text + (0x00465b9f - 0x401000)
.set FUN_00467651, .text + (0x00467651 - 0x401000)
.set FUN_00468f68, .text + (0x00468f68 - 0x401000)
.set FUN_0046b707, .text + (0x0046b707 - 0x401000)
.set FUN_0046e7ef, .text + (0x0046e7ef - 0x401000)
.set FUN_00470e31, .text + (0x00470e31 - 0x401000)
.set FUN_00473117, .text + (0x00473117 - 0x401000)
.set FUN_004758e8, .text + (0x004758e8 - 0x401000)
.set FUN_00478287, .text + (0x00478287 - 0x401000)
.set FUN_0047b3bc, .text + (0x0047b3bc - 0x401000)
.set FUN_0047d640, .text + (0x0047d640 - 0x401000)
.set FUN_0047e440, .text + (0x0047e440 - 0x401000)
.set FUN_0048220e, .text + (0x0048220e - 0x401000)
.set FUN_004840d9, .text + (0x004840d9 - 0x401000)
.set FUN_00487b98, .text + (0x00487b98 - 0x401000)
.set FUN_00489722, .text + (0x00489722 - 0x401000)
.set FUN_0048a82e, .text + (0x0048a82e - 0x401000)
.set FUN_0048bc38, .text + (0x0048bc38 - 0x401000)
.set FUN_0048d0e5, .text + (0x0048d0e5 - 0x401000)
.set FUN_0048e393, .text + (0x0048e393 - 0x401000)
.set FUN_004a1ce0, .text + (0x004a1ce0 - 0x401000)
.set FUN_004a3910, .text + (0x004a3910 - 0x401000)
.set FUN_004a6477, .text + (0x004a6477 - 0x401000)
.set FUN_004a7da5, .text + (0x004a7da5 - 0x401000)
.set FUN_004a9fcb, .text + (0x004a9fcb - 0x401000)
.set FUN_004ab425, .text + (0x004ab425 - 0x401000)
.set FUN_004acbba, .text + (0x004acbba - 0x401000)
.set FUN_004afdc7, .text + (0x004afdc7 - 0x401000)
.set FUN_004b3da2, .text + (0x004b3da2 - 0x401000)
.set FUN_004b5c11, .text + (0x004b5c11 - 0x401000)
.set FUN_004b7272, .text + (0x004b7272 - 0x401000)
.set FUN_004b80a5, .text + (0x004b80a5 - 0x401000)
.set FUN_004ba22e, .text + (0x004ba22e - 0x401000)
.set FUN_004cafc1, .text + (0x004cafc1 - 0x401000)
.set FUN_004d3ced, .text + (0x004d3ced - 0x401000)

.org 0x0043d7f0 - 0x401000
.globl FUN_0043d7f0
FUN_0043d7f0:
    # block 0x0043d7f0: entry, 7 instruction(s), calls FUN_004d3ced, ends with je to 0x0043d824 (forward)
    push ebp                                     # 0043d7f0
    {load} mov ebp, esp                          # 0043d7f1
    mov dword ptr [0x5d15a5], 0x1                # 0043d7f3
    mov ecx, 0x61c387                            # 0043d7fd
    call FUN_004d3ced                            # 0043d802
    cmp dword ptr [0x5bb1d2], 0x0                # 0043d807
    je.d8 L_0043d824                             # 0043d80e
    # block 0x0043d810: entered by fall-through of je at 0x0043d80e, 3 instruction(s), falls into the block at 0x0043d824
    mov eax, dword ptr [0x5bb1ce]                # 0043d810
    mov dword ptr [0x5b15d6], eax                # 0043d815
    mov dword ptr [0x5bb1d2], 0x0                # 0043d81a
L_0043d824:
    # block 0x0043d824: entered by je at 0x0043d80e, 2 instruction(s), ends with je to 0x0043d843 (forward)
    cmp dword ptr [0x5bb1da], 0x0                # 0043d824
    je.d8 L_0043d843                             # 0043d82b
    # block 0x0043d82d: entered by fall-through of je at 0x0043d82b, 3 instruction(s), falls into the block at 0x0043d843
    mov ecx, dword ptr [0x5bb1d6]                # 0043d82d
    mov dword ptr [0x5b1606], ecx                # 0043d833
    mov dword ptr [0x5bb1da], 0x0                # 0043d839
L_0043d843:
    # block 0x0043d843: entered by je at 0x0043d82b, 4 instruction(s), ends with je to 0x0043d859 (forward)
    {load} xor edx, edx                          # 0043d843
    mov dl, byte ptr [0x5b5158]                  # 0043d845
    test edx, edx                                # 0043d84b
    je.d8 L_0043d859                             # 0043d84d
    # block 0x0043d84f: entered by fall-through of je at 0x0043d84d, 1 instruction(s), falls into the block at 0x0043d859
    mov dword ptr [0x5d1a8f], 0x1                # 0043d84f
L_0043d859:
    # block 0x0043d859: entered by je at 0x0043d84d, 4 instruction(s), ends with je to 0x0043d86e (forward)
    {load} xor eax, eax                          # 0043d859
    mov al, byte ptr [0x5b51ab]                  # 0043d85b
    test eax, eax                                # 0043d860
    je.d8 L_0043d86e                             # 0043d862
    # block 0x0043d864: entered by fall-through of je at 0x0043d862, 1 instruction(s), falls into the block at 0x0043d86e
    mov dword ptr [0x5d1ad9], 0x1                # 0043d864
L_0043d86e:
    # block 0x0043d86e: entered by je at 0x0043d862, 4 instruction(s), ends with je to 0x0043d884 (forward)
    {load} xor ecx, ecx                          # 0043d86e
    mov cl, byte ptr [0x5b51c6]                  # 0043d870
    test ecx, ecx                                # 0043d876
    je.d8 L_0043d884                             # 0043d878
    # block 0x0043d87a: entered by fall-through of je at 0x0043d878, 1 instruction(s), falls into the block at 0x0043d884
    mov dword ptr [0x5d1b23], 0x1                # 0043d87a
L_0043d884:
    # block 0x0043d884: entered by je at 0x0043d878, 4 instruction(s), ends with je to 0x0043d89a (forward)
    {load} xor edx, edx                          # 0043d884
    mov dl, byte ptr [0x5b615e]                  # 0043d886
    test edx, edx                                # 0043d88c
    je.d8 L_0043d89a                             # 0043d88e
    # block 0x0043d890: entered by fall-through of je at 0x0043d88e, 1 instruction(s), falls into the block at 0x0043d89a
    mov dword ptr [0x5d1bb7], 0x1                # 0043d890
L_0043d89a:
    # block 0x0043d89a: entered by je at 0x0043d88e, 4 instruction(s), ends with je to 0x0043d8af (forward)
    {load} xor eax, eax                          # 0043d89a
    mov al, byte ptr [0x5b61af]                  # 0043d89c
    test eax, eax                                # 0043d8a1
    je.d8 L_0043d8af                             # 0043d8a3
    # block 0x0043d8a5: entered by fall-through of je at 0x0043d8a3, 1 instruction(s), falls into the block at 0x0043d8af
    mov dword ptr [0x5d1c01], 0x1                # 0043d8a5
L_0043d8af:
    # block 0x0043d8af: entered by je at 0x0043d8a3, 4 instruction(s), ends with je to 0x0043d8c5 (forward)
    {load} xor ecx, ecx                          # 0043d8af
    mov cl, byte ptr [0x5b51f6]                  # 0043d8b1
    test ecx, ecx                                # 0043d8b7
    je.d8 L_0043d8c5                             # 0043d8b9
    # block 0x0043d8bb: entered by fall-through of je at 0x0043d8b9, 1 instruction(s), falls into the block at 0x0043d8c5
    mov dword ptr [0x5d1b6d], 0x1                # 0043d8bb
L_0043d8c5:
    # block 0x0043d8c5: entered by je at 0x0043d8b9, 94 instruction(s), calls FUN_00468f68, FUN_004a3910, FUN_0048a82e, FUN_004b3da2, FUN_00459bd6, FUN_004a1ce0, FUN_0048e393,..., ends with ret
    mov ecx, 0x616ab2                            # 0043d8c5
    call FUN_00468f68                            # 0043d8ca
    mov ecx, 0x61c8cf                            # 0043d8cf
    call FUN_004a3910                            # 0043d8d4
    mov ecx, 0x61d10f                            # 0043d8d9
    call FUN_0048a82e                            # 0043d8de
    mov ecx, 0x617066                            # 0043d8e3
    call FUN_004b3da2                            # 0043d8e8
    mov ecx, 0x61c7ed                            # 0043d8ed
    call FUN_00459bd6                            # 0043d8f2
    mov ecx, 0x61d2dd                            # 0043d8f7
    call FUN_004a1ce0                            # 0043d8fc
    mov ecx, 0x624dc9                            # 0043d901
    call FUN_0048e393                            # 0043d906
    mov ecx, 0x61d345                            # 0043d90b
    call FUN_0048d0e5                            # 0043d910
    mov ecx, 0x61d3a1                            # 0043d915
    call FUN_004a6477                            # 0043d91a
    mov ecx, 0x61d449                            # 0043d91f
    call FUN_004b5c11                            # 0043d924
    mov ecx, 0x61d6c1                            # 0043d929
    call FUN_004ab425                            # 0043d92e
    mov ecx, 0x61d723                            # 0043d933
    call FUN_00465b9f                            # 0043d938
    mov ecx, 0x61d779                            # 0043d93d
    call FUN_004618ab                            # 0043d942
    mov ecx, 0x61d7d8                            # 0043d947
    call FUN_00487b98                            # 0043d94c
    mov ecx, 0x6204c1                            # 0043d951
    call FUN_004afdc7                            # 0043d956
    mov ecx, 0x61d873                            # 0043d95b
    call FUN_0044fb54                            # 0043d960
    mov ecx, 0x61e398                            # 0043d965
    call FUN_0047b3bc                            # 0043d96a
    mov ecx, 0x61df56                            # 0043d96f
    call FUN_004ba22e                            # 0043d974
    mov ecx, 0x638603                            # 0043d979
    call FUN_00446075                            # 0043d97e
    mov ecx, 0x621a02                            # 0043d983
    call FUN_00478287                            # 0043d988
    mov ecx, 0x622fa2                            # 0043d98d
    call FUN_004758e8                            # 0043d992
    mov ecx, 0x62387c                            # 0043d997
    call FUN_00470e31                            # 0043d99c
    mov ecx, 0x624686                            # 0043d9a1
    call FUN_0048bc38                            # 0043d9a6
    mov ecx, 0x6246dc                            # 0043d9ab
    call FUN_0047d640                            # 0043d9b0
    mov ecx, 0x624734                            # 0043d9b5
    call FUN_0045b477                            # 0043d9ba
    mov ecx, 0x6248ed                            # 0043d9bf
    call FUN_00456d77                            # 0043d9c4
    mov ecx, 0x624931                            # 0043d9c9
    call FUN_0044e7d7                            # 0043d9ce
    mov ecx, 0x6249a0                            # 0043d9d3
    call FUN_004b7272                            # 0043d9d8
    mov ecx, 0x6249dc                            # 0043d9dd
    call FUN_00454e39                            # 0043d9e2
    mov ecx, 0x6252ad                            # 0043d9e7
    call FUN_004840d9                            # 0043d9ec
    mov ecx, 0x625ee8                            # 0043d9f1
    call FUN_0047e440                            # 0043d9f6
    mov ecx, 0x627335                            # 0043d9fb
    call FUN_004a7da5                            # 0043da00
    mov ecx, 0x61e65c                            # 0043da05
    call FUN_00467651                            # 0043da0a
    mov ecx, 0x61e95c                            # 0043da0f
    call FUN_00473117                            # 0043da14
    mov ecx, 0x61ed7b                            # 0043da19
    call FUN_00458045                            # 0043da1e
    mov ecx, 0x61f4b1                            # 0043da23
    call FUN_0045dd96                            # 0043da28
    mov ecx, 0x61ee6e                            # 0043da2d
    call FUN_004b80a5                            # 0043da32
    mov ecx, 0x630a34                            # 0043da37
    call FUN_004a9fcb                            # 0043da3c
    mov ecx, 0x624b50                            # 0043da41
    call FUN_004640c9                            # 0043da46
    mov ecx, 0x628732                            # 0043da4b
    call FUN_0046b707                            # 0043da50
    mov ecx, 0x624c2a                            # 0043da55
    call FUN_0046e7ef                            # 0043da5a
    mov ecx, 0x624cbf                            # 0043da5f
    call FUN_0044d19d                            # 0043da64
    mov ecx, 0x624d12                            # 0043da69
    call FUN_0048220e                            # 0043da6e
    mov ecx, 0x6369e4                            # 0043da73
    call FUN_004acbba                            # 0043da78
    mov ecx, 0x63847b                            # 0043da7d
    call FUN_004cafc1                            # 0043da82
    mov ecx, 0x619935                            # 0043da87
    call FUN_00489722                            # 0043da8c
    pop ebp                                      # 0043da91
    ret                                          # 0043da92

