# FUN_004ee6c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee6c7
# extent:       0x004ee6c7-0x004ee857 (400 code bytes)
# span:         0x004ee6c7-0x004ee86f (code 400, tables 24, padding 0)
# sha256:       578e6becfd6cbbaee343f4454d72bc15cc7006554308d1512734deb43c114d7d
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_popup_poll
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.c:691 says "0x4ee6c7(param): returns 1, or 0 when the popup closed itself."
# name-note:    Popup poll: returns 1, or 0 when the popup closed itself.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_bc, field_15f, field_4ab, field_4af; [ecx + n] field_252, field_4af, field_4b3, field_689; [edx + n] field_4ab, field_4af, field_675, field_685, field_68d
# callees:      calls FUN_004c2790, FUN_004fb2e3, FUN_004db993, FUN_004e29ec, FUN_004ef89b, FUN_004e2913, FUN_004edb97
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 99 instruction(s), 13 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_15f, 0x15f  # offset +0x15f
.equ field_252, 0x252  # offset +0x252
.equ field_4ab, 0x4ab  # offset +0x4ab
.equ field_4af, 0x4af  # offset +0x4af
.equ field_4b3, 0x4b3  # offset +0x4b3
.equ field_675, 0x675  # offset +0x675
.equ field_685, 0x685  # offset +0x685
.equ field_689, 0x689  # offset +0x689
.equ field_68d, 0x68d  # offset +0x68d

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004db993, .text + (0x004db993 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004edb97, .text + (0x004edb97 - 0x401000)
.set FUN_004ef89b, .text + (0x004ef89b - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ee6c7 - 0x401000
.globl FUN_004ee6c7
FUN_004ee6c7:
    # block 0x004ee6c7: entry, 9 instruction(s), ends with ja to 0x004ee84c (forward)
    push ebp                                     # 004ee6c7
    {load} mov ebp, esp                          # 004ee6c8
    sub esp, 0xc                                 # 004ee6ca
    mov dword ptr [ebp - local_4], ecx           # 004ee6cd
    mov eax, dword ptr [ebp - local_4]           # 004ee6d0
    mov ecx, dword ptr [eax + field_4af]         # 004ee6d3
    mov dword ptr [ebp - local_8], ecx           # 004ee6d9
    cmp dword ptr [ebp - local_8], 0x5           # 004ee6dc
    ja.d32 L_004ee84c                            # 004ee6e0
    # block 0x004ee6e6: entered by fall-through of ja at 0x004ee6e0, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4ee857]
    mov edx, dword ptr [ebp - local_8]           # 004ee6e6
    jmp dword ptr [4*edx + SWTAB_004ee857_VA]    # 004ee6e9
L_004ee6f0:
    # block 0x004ee6f0: entered by switch case, 3 instruction(s), ends with jne to 0x004ee722 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee6f0
    cmp dword ptr [eax + field_4ab], 0x0         # 004ee6f3
    jne.d8 L_004ee722                            # 004ee6fa
    # block 0x004ee6fc: entered by fall-through of jne at 0x004ee6fa, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004ee722
    push 0x55cdc8                                # 004ee6fc
    push 0x6                                     # 004ee701
    mov ecx, dword ptr [ebp - local_4]           # 004ee703
    add ecx, 0x2c                                # 004ee706
    push ecx                                     # 004ee709
    push 0x55cdd4                                # 004ee70a
    mov ecx, 0x5cf659                            # 004ee70f
    call FUN_004c2790                            # 004ee714
    mov edx, dword ptr [ebp - local_4]           # 004ee719
    mov dword ptr [edx + field_4ab], eax         # 004ee71c
L_004ee722:
    # block 0x004ee722: entered by jne at 0x004ee6fa, 2 instruction(s), ends with jne to 0x004ee73a (forward)
    cmp dword ptr [0x55cd94], 0x0                # 004ee722
    jne.d8 L_004ee73a                            # 004ee729
    # block 0x004ee72b: entered by fall-through of jne at 0x004ee729, 3 instruction(s), ends with forward jump to 0x004ee747
    mov eax, dword ptr [ebp - local_4]           # 004ee72b
    mov dword ptr [eax + field_4af], 0x4         # 004ee72e
    jmp.d8 L_004ee747                            # 004ee738
L_004ee73a:
    # block 0x004ee73a: entered by jne at 0x004ee729, 2 instruction(s), falls into the block at 0x004ee747
    mov ecx, dword ptr [ebp - local_4]           # 004ee73a
    mov dword ptr [ecx + field_4af], 0x5         # 004ee73d
L_004ee747:
    # block 0x004ee747: entered by jmp at 0x004ee738, 1 instruction(s), ends with forward jump to 0x004ee84c
    jmp.d32 L_004ee84c                           # 004ee747
L_004ee74c:
    # block 0x004ee74c: entered by switch case, 2 instruction(s), ends with je to 0x004ee762 (forward)
    cmp dword ptr [0x55cd94], 0x0                # 004ee74c
    je.d8 L_004ee762                             # 004ee753
    # block 0x004ee755: entered by fall-through of je at 0x004ee753, 2 instruction(s), falls into the block at 0x004ee762
    mov edx, dword ptr [ebp - local_4]           # 004ee755
    mov dword ptr [edx + field_4af], 0x5         # 004ee758
L_004ee762:
    # block 0x004ee762: entered by je at 0x004ee753, 1 instruction(s), ends with forward jump to 0x004ee84c
    jmp.d32 L_004ee84c                           # 004ee762
L_004ee767:
    # block 0x004ee767: entered by switch case, 9 instruction(s), ends with jl to 0x004ee7b4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee767
    mov ecx, dword ptr [ebp - local_4]           # 004ee76a
    mov edx, dword ptr [ecx + field_4b3]         # 004ee76d
    mov dword ptr [eax + field_4af], edx         # 004ee773
    mov eax, dword ptr [ebp - local_4]           # 004ee779
    mov ecx, dword ptr [eax + field_4af]         # 004ee77c
    mov dword ptr [ebp - local_c], ecx           # 004ee782
    cmp dword ptr [ebp - local_c], 0x2           # 004ee785
    jl.d8 L_004ee7b4                             # 004ee789
    # block 0x004ee78b: entered by fall-through of jl at 0x004ee789, 2 instruction(s), ends with jle to 0x004ee793 (forward)
    cmp dword ptr [ebp - local_c], 0x3           # 004ee78b
    jle.d8 L_004ee793                            # 004ee78f
    # block 0x004ee791: entered by fall-through of jle at 0x004ee78f, 1 instruction(s), ends with forward jump to 0x004ee7b4
    jmp.d8 L_004ee7b4                            # 004ee791
L_004ee793:
    # block 0x004ee793: entered by jle at 0x004ee78f, 3 instruction(s), ends with je to 0x004ee7b4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee793
    cmp dword ptr [edx + field_675], 0x0         # 004ee796
    je.d8 L_004ee7b4                             # 004ee79d
    # block 0x004ee79f: entered by fall-through of je at 0x004ee79d, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ee7b4
    mov eax, dword ptr [ebp - local_4]           # 004ee79f
    mov cx, word ptr [eax + field_bc]            # 004ee7a2
    push ecx                                     # 004ee7a9
    mov ecx, 0x5c3a67                            # 004ee7aa
    call FUN_004fb2e3                            # 004ee7af
L_004ee7b4:
    # block 0x004ee7b4: entered by jl at 0x004ee789; jmp at 0x004ee791; je at 0x004ee79d, 2 instruction(s), ends with je to 0x004ee7e2 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004ee7b4
    je.d8 L_004ee7e2                             # 004ee7b8
    # block 0x004ee7ba: entered by fall-through of je at 0x004ee7b8, 9 instruction(s), calls FUN_004db993, falls into the block at 0x004ee7e2
    mov edx, dword ptr [ebp - local_4]           # 004ee7ba
    mov eax, dword ptr [edx + field_68d]         # 004ee7bd
    push eax                                     # 004ee7c3
    mov ecx, dword ptr [ebp - local_4]           # 004ee7c4
    mov edx, dword ptr [ecx + field_689]         # 004ee7c7
    push edx                                     # 004ee7cd
    mov ecx, 0x5830ce                            # 004ee7ce
    call FUN_004db993                            # 004ee7d3
    mov dword ptr [0x5839a9], 0x0                # 004ee7d8
L_004ee7e2:
    # block 0x004ee7e2: entered by je at 0x004ee7b8; switch case, 3 instruction(s), ends with je to 0x004ee7fc (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee7e2
    cmp dword ptr [eax + field_15f], 0x0         # 004ee7e5
    je.d8 L_004ee7fc                             # 004ee7ec
    # block 0x004ee7ee: entered by fall-through of je at 0x004ee7ec, 3 instruction(s), calls FUN_004e29ec, falls into the block at 0x004ee7fc
    mov ecx, dword ptr [ebp - local_4]           # 004ee7ee
    add ecx, 0x31c                               # 004ee7f1
    call FUN_004e29ec                            # 004ee7f7
L_004ee7fc:
    # block 0x004ee7fc: entered by je at 0x004ee7ec, 3 instruction(s), ends with je to 0x004ee816 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee7fc
    cmp dword ptr [ecx + field_252], 0x0         # 004ee7ff
    je.d8 L_004ee816                             # 004ee806
    # block 0x004ee808: entered by fall-through of je at 0x004ee806, 3 instruction(s), calls FUN_004ef89b, falls into the block at 0x004ee816
    mov ecx, dword ptr [ebp - local_4]           # 004ee808
    add ecx, 0x4b7                               # 004ee80b
    call FUN_004ef89b                            # 004ee811
L_004ee816:
    # block 0x004ee816: entered by je at 0x004ee806, 3 instruction(s), ends with je to 0x004ee84c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee816
    cmp dword ptr [edx + field_685], 0x0         # 004ee819
    je.d8 L_004ee84c                             # 004ee820
    # block 0x004ee822: entered by fall-through of je at 0x004ee820, 3 instruction(s), ends with je to 0x004ee84c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee822
    cmp dword ptr [eax + field_15f], 0x0         # 004ee825
    je.d8 L_004ee84c                             # 004ee82c
    # block 0x004ee82e: entered by fall-through of je at 0x004ee82c, 5 instruction(s), calls FUN_004e2913, ends with je to 0x004ee84c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee82e
    add ecx, 0x31c                               # 004ee831
    call FUN_004e2913                            # 004ee837
    test eax, eax                                # 004ee83c
    je.d8 L_004ee84c                             # 004ee83e
    # block 0x004ee840: entered by fall-through of je at 0x004ee83e, 4 instruction(s), calls FUN_004edb97, ends with forward jump to 0x004ee851
    mov ecx, dword ptr [ebp - local_4]           # 004ee840
    call FUN_004edb97                            # 004ee843
    {load} xor eax, eax                          # 004ee848
    jmp.d8 L_004ee851                            # 004ee84a
L_004ee84c:
    # block 0x004ee84c: entered by ja at 0x004ee6e0; jmp at 0x004ee747; jmp at 0x004ee762; je at 0x004ee820; more, 1 instruction(s), falls into the block at 0x004ee851
    mov eax, 0x1                                 # 004ee84c
L_004ee851:
    # block 0x004ee851: entered by jmp at 0x004ee84a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ee851
    pop ebp                                      # 004ee853
    ret 0x4                                      # 004ee854

# --- data items (not part of the function) -------------------------
.org 0x004ee857 - 0x401000
SWTAB_004ee857:  # 6 case address(es)
    .long L_004ee6f0 - .text + 0x401000
    .long L_004ee84c - .text + 0x401000
    .long L_004ee7e2 - .text + 0x401000
    .long L_004ee7e2 - .text + 0x401000
    .long L_004ee74c - .text + 0x401000
    .long L_004ee767 - .text + 0x401000
.set SWTAB_004ee857_VA, SWTAB_004ee857 - .text + 0x401000

