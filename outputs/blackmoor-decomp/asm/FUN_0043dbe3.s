# FUN_0043dbe3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043dbe3
# extent:       0x0043dbe3-0x0043e44f (2156 code bytes)
# span:         0x0043dbe3-0x0043e484 (code 2156, tables 53, padding 0)
# sha256:       66268cf3441504f8faefe8a8587c1df66891de21b7b0600c4889ef0b17137e35
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043dbe3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, KERNEL32.dll!GetTickCount, FUN_004c9428, FUN_004c94ec, FUN_004c2dfb, FUN_00468f19, FUN_004b3d4d, FUN_00459b87, FUN_004a3884, FUN_0048a7e5, FUN_00488e54, FUN_0041114f, FUN_004a1cb1, FUN_0048e2f5, FUN_0048d09c, FUN_004a63dc and 56 more
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:begin_native_session_bindings_scene (function ledger class candidate_port; also clear_before_scene_entry, perform_session_transition; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 378 instruction(s), 11 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0041114f, .text + (0x0041114f - 0x401000)
.set FUN_004145d0, .text + (0x004145d0 - 0x401000)
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0041608b, .text + (0x0041608b - 0x401000)
.set FUN_0041db40, .text + (0x0041db40 - 0x401000)
.set FUN_0041de29, .text + (0x0041de29 - 0x401000)
.set FUN_004234b5, .text + (0x004234b5 - 0x401000)
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_00445f40, .text + (0x00445f40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c384, .text + (0x0044c384 - 0x401000)
.set FUN_0044c44c, .text + (0x0044c44c - 0x401000)
.set FUN_0044c9db, .text + (0x0044c9db - 0x401000)
.set FUN_0044cb7d, .text + (0x0044cb7d - 0x401000)
.set FUN_0044d154, .text + (0x0044d154 - 0x401000)
.set FUN_0044e78e, .text + (0x0044e78e - 0x401000)
.set FUN_0044f996, .text + (0x0044f996 - 0x401000)
.set FUN_00454de6, .text + (0x00454de6 - 0x401000)
.set FUN_00456d2e, .text + (0x00456d2e - 0x401000)
.set FUN_00457fc2, .text + (0x00457fc2 - 0x401000)
.set FUN_00459b87, .text + (0x00459b87 - 0x401000)
.set FUN_0045b42e, .text + (0x0045b42e - 0x401000)
.set FUN_0045dd4d, .text + (0x0045dd4d - 0x401000)
.set FUN_00461862, .text + (0x00461862 - 0x401000)
.set FUN_00464076, .text + (0x00464076 - 0x401000)
.set FUN_00465b3c, .text + (0x00465b3c - 0x401000)
.set FUN_00467608, .text + (0x00467608 - 0x401000)
.set FUN_00468f19, .text + (0x00468f19 - 0x401000)
.set FUN_0046b67f, .text + (0x0046b67f - 0x401000)
.set FUN_0046e7a6, .text + (0x0046e7a6 - 0x401000)
.set FUN_00470ddc, .text + (0x00470ddc - 0x401000)
.set FUN_004730a6, .text + (0x004730a6 - 0x401000)
.set FUN_00475885, .text + (0x00475885 - 0x401000)
.set FUN_0047823e, .text + (0x0047823e - 0x401000)
.set FUN_0047b321, .text + (0x0047b321 - 0x401000)
.set FUN_0047d59b, .text + (0x0047d59b - 0x401000)
.set FUN_0047e2a5, .text + (0x0047e2a5 - 0x401000)
.set FUN_004821ab, .text + (0x004821ab - 0x401000)
.set FUN_00483fb5, .text + (0x00483fb5 - 0x401000)
.set FUN_00487b4f, .text + (0x00487b4f - 0x401000)
.set FUN_00488e54, .text + (0x00488e54 - 0x401000)
.set FUN_0048a7e5, .text + (0x0048a7e5 - 0x401000)
.set FUN_0048bb86, .text + (0x0048bb86 - 0x401000)
.set FUN_0048d09c, .text + (0x0048d09c - 0x401000)
.set FUN_0048e2f5, .text + (0x0048e2f5 - 0x401000)
.set FUN_004a1cb1, .text + (0x004a1cb1 - 0x401000)
.set FUN_004a3884, .text + (0x004a3884 - 0x401000)
.set FUN_004a63dc, .text + (0x004a63dc - 0x401000)
.set FUN_004a7d1d, .text + (0x004a7d1d - 0x401000)
.set FUN_004a9f63, .text + (0x004a9f63 - 0x401000)
.set FUN_004ab3dc, .text + (0x004ab3dc - 0x401000)
.set FUN_004ac97d, .text + (0x004ac97d - 0x401000)
.set FUN_004afd7e, .text + (0x004afd7e - 0x401000)
.set FUN_004b3d4d, .text + (0x004b3d4d - 0x401000)
.set FUN_004b5bc8, .text + (0x004b5bc8 - 0x401000)
.set FUN_004b7229, .text + (0x004b7229 - 0x401000)
.set FUN_004b7ff4, .text + (0x004b7ff4 - 0x401000)
.set FUN_004ba07f, .text + (0x004ba07f - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004bf8a7, .text + (0x004bf8a7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c9428, .text + (0x004c9428 - 0x401000)
.set FUN_004c94ec, .text + (0x004c94ec - 0x401000)
.set FUN_004caf8a, .text + (0x004caf8a - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004de2d8, .text + (0x004de2d8 - 0x401000)
.set FUN_004e9e6c, .text + (0x004e9e6c - 0x401000)
.set FUN_004ea229, .text + (0x004ea229 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043dbe3 - 0x401000
.globl FUN_0043dbe3
FUN_0043dbe3:
    # block 0x0043dbe3: entry, 6 instruction(s), ends with je to 0x0043dc01 (forward)
    push ebp                                     # 0043dbe3
    {load} mov ebp, esp                          # 0043dbe4
    sub esp, 0x18                                # 0043dbe6
    movsx eax, word ptr [0x63a4cd]               # 0043dbe9
    test eax, eax                                # 0043dbf0
    je.d8 L_0043dc01                             # 0043dbf2
    # block 0x0043dbf4: entered by fall-through of je at 0x0043dbf2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043dc01
    push 0x547640                                # 0043dbf4
    call FUN_0044a2b7                            # 0043dbf9
    add esp, 0x4                                 # 0043dbfe
L_0043dc01:
    # block 0x0043dc01: entered by je at 0x0043dbf2, 74 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004c9428, FUN_004c94ec, FUN_004c2dfb, FUN_00468f19, FUN_004b3d4d, ..., ends with jne to 0x0043de3e (forward)
    call dword ptr [0x52a23c]                    # 0043dc01
    mov dword ptr [ebp - local_4], eax           # 0043dc07
    mov ecx, 0x5cf659                            # 0043dc0a
    call FUN_004c9428                            # 0043dc0f
    mov ecx, 0x5cf659                            # 0043dc14
    call FUN_004c94ec                            # 0043dc19
    mov dword ptr [0x5bb214], 0x1                # 0043dc1e
    mov dword ptr [0x5867a1], 0x0                # 0043dc28
    mov dword ptr [0x5867a5], 0x0                # 0043dc32
    mov dword ptr [0x5867a9], 0x0                # 0043dc3c
    mov dword ptr [0x5867ad], 0x0                # 0043dc46
    mov dword ptr [0x5867b1], 0x0                # 0043dc50
    mov dword ptr [0x5867b5], 0x0                # 0043dc5a
    mov dword ptr [0x5867b9], 0x0                # 0043dc64
    mov dword ptr [0x5867bd], 0x0                # 0043dc6e
    mov dword ptr [0x5867c1], 0x0                # 0043dc78
    mov dword ptr [0x5867c5], 0x0                # 0043dc82
    mov dword ptr [0x5867c9], 0x0                # 0043dc8c
    mov dword ptr [0x5867cd], 0x0                # 0043dc96
    mov dword ptr [0x5867d1], 0x0                # 0043dca0
    mov dword ptr [0x5867d5], 0x0                # 0043dcaa
    mov dword ptr [0x5867d9], 0x0                # 0043dcb4
    mov dword ptr [0x5867dd], 0x0                # 0043dcbe
    mov dword ptr [0x5867e1], 0x0                # 0043dcc8
    mov dword ptr [0x5867e5], 0x0                # 0043dcd2
    mov dword ptr [0x5867e9], 0x0                # 0043dcdc
    mov dword ptr [0x5867ed], 0x0                # 0043dce6
    mov dword ptr [0x5867f1], 0x0                # 0043dcf0
    mov dword ptr [0x5867f5], 0x0                # 0043dcfa
    mov dword ptr [0x5867f9], 0x0                # 0043dd04
    mov dword ptr [0x5867fd], 0x0                # 0043dd0e
    mov dword ptr [0x586801], 0x0                # 0043dd18
    mov dword ptr [0x586805], 0x0                # 0043dd22
    mov dword ptr [0x586809], 0x0                # 0043dd2c
    mov dword ptr [0x58680d], 0x0                # 0043dd36
    mov dword ptr [0x586811], 0x0                # 0043dd40
    mov dword ptr [0x586815], 0x0                # 0043dd4a
    mov dword ptr [0x586819], 0x0                # 0043dd54
    mov byte ptr [0x5b5158], 0x0                 # 0043dd5e
    mov dword ptr [0x5d1a8f], 0x0                # 0043dd65
    push 0x5d03cf                                # 0043dd6f
    mov ecx, 0x5cf659                            # 0043dd74
    call FUN_004c2dfb                            # 0043dd79
    mov byte ptr [0x5b51ab], 0x0                 # 0043dd7e
    mov dword ptr [0x5d1ad9], 0x0                # 0043dd85
    push 0x5d03d3                                # 0043dd8f
    mov ecx, 0x5cf659                            # 0043dd94
    call FUN_004c2dfb                            # 0043dd99
    mov byte ptr [0x5b51c6], 0x0                 # 0043dd9e
    mov dword ptr [0x5d1b23], 0x0                # 0043dda5
    push 0x5d03d7                                # 0043ddaf
    mov ecx, 0x5cf659                            # 0043ddb4
    call FUN_004c2dfb                            # 0043ddb9
    mov byte ptr [0x5b615e], 0x0                 # 0043ddbe
    mov dword ptr [0x5d1bb7], 0x0                # 0043ddc5
    push 0x5d03db                                # 0043ddcf
    mov ecx, 0x5cf659                            # 0043ddd4
    call FUN_004c2dfb                            # 0043ddd9
    mov byte ptr [0x5b61af], 0x0                 # 0043ddde
    mov dword ptr [0x5d1c01], 0x0                # 0043dde5
    mov ecx, 0x616ab2                            # 0043ddef
    call FUN_00468f19                            # 0043ddf4
    mov ecx, 0x617066                            # 0043ddf9
    call FUN_004b3d4d                            # 0043ddfe
    mov ecx, 0x61c7ed                            # 0043de03
    call FUN_00459b87                            # 0043de08
    mov ecx, 0x61c8cf                            # 0043de0d
    call FUN_004a3884                            # 0043de12
    mov ecx, 0x61d10f                            # 0043de17
    call FUN_0048a7e5                            # 0043de1c
    mov ecx, 0x619935                            # 0043de21
    call FUN_00488e54                            # 0043de26
    cmp dword ptr [0x583204], 0x0                # 0043de2b
    jne.d8 L_0043de3e                            # 0043de32
    # block 0x0043de34: entered by fall-through of jne at 0x0043de32, 2 instruction(s), calls FUN_0041114f, falls into the block at 0x0043de3e
    mov ecx, 0x619a41                            # 0043de34
    call FUN_0041114f                            # 0043de39
L_0043de3e:
    # block 0x0043de3e: entered by jne at 0x0043de32, 107 instruction(s), calls FUN_004a1cb1, FUN_0048e2f5, FUN_0048d09c, FUN_004a63dc, FUN_004b5bc8, FUN_004ab3dc, FUN_00465b3c,..., ends with forward jump to 0x0043e097
    mov ecx, 0x61d2dd                            # 0043de3e
    call FUN_004a1cb1                            # 0043de43
    mov ecx, 0x624dc9                            # 0043de48
    call FUN_0048e2f5                            # 0043de4d
    mov ecx, 0x61d345                            # 0043de52
    call FUN_0048d09c                            # 0043de57
    mov ecx, 0x61d3a1                            # 0043de5c
    call FUN_004a63dc                            # 0043de61
    mov ecx, 0x61d449                            # 0043de66
    call FUN_004b5bc8                            # 0043de6b
    mov ecx, 0x61d6c1                            # 0043de70
    call FUN_004ab3dc                            # 0043de75
    mov ecx, 0x61d723                            # 0043de7a
    call FUN_00465b3c                            # 0043de7f
    mov ecx, 0x61d779                            # 0043de84
    call FUN_00461862                            # 0043de89
    mov ecx, 0x61d7d8                            # 0043de8e
    call FUN_00487b4f                            # 0043de93
    mov ecx, 0x6204c1                            # 0043de98
    call FUN_004afd7e                            # 0043de9d
    mov ecx, 0x621a02                            # 0043dea2
    call FUN_0047823e                            # 0043dea7
    mov ecx, 0x622fa2                            # 0043deac
    call FUN_00475885                            # 0043deb1
    mov ecx, 0x62387c                            # 0043deb6
    call FUN_00470ddc                            # 0043debb
    mov ecx, 0x624686                            # 0043dec0
    call FUN_0048bb86                            # 0043dec5
    mov ecx, 0x6246dc                            # 0043deca
    call FUN_0047d59b                            # 0043decf
    mov ecx, 0x624734                            # 0043ded4
    call FUN_0045b42e                            # 0043ded9
    mov ecx, 0x6248ed                            # 0043dede
    call FUN_00456d2e                            # 0043dee3
    mov ecx, 0x624931                            # 0043dee8
    call FUN_0044e78e                            # 0043deed
    mov ecx, 0x6249a0                            # 0043def2
    call FUN_004b7229                            # 0043def7
    mov ecx, 0x6249dc                            # 0043defc
    call FUN_00454de6                            # 0043df01
    mov ecx, 0x630a34                            # 0043df06
    call FUN_004a9f63                            # 0043df0b
    mov ecx, 0x6252ad                            # 0043df10
    call FUN_00483fb5                            # 0043df15
    mov ecx, 0x625ee8                            # 0043df1a
    call FUN_0047e2a5                            # 0043df1f
    mov ecx, 0x627335                            # 0043df24
    call FUN_004a7d1d                            # 0043df29
    mov ecx, 0x628732                            # 0043df2e
    call FUN_0046b67f                            # 0043df33
    mov ecx, 0x61e65c                            # 0043df38
    call FUN_00467608                            # 0043df3d
    mov ecx, 0x61e95c                            # 0043df42
    call FUN_004730a6                            # 0043df47
    mov ecx, 0x61ed7b                            # 0043df4c
    call FUN_00457fc2                            # 0043df51
    mov ecx, 0x61f4b1                            # 0043df56
    call FUN_0045dd4d                            # 0043df5b
    mov ecx, 0x61ee6e                            # 0043df60
    call FUN_004b7ff4                            # 0043df65
    mov ecx, 0x624b50                            # 0043df6a
    call FUN_00464076                            # 0043df6f
    mov ecx, 0x624c2a                            # 0043df74
    call FUN_0046e7a6                            # 0043df79
    mov ecx, 0x61d873                            # 0043df7e
    call FUN_0044f996                            # 0043df83
    mov ecx, 0x61e398                            # 0043df88
    call FUN_0047b321                            # 0043df8d
    mov ecx, 0x61df56                            # 0043df92
    call FUN_004ba07f                            # 0043df97
    mov ecx, 0x638603                            # 0043df9c
    call FUN_00445f40                            # 0043dfa1
    mov ecx, 0x624d12                            # 0043dfa6
    call FUN_004821ab                            # 0043dfab
    mov ecx, 0x624cbf                            # 0043dfb0
    call FUN_0044d154                            # 0043dfb5
    mov ecx, 0x6369e4                            # 0043dfba
    call FUN_004ac97d                            # 0043dfbf
    mov ecx, 0x628732                            # 0043dfc4
    call FUN_0046b67f                            # 0043dfc9
    mov ecx, 0x63786d                            # 0043dfce
    call FUN_004234b5                            # 0043dfd3
    mov byte ptr [0x5b51f6], 0x0                 # 0043dfd8
    mov dword ptr [0x5d1b6d], 0x0                # 0043dfdf
    push 0x5d03df                                # 0043dfe9
    mov ecx, 0x5cf659                            # 0043dfee
    call FUN_004c2dfb                            # 0043dff3
    mov dword ptr [0x5839a9], 0x0                # 0043dff8
    mov ecx, 0x571442                            # 0043e002
    call FUN_004ea229                            # 0043e007
    mov ecx, 0x571442                            # 0043e00c
    call FUN_004e9e6c                            # 0043e011
    mov word ptr [0x5b4e89], 0xffff              # 0043e016
    mov word ptr [0x5b5100], 0xffff              # 0043e01f
    mov word ptr [0x5b4e8b], 0x1                 # 0043e028
    mov word ptr [0x5b5102], 0x1                 # 0043e031
    call FUN_0044c384                            # 0043e03a
    call FUN_0044cb7d                            # 0043e03f
    call FUN_0044c44c                            # 0043e044
    mov dword ptr [0x5d191d], 0x0                # 0043e049
    mov dword ptr [0x5d1967], 0x0                # 0043e053
    mov dword ptr [0x5d19b1], 0x0                # 0043e05d
    mov dword ptr [0x5d19fb], 0x0                # 0043e067
    mov word ptr [0x5b4e8d], 0x0                 # 0043e071
    mov word ptr [0x5b5104], 0x0                 # 0043e07a
    mov word ptr [ebp - local_10], 0x18          # 0043e083
    jmp.d8 L_0043e097                            # 0043e089
L_0043e08b:
    # block 0x0043e08b: entered by jmp at 0x0043e0ad, 3 instruction(s), falls into the block at 0x0043e097
    mov cx, word ptr [ebp - local_10]            # 0043e08b
    add cx, 0x1                                  # 0043e08f
    mov word ptr [ebp - local_10], cx            # 0043e093
L_0043e097:
    # block 0x0043e097: entered by jmp at 0x0043e089, 3 instruction(s), ends with jg to 0x0043e0af (forward)
    movsx edx, word ptr [ebp - local_10]         # 0043e097
    cmp edx, 0x3f                                # 0043e09b
    jg.d8 L_0043e0af                             # 0043e09e
    # block 0x0043e0a0: entered by fall-through of jg at 0x0043e09e, 5 instruction(s), calls FUN_004d3992, ends with backward jump to 0x0043e08b
    mov ax, word ptr [ebp - local_10]            # 0043e0a0
    push eax                                     # 0043e0a4
    call FUN_004d3992                            # 0043e0a5
    add esp, 0x4                                 # 0043e0aa
    jmp.d8 L_0043e08b                            # 0043e0ad
L_0043e0af:
    # block 0x0043e0af: entered by jg at 0x0043e09e, 30 instruction(s), calls FUN_00415011, FUN_004bedfa, FUN_004bf8a7, FUN_004caf8a, FUN_0041608b, FUN_0044c9db, FUN_0041de29, ends with jne to 0x0043e16b (forward)
    push 0x5bb2d3                                # 0043e0af
    mov ecx, 0x5e2dbe                            # 0043e0b4
    call FUN_00415011                            # 0043e0b9
    push 0x5b4c3e                                # 0043e0be
    mov ecx, 0x5e2dbe                            # 0043e0c3
    call FUN_00415011                            # 0043e0c8
    push 0x5b4eb5                                # 0043e0cd
    mov ecx, 0x5e2dbe                            # 0043e0d2
    call FUN_00415011                            # 0043e0d7
    push 0x5bb4db                                # 0043e0dc
    mov ecx, 0x6201f9                            # 0043e0e1
    call FUN_004bedfa                            # 0043e0e6
    push 0x5b4dc4                                # 0043e0eb
    mov ecx, 0x6201f9                            # 0043e0f0
    call FUN_004bedfa                            # 0043e0f5
    push 0x5b503b                                # 0043e0fa
    mov ecx, 0x6201f9                            # 0043e0ff
    call FUN_004bedfa                            # 0043e104
    mov ecx, 0x637fcf                            # 0043e109
    call FUN_004bf8a7                            # 0043e10e
    mov ecx, 0x63847b                            # 0043e113
    call FUN_004caf8a                            # 0043e118
    push 0x5bb2d3                                # 0043e11d
    mov ecx, 0x5e2dbe                            # 0043e122
    call FUN_0041608b                            # 0043e127
    call FUN_0044c9db                            # 0043e12c
    mov ecx, 0x6177e8                            # 0043e131
    call FUN_0041de29                            # 0043e136
    cmp dword ptr [0x5e32b5], 0x0                # 0043e13b
    jne.d8 L_0043e16b                            # 0043e142
    # block 0x0043e144: entered by fall-through of jne at 0x0043e142, 5 instruction(s), ends with forward jump to 0x0043e18f
    mov dword ptr [0x585d41], 0x0                # 0043e144
    mov word ptr [0x585d45], 0x0                 # 0043e14e
    mov word ptr [0x585d47], 0x0                 # 0043e157
    mov word ptr [0x585d49], 0x0                 # 0043e160
    jmp.d8 L_0043e18f                            # 0043e169
L_0043e16b:
    # block 0x0043e16b: entered by jne at 0x0043e142, 8 instruction(s), falls into the block at 0x0043e18f
    mov ecx, dword ptr [ebp - local_4]           # 0043e16b
    mov dword ptr [0x585d33], ecx                # 0043e16e
    mov edx, dword ptr [ebp - local_4]           # 0043e174
    mov dword ptr [0x585d5d], edx                # 0043e177
    movsx eax, word ptr [0x5b0280]               # 0043e17d
    mov ecx, dword ptr [ebp - local_4]           # 0043e184
    {load} add ecx, eax                          # 0043e187
    mov dword ptr [0x585d55], ecx                # 0043e189
L_0043e18f:
    # block 0x0043e18f: entered by jmp at 0x0043e169, 2 instruction(s), ends with forward jump to 0x0043e1a3
    mov word ptr [ebp - local_10], 0x0           # 0043e18f
    jmp.d8 L_0043e1a3                            # 0043e195
L_0043e197:
    # block 0x0043e197: entered by jmp at 0x0043e1bb, 3 instruction(s), falls into the block at 0x0043e1a3
    mov dx, word ptr [ebp - local_10]            # 0043e197
    add dx, 0x1                                  # 0043e19b
    mov word ptr [ebp - local_10], dx            # 0043e19f
L_0043e1a3:
    # block 0x0043e1a3: entered by jmp at 0x0043e195, 3 instruction(s), ends with jge to 0x0043e1bd (forward)
    movsx eax, word ptr [ebp - local_10]         # 0043e1a3
    cmp eax, 0x19                                # 0043e1a7
    jge.d8 L_0043e1bd                            # 0043e1aa
    # block 0x0043e1ac: entered by fall-through of jge at 0x0043e1aa, 3 instruction(s), ends with backward jump to 0x0043e197
    movsx ecx, word ptr [ebp - local_10]         # 0043e1ac
    mov dword ptr [4*ecx + 0x5bb50d], 0x0        # 0043e1b0
    jmp.d8 L_0043e197                            # 0043e1bb
L_0043e1bd:
    # block 0x0043e1bd: entered by jge at 0x0043e1aa, 20 instruction(s), calls FUN_004de2d8, FUN_004dad60, ends with forward jump to 0x0043e250
    mov ecx, 0x61f864                            # 0043e1bd
    call FUN_004de2d8                            # 0043e1c2
    movsx edx, word ptr [0x5b0a76]               # 0043e1c7
    mov eax, dword ptr [0x5b0a1e]                # 0043e1ce
    sub eax, dword ptr [0x5b0a16]                # 0043e1d3
    add eax, 0x1                                 # 0043e1d9
    {load} sub edx, eax                          # 0043e1dc
    mov word ptr [0x5b0a7c], dx                  # 0043e1de
    mov dword ptr [0x5b15c8], 0x0                # 0043e1e5
    mov dword ptr [0x5b15d6], 0x0                # 0043e1ef
    mov dword ptr [0x5b15da], 0x0                # 0043e1f9
    mov dword ptr [0x5b1602], 0x0                # 0043e203
    mov dword ptr [0x5b1606], 0x0                # 0043e20d
    mov dword ptr [0x5bb1da], 0x0                # 0043e217
    mov dword ptr [0x5831c8], 0x0                # 0043e221
    mov ecx, 0x5830a6                            # 0043e22b
    call FUN_004dad60                            # 0043e230
    mov dword ptr [ebp - local_8], 0x0           # 0043e235
    mov word ptr [ebp - local_10], 0x0           # 0043e23c
    jmp.d8 L_0043e250                            # 0043e242
L_0043e244:
    # block 0x0043e244: entered by jmp at 0x0043e3c1, 3 instruction(s), falls into the block at 0x0043e250
    mov cx, word ptr [ebp - local_10]            # 0043e244
    add cx, 0x1                                  # 0043e248
    mov word ptr [ebp - local_10], cx            # 0043e24c
L_0043e250:
    # block 0x0043e250: entered by jmp at 0x0043e242, 3 instruction(s), ends with jge to 0x0043e3c6 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0043e250
    cmp edx, 0xf0                                # 0043e254
    jge.d32 L_0043e3c6                           # 0043e25a
    # block 0x0043e260: entered by fall-through of jge at 0x0043e25a, 11 instruction(s), ends with ja to 0x0043e2d6 (forward)
    mov dword ptr [ebp - local_c], 0x0           # 0043e260
    movsx eax, word ptr [ebp - local_10]         # 0043e267
    imul eax, eax, 0x8d                          # 0043e26b
    {load} xor ecx, ecx                          # 0043e271
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0043e273
    mov dword ptr [ebp - local_18], ecx          # 0043e279
    mov edx, dword ptr [ebp - local_18]          # 0043e27c
    sub edx, 0x1b                                # 0043e27f
    mov dword ptr [ebp - local_18], edx          # 0043e282
    cmp dword ptr [ebp - local_18], 0x24         # 0043e285
    ja.d8 L_0043e2d6                             # 0043e289
    # block 0x0043e28b: entered by fall-through of ja at 0x0043e289, 4 instruction(s), ends with indirect jump dword ptr [4*eax + 0x43e44f]
    mov ecx, dword ptr [ebp - local_18]          # 0043e28b
    {load} xor eax, eax                          # 0043e28e
    mov al, byte ptr [ecx + IDXTAB_0043e45f_VA]  # 0043e290
    jmp dword ptr [4*eax + SWTAB_0043e44f_VA]    # 0043e296
L_0043e29d:
    # block 0x0043e29d: entered by switch case, 6 instruction(s), calls FUN_0041db40, ends with forward jump to 0x0043e323
    mov dx, word ptr [ebp - local_10]            # 0043e29d
    push edx                                     # 0043e2a1
    mov ecx, 0x6177e8                            # 0043e2a2
    call FUN_0041db40                            # 0043e2a7
    mov dword ptr [ebp - local_c], 0x1           # 0043e2ac
    jmp.d8 L_0043e323                            # 0043e2b3
L_0043e2b5:
    # block 0x0043e2b5: entered by switch case, 6 instruction(s), calls FUN_004145d0, ends with forward jump to 0x0043e323
    mov ax, word ptr [ebp - local_10]            # 0043e2b5
    push eax                                     # 0043e2b9
    mov ecx, 0x6385db                            # 0043e2ba
    call FUN_004145d0                            # 0043e2bf
    mov dword ptr [ebp - local_c], 0x1           # 0043e2c4
    jmp.d8 L_0043e323                            # 0043e2cb
L_0043e2cd:
    # block 0x0043e2cd: entered by switch case, 2 instruction(s), ends with forward jump to 0x0043e323
    mov dword ptr [ebp - local_8], 0x1           # 0043e2cd
    jmp.d8 L_0043e323                            # 0043e2d4
L_0043e2d6:
    # block 0x0043e2d6: entered by ja at 0x0043e289; switch case, 4 instruction(s), ends with je to 0x0043e31c (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0043e2d6
    imul ecx, ecx, 0x8d                          # 0043e2da
    cmp dword ptr [ecx + 0x5bb5e5], 0x0          # 0043e2e0
    je.d8 L_0043e31c                             # 0043e2e7
    # block 0x0043e2e9: entered by fall-through of je at 0x0043e2e7, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e31c
    movsx edx, word ptr [ebp - local_10]         # 0043e2e9
    imul edx, edx, 0x8d                          # 0043e2ed
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043e2f3
    mov dword ptr [ebp - local_14], eax          # 0043e2f9
    mov ecx, dword ptr [ebp - local_14]          # 0043e2fc
    push ecx                                     # 0043e2ff
    call FUN_0051dc6c                            # 0043e300
    add esp, 0x4                                 # 0043e305
    movsx edx, word ptr [ebp - local_10]         # 0043e308
    imul edx, edx, 0x8d                          # 0043e30c
    mov dword ptr [edx + 0x5bb5e5], 0x0          # 0043e312
L_0043e31c:
    # block 0x0043e31c: entered by je at 0x0043e2e7, 1 instruction(s), falls into the block at 0x0043e323
    mov dword ptr [ebp - local_c], 0x1           # 0043e31c
L_0043e323:
    # block 0x0043e323: entered by jmp at 0x0043e2b3; jmp at 0x0043e2cb; jmp at 0x0043e2d4, 2 instruction(s), ends with je to 0x0043e3c1 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 0043e323
    je.d32 L_0043e3c1                            # 0043e327
    # block 0x0043e32d: entered by fall-through of je at 0x0043e327, 25 instruction(s), calls FUN_00423b51, falls into the block at 0x0043e3c1
    movsx eax, word ptr [ebp - local_10]         # 0043e32d
    imul eax, eax, 0x8d                          # 0043e331
    mov byte ptr [eax + 0x5bb5e3], 0x0           # 0043e337
    movsx ecx, word ptr [ebp - local_10]         # 0043e33e
    imul ecx, ecx, 0x8d                          # 0043e342
    mov byte ptr [ecx + 0x5bb625], 0x0           # 0043e348
    movsx edx, word ptr [ebp - local_10]         # 0043e34f
    imul edx, edx, 0x8d                          # 0043e353
    mov dword ptr [edx + 0x5bb626], 0x0          # 0043e359
    movsx eax, word ptr [ebp - local_10]         # 0043e363
    imul eax, eax, 0x8d                          # 0043e367
    mov dword ptr [eax + 0x5bb632], 0x0          # 0043e36d
    movsx ecx, word ptr [ebp - local_10]         # 0043e377
    imul ecx, ecx, 0x8d                          # 0043e37b
    mov word ptr [ecx + 0x5bb636], 0xffff        # 0043e381
    movsx edx, word ptr [ebp - local_10]         # 0043e38a
    imul edx, edx, 0x8d                          # 0043e38e
    mov dword ptr [edx + 0x5bb638], 0x1          # 0043e394
    movsx eax, word ptr [ebp - local_10]         # 0043e39e
    imul eax, eax, 0x8d                          # 0043e3a2
    mov dword ptr [eax + 0x5bb63c], 0x0          # 0043e3a8
    movsx ecx, word ptr [ebp - local_10]         # 0043e3b2
    push ecx                                     # 0043e3b6
    mov ecx, 0x63786d                            # 0043e3b7
    call FUN_00423b51                            # 0043e3bc
L_0043e3c1:
    # block 0x0043e3c1: entered by je at 0x0043e327, 1 instruction(s), ends with backward jump to 0x0043e244
    jmp.d32 L_0043e244                           # 0043e3c1
L_0043e3c6:
    # block 0x0043e3c6: entered by jge at 0x0043e25a, 2 instruction(s), ends with jne to 0x0043e3d5 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0043e3c6
    jne.d8 L_0043e3d5                            # 0043e3ca
    # block 0x0043e3cc: entered by fall-through of jne at 0x0043e3ca, 1 instruction(s), falls into the block at 0x0043e3d5
    mov word ptr [0x5c39e3], 0x0                 # 0043e3cc
L_0043e3d5:
    # block 0x0043e3d5: entered by jne at 0x0043e3ca, 13 instruction(s), calls FUN_0043dbd5, ends with je to 0x0043e44b (forward)
    mov word ptr [0x5c39ff], 0x0                 # 0043e3d5
    mov dword ptr [0x5c39e9], 0x0                # 0043e3de
    mov dword ptr [0x5c39ed], 0x0                # 0043e3e8
    mov dword ptr [0x5c39f1], 0x0                # 0043e3f2
    mov dword ptr [0x5c39f5], 0x0                # 0043e3fc
    mov dword ptr [0x5c39f9], 0x0                # 0043e406
    mov dword ptr [0x5c39e5], 0xffffffff         # 0043e410
    call FUN_0043dbd5                            # 0043e41a
    mov dword ptr [0x63a5c0], 0x0                # 0043e41f
    mov dword ptr [0x63a5c4], 0x0                # 0043e429
    movsx edx, word ptr [0x63a4cd]               # 0043e433
    test edx, edx                                # 0043e43a
    je.d8 L_0043e44b                             # 0043e43c
    # block 0x0043e43e: entered by fall-through of je at 0x0043e43c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043e44b
    push 0x54765c                                # 0043e43e
    call FUN_0044a2b7                            # 0043e443
    add esp, 0x4                                 # 0043e448
L_0043e44b:
    # block 0x0043e44b: entered by je at 0x0043e43c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0043e44b
    pop ebp                                      # 0043e44d
    ret                                          # 0043e44e

# --- data items (not part of the function) -------------------------
.org 0x0043e44f - 0x401000
SWTAB_0043e44f:  # 4 case address(es)
    .long L_0043e2b5 - .text + 0x401000
    .long L_0043e2cd - .text + 0x401000
    .long L_0043e29d - .text + 0x401000
    .long L_0043e2d6 - .text + 0x401000
.org 0x0043e45f - 0x401000
IDXTAB_0043e45f:  # index table of FUN_0043dbe3 for the switch jump at 0x0043e296 (37 byte(s))
    .byte 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
    .byte 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2
    .byte 2, 2, 3, 2, 2
.set SWTAB_0043e44f_VA, SWTAB_0043e44f - .text + 0x401000
.set IDXTAB_0043e45f_VA, IDXTAB_0043e45f - .text + 0x401000

