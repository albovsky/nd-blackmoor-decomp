# FUN_004ea3a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea3a0
# extent:       0x004ea3a0-0x004eaacc (1836 code bytes)
# span:         0x004ea3a0-0x004eaadc (code 1836, tables 16, padding 0)
# sha256:       a43590b585bd6d1c776b6999001a5c695e8246c0a1f2e458c17c391786ff64b0
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ea3a0_lifted
# naming:       native port src/original_methods_fl41.c:m4ea3a0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 19 seeds; oracle: 401/401 instructions, 22/22 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_27, field_2b, field_2f, field_33, field_37, field_3b, field_3f, field_8266, field_8276, field_827a, field_827e, field_8282; [ecx + n] field_23, field_27, field_37, field_3b, field_43, field_699, field_826a, field_826e, field_8272, field_8276, field_827a, field_8282; [edi + n] field_827a, field_8282; [edx + n] field_25, field_2f, field_33, field_37, field_3b, field_3f, field_43, field_8266, field_826a, field_826e, field_8272, field_827a and 2 more
# callees:      calls FUN_004ea1cb, FUN_004fb2e3, FUN_004e9e84, FUN_004db870, FUN_004ea229, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ea3a0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 401 instruction(s), 11 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_1c, 0x1c  # offset -0x1c
.equ arg_8, 0x8  # offset +0x8
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_37, 0x37  # offset +0x37
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_699, 0x699  # offset +0x699
.equ field_8266, 0x8266  # offset +0x8266
.equ field_826a, 0x826a  # offset +0x826a
.equ field_826e, 0x826e  # offset +0x826e
.equ field_8272, 0x8272  # offset +0x8272
.equ field_8276, 0x8276  # offset +0x8276
.equ field_827a, 0x827a  # offset +0x827a
.equ field_827e, 0x827e  # offset +0x827e
.equ field_8282, 0x8282  # offset +0x8282

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_004ea1cb, .text + (0x004ea1cb - 0x401000)
.set FUN_004ea229, .text + (0x004ea229 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ea3a0 - 0x401000
.globl FUN_004ea3a0
FUN_004ea3a0:
    # block 0x004ea3a0: entry, 12 instruction(s), ends with ja to 0x004eaac4 (forward)
    push ebp                                     # 004ea3a0
    {load} mov ebp, esp                          # 004ea3a1
    sub esp, 0x1c                                # 004ea3a3
    push esi                                     # 004ea3a6
    push edi                                     # 004ea3a7
    mov dword ptr [ebp - local_18], ecx          # 004ea3a8
    movsx eax, word ptr [ebp + arg_8]            # 004ea3ab
    imul eax, eax, 0x8d                          # 004ea3af
    mov ecx, dword ptr [eax + 0x5bb632]          # 004ea3b5
    mov dword ptr [ebp - local_1c], ecx          # 004ea3bb
    cmp dword ptr [ebp - local_1c], 0x3          # 004ea3be
    ja.d32 L_004eaac4                            # 004ea3c2
    # block 0x004ea3c8: entered by fall-through of ja at 0x004ea3c2, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4eaacc]
    mov edx, dword ptr [ebp - local_1c]          # 004ea3c8
    jmp dword ptr [4*edx + SWTAB_004eaacc_VA]    # 004ea3cb
L_004ea3d2:
    # block 0x004ea3d2: entered by switch case, 11 instruction(s), calls FUN_004ea1cb, falls into the block at 0x004ea40c
    mov dword ptr [0x5bb1ca], 0x1                # 004ea3d2
    movsx eax, word ptr [ebp + arg_8]            # 004ea3dc
    imul eax, eax, 0x8d                          # 004ea3e0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea3e6
    add ecx, 0x2                                 # 004ea3ec
    push ecx                                     # 004ea3ef
    mov ecx, dword ptr [ebp - local_18]          # 004ea3f0
    call FUN_004ea1cb                            # 004ea3f3
    movsx edx, word ptr [ebp + arg_8]            # 004ea3f8
    imul edx, edx, 0x8d                          # 004ea3fc
    mov dword ptr [edx + 0x5bb632], 0x1          # 004ea402
L_004ea40c:
    # block 0x004ea40c: entered by switch case, 18 instruction(s), ends with forward jump to 0x004ea478
    movsx eax, word ptr [ebp + arg_8]            # 004ea40c
    imul eax, eax, 0x8d                          # 004ea410
    mov dword ptr [eax + 0x5bb626], 0x0          # 004ea416
    mov dword ptr [0x5d1717], 0x0                # 004ea420
    mov ecx, dword ptr [ebp - local_18]          # 004ea42a
    mov edx, dword ptr [ecx + field_699]         # 004ea42d
    mov dword ptr [0x5d170b], edx                # 004ea433
    mov word ptr [0x5d171f], 0x1                 # 004ea439
    mov eax, dword ptr [0x5bb587]                # 004ea442
    mov dword ptr [ebp - local_c], eax           # 004ea447
    mov ecx, dword ptr [0x5bb58f]                # 004ea44a
    mov dword ptr [ebp - local_4], ecx           # 004ea450
    mov edx, dword ptr [0x5bb583]                # 004ea453
    mov dword ptr [ebp - local_10], edx          # 004ea459
    mov eax, dword ptr [0x5bb58b]                # 004ea45c
    mov dword ptr [ebp - local_8], eax           # 004ea461
    mov word ptr [ebp - local_14], 0x0           # 004ea464
    jmp.d8 L_004ea478                            # 004ea46a
L_004ea46c:
    # block 0x004ea46c: entered by jmp at 0x004ea9be, 3 instruction(s), falls into the block at 0x004ea478
    mov cx, word ptr [ebp - local_14]            # 004ea46c
    add cx, 0x1                                  # 004ea470
    mov word ptr [ebp - local_14], cx            # 004ea474
L_004ea478:
    # block 0x004ea478: entered by jmp at 0x004ea46a, 7 instruction(s), ends with jge to 0x004ea9c3 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004ea478
    movsx eax, word ptr [ebp + arg_8]            # 004ea47c
    imul eax, eax, 0x8d                          # 004ea480
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea486
    movsx eax, word ptr [ecx + field_23]         # 004ea48c
    {load} cmp edx, eax                          # 004ea490
    jge.d32 L_004ea9c3                           # 004ea492
    # block 0x004ea498: entered by fall-through of jge at 0x004ea492, 9 instruction(s), ends with jne to 0x004ea9be (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ea498
    imul ecx, ecx, 0x8d                          # 004ea49c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea4a2
    movsx eax, word ptr [ebp - local_14]         # 004ea4a8
    imul eax, eax, 0x22                          # 004ea4ac
    movsx ecx, word ptr [edx + eax + field_25]   # 004ea4af
    movsx edx, word ptr [0x5bb50b]               # 004ea4b4
    {load} cmp ecx, edx                          # 004ea4bb
    jne.d32 L_004ea9be                           # 004ea4bd
    # block 0x004ea4c3: entered by fall-through of jne at 0x004ea4bd, 47 instruction(s), ends with jg to 0x004ea720 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ea4c3
    imul eax, eax, 0x8d                          # 004ea4c7
    mov dword ptr [eax + 0x5bb626], 0x1          # 004ea4cd
    movsx ecx, word ptr [ebp + arg_8]            # 004ea4d7
    imul ecx, ecx, 0x8d                          # 004ea4db
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea4e1
    movsx eax, word ptr [ebp - local_14]         # 004ea4e7
    imul eax, eax, 0x22                          # 004ea4eb
    movsx ecx, word ptr [ebp + arg_8]            # 004ea4ee
    imul ecx, ecx, 0x8d                          # 004ea4f2
    mov dx, word ptr [edx + eax + field_37]      # 004ea4f8
    mov word ptr [ecx + 0x5bb62a], dx            # 004ea4fd
    movsx eax, word ptr [ebp + arg_8]            # 004ea504
    imul eax, eax, 0x8d                          # 004ea508
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea50e
    movsx edx, word ptr [ebp - local_14]         # 004ea514
    imul edx, edx, 0x22                          # 004ea518
    movsx eax, word ptr [ebp + arg_8]            # 004ea51b
    imul eax, eax, 0x8d                          # 004ea51f
    mov cx, word ptr [ecx + edx + field_3b]      # 004ea525
    mov word ptr [eax + 0x5bb62c], cx            # 004ea52a
    movsx edx, word ptr [ebp + arg_8]            # 004ea531
    imul edx, edx, 0x8d                          # 004ea535
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea53b
    movsx ecx, word ptr [ebp - local_14]         # 004ea541
    imul ecx, ecx, 0x22                          # 004ea545
    movsx edx, word ptr [ebp + arg_8]            # 004ea548
    imul edx, edx, 0x8d                          # 004ea54c
    mov ax, word ptr [eax + ecx + field_3f]      # 004ea552
    mov word ptr [edx + 0x5bb62e], ax            # 004ea557
    movsx ecx, word ptr [ebp + arg_8]            # 004ea55e
    imul ecx, ecx, 0x8d                          # 004ea562
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea568
    movsx eax, word ptr [ebp - local_14]         # 004ea56e
    imul eax, eax, 0x22                          # 004ea572
    movsx ecx, word ptr [ebp + arg_8]            # 004ea575
    imul ecx, ecx, 0x8d                          # 004ea579
    mov dx, word ptr [edx + eax + field_43]      # 004ea57f
    mov word ptr [ecx + 0x5bb630], dx            # 004ea584
    movsx eax, word ptr [ebp + arg_8]            # 004ea58b
    imul eax, eax, 0x8d                          # 004ea58f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea595
    movsx edx, word ptr [ebp - local_14]         # 004ea59b
    imul edx, edx, 0x22                          # 004ea59f
    mov eax, dword ptr [ecx + edx + field_43]    # 004ea5a2
    cmp eax, dword ptr [ebp - local_4]           # 004ea5a6
    jg.d32 L_004ea720                            # 004ea5a9
    # block 0x004ea5af: entered by fall-through of jg at 0x004ea5a9, 8 instruction(s), ends with jl to 0x004ea720 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ea5af
    imul ecx, ecx, 0x8d                          # 004ea5b3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea5b9
    movsx eax, word ptr [ebp - local_14]         # 004ea5bf
    imul eax, eax, 0x22                          # 004ea5c3
    mov ecx, dword ptr [edx + eax + field_3b]    # 004ea5c6
    cmp ecx, dword ptr [ebp - local_c]           # 004ea5ca
    jl.d32 L_004ea720                            # 004ea5cd
    # block 0x004ea5d3: entered by fall-through of jl at 0x004ea5cd, 72 instruction(s), ends with forward jump to 0x004ea9bc
    movsx edx, word ptr [ebp + arg_8]            # 004ea5d3
    imul edx, edx, 0x8d                          # 004ea5d7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea5dd
    movsx ecx, word ptr [ebp - local_14]         # 004ea5e3
    imul ecx, ecx, 0x22                          # 004ea5e7
    mov edx, dword ptr [ebp - local_18]          # 004ea5ea
    mov eax, dword ptr [eax + ecx + field_2b]    # 004ea5ed
    mov dword ptr [edx + field_826a], eax        # 004ea5f1
    movsx ecx, word ptr [ebp + arg_8]            # 004ea5f7
    imul ecx, ecx, 0x8d                          # 004ea5fb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea601
    movsx eax, word ptr [ebp - local_14]         # 004ea607
    imul eax, eax, 0x22                          # 004ea60b
    mov ecx, dword ptr [ebp - local_18]          # 004ea60e
    mov edx, dword ptr [edx + eax + field_33]    # 004ea611
    mov dword ptr [ecx + field_8272], edx        # 004ea615
    movsx eax, word ptr [ebp + arg_8]            # 004ea61b
    imul eax, eax, 0x8d                          # 004ea61f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea625
    movsx edx, word ptr [ebp - local_14]         # 004ea62b
    imul edx, edx, 0x22                          # 004ea62f
    mov eax, dword ptr [ebp - local_18]          # 004ea632
    mov ecx, dword ptr [ecx + edx + field_27]    # 004ea635
    mov dword ptr [eax + field_8266], ecx        # 004ea639
    movsx edx, word ptr [ebp + arg_8]            # 004ea63f
    imul edx, edx, 0x8d                          # 004ea643
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea649
    movsx ecx, word ptr [ebp - local_14]         # 004ea64f
    imul ecx, ecx, 0x22                          # 004ea653
    mov edx, dword ptr [ebp - local_18]          # 004ea656
    mov eax, dword ptr [eax + ecx + field_2f]    # 004ea659
    mov dword ptr [edx + field_826e], eax        # 004ea65d
    movsx ecx, word ptr [ebp + arg_8]            # 004ea663
    imul ecx, ecx, 0x8d                          # 004ea667
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea66d
    movsx eax, word ptr [ebp - local_14]         # 004ea673
    imul eax, eax, 0x22                          # 004ea677
    mov ecx, dword ptr [edx + eax + field_3b]    # 004ea67a
    sub ecx, dword ptr [ebp - local_c]           # 004ea67e
    add ecx, dword ptr [0x58318a]                # 004ea681
    mov edx, dword ptr [ebp - local_18]          # 004ea687
    mov dword ptr [edx + field_827a], ecx        # 004ea68a
    movsx eax, word ptr [ebp + arg_8]            # 004ea690
    imul eax, eax, 0x8d                          # 004ea694
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea69a
    movsx edx, word ptr [ebp - local_14]         # 004ea6a0
    imul edx, edx, 0x22                          # 004ea6a4
    mov eax, dword ptr [ecx + edx + field_43]    # 004ea6a7
    sub eax, dword ptr [ebp - local_c]           # 004ea6ab
    add eax, dword ptr [0x58318a]                # 004ea6ae
    mov ecx, dword ptr [ebp - local_18]          # 004ea6b4
    mov dword ptr [ecx + field_8282], eax        # 004ea6b7
    movsx edx, word ptr [ebp + arg_8]            # 004ea6bd
    imul edx, edx, 0x8d                          # 004ea6c1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea6c7
    movsx ecx, word ptr [ebp - local_14]         # 004ea6cd
    imul ecx, ecx, 0x22                          # 004ea6d1
    mov edx, dword ptr [eax + ecx + field_37]    # 004ea6d4
    add edx, dword ptr [0x583186]                # 004ea6d8
    mov eax, dword ptr [ebp - local_18]          # 004ea6de
    mov dword ptr [eax + field_8276], edx        # 004ea6e1
    movsx ecx, word ptr [ebp + arg_8]            # 004ea6e7
    imul ecx, ecx, 0x8d                          # 004ea6eb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea6f1
    movsx eax, word ptr [ebp - local_14]         # 004ea6f7
    imul eax, eax, 0x22                          # 004ea6fb
    mov ecx, dword ptr [edx + eax + field_3f]    # 004ea6fe
    add ecx, dword ptr [0x583186]                # 004ea702
    mov edx, dword ptr [ebp - local_18]          # 004ea708
    mov dword ptr [edx + field_827e], ecx        # 004ea70b
    mov dword ptr [0x5d1717], 0x1                # 004ea711
    jmp.d32 L_004ea9bc                           # 004ea71b
L_004ea720:
    # block 0x004ea720: entered by jg at 0x004ea5a9; jl at 0x004ea5cd, 8 instruction(s), ends with jg to 0x004ea760 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ea720
    imul eax, eax, 0x8d                          # 004ea724
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea72a
    movsx edx, word ptr [ebp - local_14]         # 004ea730
    imul edx, edx, 0x22                          # 004ea734
    mov eax, dword ptr [ecx + edx + field_3b]    # 004ea737
    cmp eax, dword ptr [ebp - local_4]           # 004ea73b
    jg.d8 L_004ea760                             # 004ea73e
    # block 0x004ea740: entered by fall-through of jg at 0x004ea73e, 8 instruction(s), ends with jge to 0x004ea7a8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ea740
    imul ecx, ecx, 0x8d                          # 004ea744
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea74a
    movsx eax, word ptr [ebp - local_14]         # 004ea750
    imul eax, eax, 0x22                          # 004ea754
    mov ecx, dword ptr [edx + eax + field_43]    # 004ea757
    cmp ecx, dword ptr [ebp - local_4]           # 004ea75b
    jge.d8 L_004ea7a8                            # 004ea75e
L_004ea760:
    # block 0x004ea760: entered by jg at 0x004ea73e; fall-through of jge at 0x004ea75e, 8 instruction(s), ends with jg to 0x004ea9bc (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004ea760
    imul edx, edx, 0x8d                          # 004ea764
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea76a
    movsx ecx, word ptr [ebp - local_14]         # 004ea770
    imul ecx, ecx, 0x22                          # 004ea774
    mov edx, dword ptr [eax + ecx + field_3b]    # 004ea777
    cmp edx, dword ptr [ebp - local_c]           # 004ea77b
    jg.d32 L_004ea9bc                            # 004ea77e
    # block 0x004ea784: entered by fall-through of jg at 0x004ea77e, 8 instruction(s), ends with jl to 0x004ea9bc (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ea784
    imul eax, eax, 0x8d                          # 004ea788
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea78e
    movsx edx, word ptr [ebp - local_14]         # 004ea794
    imul edx, edx, 0x22                          # 004ea798
    mov eax, dword ptr [ecx + edx + field_43]    # 004ea79b
    cmp eax, dword ptr [ebp - local_c]           # 004ea79f
    jl.d32 L_004ea9bc                            # 004ea7a2
L_004ea7a8:
    # block 0x004ea7a8: entered by jge at 0x004ea75e; fall-through of jl at 0x004ea7a2, 8 instruction(s), ends with jge to 0x004ea7d6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ea7a8
    imul ecx, ecx, 0x8d                          # 004ea7ac
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea7b2
    movsx eax, word ptr [ebp - local_14]         # 004ea7b8
    imul eax, eax, 0x22                          # 004ea7bc
    mov ecx, dword ptr [edx + eax + field_3b]    # 004ea7bf
    cmp ecx, dword ptr [ebp - local_c]           # 004ea7c3
    jge.d8 L_004ea7d6                            # 004ea7c6
    # block 0x004ea7c8: entered by fall-through of jge at 0x004ea7c6, 4 instruction(s), ends with forward jump to 0x004ea7fa
    mov edx, dword ptr [ebp - local_18]          # 004ea7c8
    mov eax, dword ptr [ebp - local_c]           # 004ea7cb
    mov dword ptr [edx + field_827a], eax        # 004ea7ce
    jmp.d8 L_004ea7fa                            # 004ea7d4
L_004ea7d6:
    # block 0x004ea7d6: entered by jge at 0x004ea7c6, 8 instruction(s), falls into the block at 0x004ea7fa
    movsx ecx, word ptr [ebp + arg_8]            # 004ea7d6
    imul ecx, ecx, 0x8d                          # 004ea7da
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea7e0
    movsx eax, word ptr [ebp - local_14]         # 004ea7e6
    imul eax, eax, 0x22                          # 004ea7ea
    mov ecx, dword ptr [ebp - local_18]          # 004ea7ed
    mov edx, dword ptr [edx + eax + field_3b]    # 004ea7f0
    mov dword ptr [ecx + field_827a], edx        # 004ea7f4
L_004ea7fa:
    # block 0x004ea7fa: entered by jmp at 0x004ea7d4, 8 instruction(s), ends with jle to 0x004ea828 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ea7fa
    imul eax, eax, 0x8d                          # 004ea7fe
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea804
    movsx edx, word ptr [ebp - local_14]         # 004ea80a
    imul edx, edx, 0x22                          # 004ea80e
    mov eax, dword ptr [ecx + edx + field_43]    # 004ea811
    cmp eax, dword ptr [ebp - local_4]           # 004ea815
    jle.d8 L_004ea828                            # 004ea818
    # block 0x004ea81a: entered by fall-through of jle at 0x004ea818, 4 instruction(s), ends with forward jump to 0x004ea84c
    mov ecx, dword ptr [ebp - local_18]          # 004ea81a
    mov edx, dword ptr [ebp - local_4]           # 004ea81d
    mov dword ptr [ecx + field_8282], edx        # 004ea820
    jmp.d8 L_004ea84c                            # 004ea826
L_004ea828:
    # block 0x004ea828: entered by jle at 0x004ea818, 8 instruction(s), falls into the block at 0x004ea84c
    movsx eax, word ptr [ebp + arg_8]            # 004ea828
    imul eax, eax, 0x8d                          # 004ea82c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea832
    movsx edx, word ptr [ebp - local_14]         # 004ea838
    imul edx, edx, 0x22                          # 004ea83c
    mov eax, dword ptr [ebp - local_18]          # 004ea83f
    mov ecx, dword ptr [ecx + edx + field_43]    # 004ea842
    mov dword ptr [eax + field_8282], ecx        # 004ea846
L_004ea84c:
    # block 0x004ea84c: entered by jmp at 0x004ea826, 81 instruction(s), falls into the block at 0x004ea9bc
    movsx edx, word ptr [ebp + arg_8]            # 004ea84c
    imul edx, edx, 0x8d                          # 004ea850
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea856
    movsx ecx, word ptr [ebp - local_14]         # 004ea85c
    imul ecx, ecx, 0x22                          # 004ea860
    movsx edx, word ptr [ebp + arg_8]            # 004ea863
    imul edx, edx, 0x8d                          # 004ea867
    mov edx, dword ptr [edx + 0x5bb5e5]          # 004ea86d
    movsx esi, word ptr [ebp - local_14]         # 004ea873
    imul esi, esi, 0x22                          # 004ea877
    mov edi, dword ptr [ebp - local_18]          # 004ea87a
    mov edi, dword ptr [edi + field_827a]        # 004ea87d
    sub edi, dword ptr [edx + esi + field_3b]    # 004ea883
    mov eax, dword ptr [eax + ecx + field_2b]    # 004ea887
    {load} add eax, edi                          # 004ea88b
    mov ecx, dword ptr [ebp - local_18]          # 004ea88d
    mov dword ptr [ecx + field_826a], eax        # 004ea890
    movsx edx, word ptr [ebp + arg_8]            # 004ea896
    imul edx, edx, 0x8d                          # 004ea89a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea8a0
    movsx ecx, word ptr [ebp - local_14]         # 004ea8a6
    imul ecx, ecx, 0x22                          # 004ea8aa
    movsx edx, word ptr [ebp + arg_8]            # 004ea8ad
    imul edx, edx, 0x8d                          # 004ea8b1
    mov edx, dword ptr [edx + 0x5bb5e5]          # 004ea8b7
    movsx esi, word ptr [ebp - local_14]         # 004ea8bd
    imul esi, esi, 0x22                          # 004ea8c1
    mov edi, dword ptr [ebp - local_18]          # 004ea8c4
    mov edx, dword ptr [edx + esi + field_43]    # 004ea8c7
    sub edx, dword ptr [edi + field_8282]        # 004ea8cb
    mov eax, dword ptr [eax + ecx + field_33]    # 004ea8d1
    {load} sub eax, edx                          # 004ea8d5
    mov ecx, dword ptr [ebp - local_18]          # 004ea8d7
    mov dword ptr [ecx + field_8272], eax        # 004ea8da
    movsx edx, word ptr [ebp + arg_8]            # 004ea8e0
    imul edx, edx, 0x8d                          # 004ea8e4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea8ea
    movsx ecx, word ptr [ebp - local_14]         # 004ea8f0
    imul ecx, ecx, 0x22                          # 004ea8f4
    mov edx, dword ptr [ebp - local_18]          # 004ea8f7
    mov eax, dword ptr [eax + ecx + field_27]    # 004ea8fa
    mov dword ptr [edx + field_8266], eax        # 004ea8fe
    movsx ecx, word ptr [ebp + arg_8]            # 004ea904
    imul ecx, ecx, 0x8d                          # 004ea908
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea90e
    movsx eax, word ptr [ebp - local_14]         # 004ea914
    imul eax, eax, 0x22                          # 004ea918
    mov ecx, dword ptr [ebp - local_18]          # 004ea91b
    mov edx, dword ptr [edx + eax + field_2f]    # 004ea91e
    mov dword ptr [ecx + field_826e], edx        # 004ea922
    mov eax, dword ptr [ebp - local_18]          # 004ea928
    mov ecx, dword ptr [eax + field_827a]        # 004ea92b
    sub ecx, dword ptr [ebp - local_c]           # 004ea931
    add ecx, dword ptr [0x58318a]                # 004ea934
    mov edx, dword ptr [ebp - local_18]          # 004ea93a
    mov dword ptr [edx + field_827a], ecx        # 004ea93d
    mov eax, dword ptr [ebp - local_18]          # 004ea943
    mov ecx, dword ptr [eax + field_8282]        # 004ea946
    sub ecx, dword ptr [ebp - local_c]           # 004ea94c
    add ecx, dword ptr [0x58318a]                # 004ea94f
    mov edx, dword ptr [ebp - local_18]          # 004ea955
    mov dword ptr [edx + field_8282], ecx        # 004ea958
    movsx eax, word ptr [ebp + arg_8]            # 004ea95e
    imul eax, eax, 0x8d                          # 004ea962
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ea968
    movsx edx, word ptr [ebp - local_14]         # 004ea96e
    imul edx, edx, 0x22                          # 004ea972
    mov eax, dword ptr [ecx + edx + field_37]    # 004ea975
    add eax, dword ptr [0x583186]                # 004ea979
    mov ecx, dword ptr [ebp - local_18]          # 004ea97f
    mov dword ptr [ecx + field_8276], eax        # 004ea982
    movsx edx, word ptr [ebp + arg_8]            # 004ea988
    imul edx, edx, 0x8d                          # 004ea98c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004ea992
    movsx ecx, word ptr [ebp - local_14]         # 004ea998
    imul ecx, ecx, 0x22                          # 004ea99c
    mov edx, dword ptr [eax + ecx + field_3f]    # 004ea99f
    add edx, dword ptr [0x583186]                # 004ea9a3
    mov eax, dword ptr [ebp - local_18]          # 004ea9a9
    mov dword ptr [eax + field_827e], edx        # 004ea9ac
    mov dword ptr [0x5d1717], 0x1                # 004ea9b2
L_004ea9bc:
    # block 0x004ea9bc: entered by jmp at 0x004ea71b; jg at 0x004ea77e; jl at 0x004ea7a2, 1 instruction(s), ends with forward jump to 0x004ea9c3
    jmp.d8 L_004ea9c3                            # 004ea9bc
L_004ea9be:
    # block 0x004ea9be: entered by jne at 0x004ea4bd, 1 instruction(s), ends with backward jump to 0x004ea46c
    jmp.d32 L_004ea46c                           # 004ea9be
L_004ea9c3:
    # block 0x004ea9c3: entered by jge at 0x004ea492; jmp at 0x004ea9bc, 1 instruction(s), ends with forward jump to 0x004eaac4
    jmp.d32 L_004eaac4                           # 004ea9c3
L_004ea9c8:
    # block 0x004ea9c8: entered by switch case, 44 instruction(s), calls FUN_004fb2e3, FUN_004e9e84, FUN_004db870, ends with forward jump to 0x004eaac4
    push 0x17                                    # 004ea9c8
    mov ecx, 0x5c3a67                            # 004ea9ca
    call FUN_004fb2e3                            # 004ea9cf
    push 0x1                                     # 004ea9d4
    movsx ecx, word ptr [ebp + arg_8]            # 004ea9d6
    imul ecx, ecx, 0x8d                          # 004ea9da
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ea9e0
    mov ax, word ptr [edx]                       # 004ea9e6
    push eax                                     # 004ea9e9
    mov ecx, dword ptr [ebp - local_18]          # 004ea9ea
    call FUN_004e9e84                            # 004ea9ed
    movsx ecx, word ptr [ebp + arg_8]            # 004ea9f2
    imul ecx, ecx, 0x8d                          # 004ea9f6
    mov dword ptr [ecx + 0x5bb626], 0x0          # 004ea9fc
    mov edx, dword ptr [0x5d03bb]                # 004eaa06
    mov dword ptr [0x5d170b], edx                # 004eaa0c
    mov word ptr [0x5d171f], 0x1                 # 004eaa12
    mov dword ptr [0x5d1717], 0x1                # 004eaa1b
    mov ecx, 0x5830ce                            # 004eaa25
    call FUN_004db870                            # 004eaa2a
    mov eax, dword ptr [ebp - local_18]          # 004eaa2f
    mov ecx, dword ptr [eax + field_827a]        # 004eaa32
    sub ecx, dword ptr [0x58318a]                # 004eaa38
    mov edx, dword ptr [ebp - local_18]          # 004eaa3e
    mov dword ptr [edx + field_826a], ecx        # 004eaa41
    mov eax, dword ptr [ebp - local_18]          # 004eaa47
    mov ecx, dword ptr [eax + field_8282]        # 004eaa4a
    sub ecx, dword ptr [0x58318a]                # 004eaa50
    mov edx, dword ptr [ebp - local_18]          # 004eaa56
    mov dword ptr [edx + field_8272], ecx        # 004eaa59
    mov eax, dword ptr [ebp - local_18]          # 004eaa5f
    mov ecx, dword ptr [eax + field_8276]        # 004eaa62
    sub ecx, dword ptr [0x583186]                # 004eaa68
    mov edx, dword ptr [ebp - local_18]          # 004eaa6e
    mov dword ptr [edx + field_8266], ecx        # 004eaa71
    mov eax, dword ptr [ebp - local_18]          # 004eaa77
    mov ecx, dword ptr [eax + field_827e]        # 004eaa7a
    sub ecx, dword ptr [0x583186]                # 004eaa80
    mov edx, dword ptr [ebp - local_18]          # 004eaa86
    mov dword ptr [edx + field_826e], ecx        # 004eaa89
    movsx eax, word ptr [ebp + arg_8]            # 004eaa8f
    imul eax, eax, 0x8d                          # 004eaa93
    mov dword ptr [eax + 0x5bb632], 0x3          # 004eaa99
    jmp.d8 L_004eaac4                            # 004eaaa3
L_004eaaa5:
    # block 0x004eaaa5: entered by switch case, 7 instruction(s), calls FUN_004ea229, FUN_0042ba3a, falls into the block at 0x004eaac4
    mov dword ptr [0x5d1717], 0x0                # 004eaaa5
    mov ecx, dword ptr [ebp - local_18]          # 004eaaaf
    call FUN_004ea229                            # 004eaab2
    mov cx, word ptr [ebp + arg_8]               # 004eaab7
    push ecx                                     # 004eaabb
    call FUN_0042ba3a                            # 004eaabc
    add esp, 0x4                                 # 004eaac1
L_004eaac4:
    # block 0x004eaac4: entered by ja at 0x004ea3c2; jmp at 0x004ea9c3; jmp at 0x004eaaa3, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004eaac4
    pop esi                                      # 004eaac5
    {load} mov esp, ebp                          # 004eaac6
    pop ebp                                      # 004eaac8
    ret 0x4                                      # 004eaac9

# --- data items (not part of the function) -------------------------
.org 0x004eaacc - 0x401000
SWTAB_004eaacc:  # 4 case address(es)
    .long L_004ea3d2 - .text + 0x401000
    .long L_004ea40c - .text + 0x401000
    .long L_004ea9c8 - .text + 0x401000
    .long L_004eaaa5 - .text + 0x401000
.set SWTAB_004eaacc_VA, SWTAB_004eaacc - .text + 0x401000

