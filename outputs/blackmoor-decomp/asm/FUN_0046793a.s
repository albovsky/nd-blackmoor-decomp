# FUN_0046793a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046793a
# extent:       0x0046793a-0x00467b9e (612 code bytes)
# span:         0x0046793a-0x00467b9e (code 612, tables 0, padding 0)
# sha256:       c37d6efd3aba439e52bc36958a9411b1777d925a244467d0e6271dfd08b485b7
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46793a_click_27ab_27ac
# naming:       native port src/original_methods_fl24b.c:m46793a_click_27ab_27ac (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m46793a_click_27ab_27ac (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 630 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_a, field_1b2, field_1b8, field_1ba, field_240, field_248; [ecx + n] field_1aa, field_1ae, field_1b2, field_1b6, field_1ba, field_1c0, field_240; [edx + n] field_8, field_a, field_c, field_1aa, field_1b6, field_1b8, field_1ba, field_1bc, field_1c4, field_240, field_2bf
# callees:      calls FUN_00467c0e, FUN_00467d5f, FUN_00467e70, FUN_00467eb0, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m46793a_click_27ab_27ac (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 136 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_240, 0x240  # offset +0x240
.equ field_248, 0x248  # offset +0x248
.equ field_2bf, 0x2bf  # offset +0x2bf

# --- external targets -----------------------------------------------
.set FUN_00467c0e, .text + (0x00467c0e - 0x401000)
.set FUN_00467d5f, .text + (0x00467d5f - 0x401000)
.set FUN_00467e70, .text + (0x00467e70 - 0x401000)
.set FUN_00467eb0, .text + (0x00467eb0 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0046793a - 0x401000
.globl FUN_0046793a
FUN_0046793a:
    # block 0x0046793a: entry, 13 instruction(s), ends with je to 0x00467b9a (forward)
    push ebp                                     # 0046793a
    {load} mov ebp, esp                          # 0046793b
    push ecx                                     # 0046793d
    mov dword ptr [ebp - local_4], ecx           # 0046793e
    mov eax, dword ptr [ebp - local_4]           # 00467941
    movsx ecx, word ptr [eax + field_8]          # 00467944
    imul ecx, ecx, 0x8d                          # 00467948
    mov edx, dword ptr [ebp - local_4]           # 0046794e
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00467951
    mov dword ptr [edx + field_1aa], eax         # 00467957
    mov ecx, dword ptr [ebp - local_4]           # 0046795d
    cmp dword ptr [ecx + field_1ae], 0x0         # 00467960
    je.d32 L_00467b9a                            # 00467967
    # block 0x0046796d: entered by fall-through of je at 0x00467967, 3 instruction(s), ends with jne to 0x00467b9a (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046796d
    cmp dword ptr [edx + field_c], 0x0           # 00467970
    jne.d32 L_00467b9a                           # 00467974
    # block 0x0046797a: entered by fall-through of jne at 0x00467974, 5 instruction(s), ends with jne to 0x00467b9a (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046797a
    movsx ecx, word ptr [eax + field_8]          # 0046797d
    imul ecx, ecx, 0x8d                          # 00467981
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 00467987
    jne.d32 L_00467b9a                           # 0046798e
    # block 0x00467994: entered by fall-through of jne at 0x0046798e, 3 instruction(s), ends with jne to 0x00467b9a (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467994
    cmp dword ptr [edx + field_1b6], 0x0         # 00467997
    jne.d32 L_00467b9a                           # 0046799e
    # block 0x004679a4: entered by fall-through of jne at 0x0046799e, 3 instruction(s), ends with jne to 0x00467b9a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004679a4
    cmp dword ptr [eax + field_1b2], 0x0         # 004679a7
    jne.d32 L_00467b9a                           # 004679ae
    # block 0x004679b4: entered by fall-through of jne at 0x004679ae, 2 instruction(s), ends with jne to 0x004679e9 (forward)
    cmp dword ptr [0x5c39e5], 0x27ac             # 004679b4
    jne.d8 L_004679e9                            # 004679be
    # block 0x004679c0: entered by fall-through of jne at 0x004679be, 7 instruction(s), ends with forward jump to 0x00467b9a
    mov ecx, dword ptr [ebp - local_4]           # 004679c0
    mov dword ptr [ecx + field_1b2], 0x1         # 004679c3
    mov edx, dword ptr [ebp - local_4]           # 004679cd
    movsx eax, word ptr [edx + field_8]          # 004679d0
    imul eax, eax, 0x8d                          # 004679d4
    mov dword ptr [eax + 0x5bb632], 0x2          # 004679da
    jmp.d32 L_00467b9a                           # 004679e4
L_004679e9:
    # block 0x004679e9: entered by jne at 0x004679be, 2 instruction(s), ends with jne to 0x00467b9a (forward)
    cmp dword ptr [0x5c39e5], 0x27ab             # 004679e9
    jne.d32 L_00467b9a                           # 004679f3
    # block 0x004679f9: entered by fall-through of jne at 0x004679f3, 3 instruction(s), ends with jne to 0x00467a1a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004679f9
    cmp dword ptr [ecx + field_1ba], -0x1        # 004679fc
    jne.d8 L_00467a1a                            # 00467a03
    # block 0x00467a05: entered by fall-through of jne at 0x00467a03, 5 instruction(s), ends with forward jump to 0x00467b73
    mov edx, dword ptr [ebp - local_4]           # 00467a05
    movsx eax, word ptr [edx + field_a]          # 00467a08
    mov ecx, dword ptr [ebp - local_4]           # 00467a0c
    mov dword ptr [ecx + field_1ba], eax         # 00467a0f
    jmp.d32 L_00467b73                           # 00467a15
L_00467a1a:
    # block 0x00467a1a: entered by jne at 0x00467a03, 5 instruction(s), ends with je to 0x00467ab9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467a1a
    movsx eax, word ptr [edx + field_a]          # 00467a1d
    mov ecx, dword ptr [ebp - local_4]           # 00467a21
    cmp eax, dword ptr [ecx + field_1ba]         # 00467a24
    je.d32 L_00467ab9                            # 00467a2a
    # block 0x00467a30: entered by fall-through of je at 0x00467a2a, 32 instruction(s), calls FUN_00467c0e, FUN_00467d5f, FUN_00467e70, FUN_00467eb0, ends with forward jump to 0x00467b73
    mov edx, dword ptr [ebp - local_4]           # 00467a30
    mov eax, dword ptr [edx + field_240]         # 00467a33
    mov ecx, dword ptr [ebp - local_4]           # 00467a39
    mov edx, dword ptr [ebp - local_4]           # 00467a3c
    mov edx, dword ptr [edx + field_1ba]         # 00467a3f
    mov dword ptr [ecx + 8*eax + field_1c0], edx # 00467a45
    mov eax, dword ptr [ebp - local_4]           # 00467a4c
    movsx ecx, word ptr [eax + field_a]          # 00467a4f
    mov edx, dword ptr [ebp - local_4]           # 00467a53
    mov eax, dword ptr [edx + field_240]         # 00467a56
    mov edx, dword ptr [ebp - local_4]           # 00467a5c
    mov dword ptr [edx + 8*eax + field_1c4], ecx # 00467a5f
    mov eax, dword ptr [ebp - local_4]           # 00467a66
    movsx ecx, word ptr [eax + field_a]          # 00467a69
    mov edx, dword ptr [ebp - local_4]           # 00467a6d
    mov dword ptr [edx + field_1ba], ecx         # 00467a70
    mov eax, dword ptr [ebp - local_4]           # 00467a76
    mov ecx, dword ptr [eax + field_240]         # 00467a79
    add ecx, 0x1                                 # 00467a7f
    mov edx, dword ptr [ebp - local_4]           # 00467a82
    mov dword ptr [edx + field_240], ecx         # 00467a85
    mov ecx, dword ptr [ebp - local_4]           # 00467a8b
    call FUN_00467c0e                            # 00467a8e
    mov ecx, dword ptr [ebp - local_4]           # 00467a93
    mov dword ptr [ecx + field_1b6], eax         # 00467a96
    mov ecx, dword ptr [ebp - local_4]           # 00467a9c
    call FUN_00467d5f                            # 00467a9f
    mov ecx, dword ptr [ebp - local_4]           # 00467aa4
    call FUN_00467e70                            # 00467aa7
    mov ecx, dword ptr [ebp - local_4]           # 00467aac
    call FUN_00467eb0                            # 00467aaf
    jmp.d32 L_00467b73                           # 00467ab4
L_00467ab9:
    # block 0x00467ab9: entered by je at 0x00467a2a, 5 instruction(s), ends with jne to 0x00467b73 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467ab9
    movsx eax, word ptr [edx + field_a]          # 00467abc
    mov ecx, dword ptr [ebp - local_4]           # 00467ac0
    cmp eax, dword ptr [ecx + field_1ba]         # 00467ac3
    jne.d32 L_00467b73                           # 00467ac9
    # block 0x00467acf: entered by fall-through of jne at 0x00467ac9, 3 instruction(s), ends with jne to 0x00467aed (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467acf
    cmp dword ptr [edx + field_240], 0x0         # 00467ad2
    jne.d8 L_00467aed                            # 00467ad9
    # block 0x00467adb: entered by fall-through of jne at 0x00467ad9, 3 instruction(s), ends with forward jump to 0x00467b73
    mov eax, dword ptr [ebp - local_4]           # 00467adb
    mov dword ptr [eax + field_1ba], 0xffffffff  # 00467ade
    jmp.d32 L_00467b73                           # 00467ae8
L_00467aed:
    # block 0x00467aed: entered by jne at 0x00467ad9, 7 instruction(s), ends with je to 0x00467b29 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467aed
    mov edx, dword ptr [ecx + field_240]         # 00467af0
    mov eax, dword ptr [ebp - local_4]           # 00467af6
    mov ecx, dword ptr [ebp - local_4]           # 00467af9
    mov edx, dword ptr [eax + 8*edx + field_1b8] # 00467afc
    cmp edx, dword ptr [ecx + field_1ba]         # 00467b03
    je.d8 L_00467b29                             # 00467b09
    # block 0x00467b0b: entered by fall-through of je at 0x00467b09, 7 instruction(s), ends with jne to 0x00467b73 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467b0b
    mov ecx, dword ptr [eax + field_240]         # 00467b0e
    mov edx, dword ptr [ebp - local_4]           # 00467b14
    mov eax, dword ptr [ebp - local_4]           # 00467b17
    mov ecx, dword ptr [edx + 8*ecx + field_1bc] # 00467b1a
    cmp ecx, dword ptr [eax + field_1ba]         # 00467b21
    jne.d8 L_00467b73                            # 00467b27
L_00467b29:
    # block 0x00467b29: entered by je at 0x00467b09; fall-through of jne at 0x00467b27, 14 instruction(s), ends with jge to 0x00467b73 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467b29
    mov eax, dword ptr [edx + field_240]         # 00467b2c
    mov ecx, dword ptr [ebp - local_4]           # 00467b32
    mov edx, dword ptr [ebp - local_4]           # 00467b35
    mov eax, dword ptr [edx + 8*eax + field_1b8] # 00467b38
    mov dword ptr [ecx + field_1ba], eax         # 00467b3f
    mov ecx, dword ptr [ebp - local_4]           # 00467b45
    mov edx, dword ptr [ecx + field_240]         # 00467b48
    sub edx, 0x1                                 # 00467b4e
    mov eax, dword ptr [ebp - local_4]           # 00467b51
    mov dword ptr [eax + field_240], edx         # 00467b54
    mov ecx, dword ptr [ebp - local_4]           # 00467b5a
    cmp dword ptr [ecx + field_240], 0x0         # 00467b5d
    jge.d8 L_00467b73                            # 00467b64
    # block 0x00467b66: entered by fall-through of jge at 0x00467b64, 2 instruction(s), falls into the block at 0x00467b73
    mov edx, dword ptr [ebp - local_4]           # 00467b66
    mov dword ptr [edx + field_240], 0x0         # 00467b69
L_00467b73:
    # block 0x00467b73: entered by jmp at 0x00467a15; jmp at 0x00467ab4; jne at 0x00467ac9; jmp at 0x00467ae8; more, 3 instruction(s), ends with je to 0x00467b9a (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467b73
    cmp dword ptr [eax + field_248], 0x0         # 00467b76
    je.d8 L_00467b9a                             # 00467b7d
    # block 0x00467b7f: entered by fall-through of je at 0x00467b7d, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00467b9a
    mov ecx, dword ptr [ebp - local_4]           # 00467b7f
    mov edx, dword ptr [ecx + field_1aa]         # 00467b82
    mov ax, word ptr [edx + field_2bf]           # 00467b88
    push eax                                     # 00467b8f
    mov ecx, 0x5c3a67                            # 00467b90
    call FUN_004fb2e3                            # 00467b95
L_00467b9a:
    # block 0x00467b9a: entered by je at 0x00467967; jne at 0x00467974; jne at 0x0046798e; jne at 0x0046799e; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00467b9a
    pop ebp                                      # 00467b9c
    ret                                          # 00467b9d

