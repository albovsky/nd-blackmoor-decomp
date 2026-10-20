# FUN_0048ab49
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ab49
# extent:       0x0048ab49-0x0048ac92 (329 code bytes)
# span:         0x0048ab49-0x0048ac92 (code 329, tables 0, padding 0)
# sha256:       35eb42fc1dced8cbe514a122e33d1fb946c9e98e787f561111f93de1a11534d0
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ab49_click_2756_2757
# naming:       native port src/original_methods_fl23b.c:m48ab49_click_2756_2757 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48ab49_click_2756_2757 (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_44, field_1aa, field_1ae, field_1b6; [ecx + n] field_1e, field_48, field_4a, field_1af, field_365, field_3a6; [edx + n] field_4e, field_1b0
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m48ab49_click_2756_2757 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 80 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_365, 0x365  # offset +0x365
.equ field_3a6, 0x3a6  # offset +0x3a6

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0048ab49 - 0x401000
.globl FUN_0048ab49
FUN_0048ab49:
    # block 0x0048ab49: entry, 14 instruction(s), ends with je to 0x0048ac8c (forward)
    push ebp                                     # 0048ab49
    {load} mov ebp, esp                          # 0048ab4a
    sub esp, 0xc                                 # 0048ab4c
    push esi                                     # 0048ab4f
    push edi                                     # 0048ab50
    mov dword ptr [ebp - local_c], ecx           # 0048ab51
    mov eax, dword ptr [ebp - local_c]           # 0048ab54
    movsx ecx, word ptr [eax + field_1e]         # 0048ab57
    imul ecx, ecx, 0x8d                          # 0048ab5b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048ab61
    mov dword ptr [ebp - local_4], edx           # 0048ab67
    mov eax, dword ptr [ebp - local_c]           # 0048ab6a
    cmp dword ptr [eax + field_1aa], 0x0         # 0048ab6d
    je.d32 L_0048ac8c                            # 0048ab74
    # block 0x0048ab7a: entered by fall-through of je at 0x0048ab74, 5 instruction(s), ends with jne to 0x0048ac8c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048ab7a
    {load} xor edx, edx                          # 0048ab7d
    mov dl, byte ptr [ecx + field_1af]           # 0048ab7f
    test edx, edx                                # 0048ab85
    jne.d32 L_0048ac8c                           # 0048ab87
    # block 0x0048ab8d: entered by fall-through of jne at 0x0048ab87, 3 instruction(s), ends with jne to 0x0048ac8c (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048ab8d
    cmp dword ptr [eax + field_1b6], 0x0         # 0048ab90
    jne.d32 L_0048ac8c                           # 0048ab97
    # block 0x0048ab9d: entered by fall-through of jne at 0x0048ab97, 5 instruction(s), ends with jne to 0x0048ac8c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048ab9d
    movsx edx, word ptr [ecx + field_1e]         # 0048aba0
    imul edx, edx, 0x8d                          # 0048aba4
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0048abaa
    jne.d32 L_0048ac8c                           # 0048abb1
    # block 0x0048abb7: entered by fall-through of jne at 0x0048abb1, 2 instruction(s), ends with jne to 0x0048abe9 (forward)
    cmp dword ptr [0x5c39e5], 0x2757             # 0048abb7
    jne.d8 L_0048abe9                            # 0048abc1
    # block 0x0048abc3: entered by fall-through of jne at 0x0048abc1, 7 instruction(s), ends with forward jump to 0x0048ac8c
    mov eax, dword ptr [ebp - local_c]           # 0048abc3
    mov byte ptr [eax + field_1ae], 0x1          # 0048abc6
    mov ecx, dword ptr [ebp - local_c]           # 0048abcd
    movsx edx, word ptr [ecx + field_1e]         # 0048abd0
    imul edx, edx, 0x8d                          # 0048abd4
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048abda
    jmp.d32 L_0048ac8c                           # 0048abe4
L_0048abe9:
    # block 0x0048abe9: entered by jne at 0x0048abc1, 2 instruction(s), ends with jne to 0x0048ac8c (forward)
    cmp dword ptr [0x5c39e5], 0x2756             # 0048abe9
    jne.d32 L_0048ac8c                           # 0048abf3
    # block 0x0048abf9: entered by fall-through of jne at 0x0048abf3, 16 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0048ac8c (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048abf9
    mov dword ptr [eax + field_44], 0x1          # 0048abfc
    mov ecx, dword ptr [ebp - local_c]           # 0048ac03
    mov edx, dword ptr [ebp - local_c]           # 0048ac06
    mov ax, word ptr [edx + field_1b0]           # 0048ac09
    mov word ptr [ecx + field_48], ax            # 0048ac10
    call dword ptr [0x52a23c]                    # 0048ac14
    mov ecx, dword ptr [ebp - local_4]           # 0048ac1a
    movsx edx, word ptr [ecx + field_3a6]        # 0048ac1d
    {load} add eax, edx                          # 0048ac24
    mov ecx, dword ptr [ebp - local_c]           # 0048ac26
    mov dword ptr [ecx + field_4a], eax          # 0048ac29
    mov edx, dword ptr [ebp - local_c]           # 0048ac2c
    mov dword ptr [edx + field_4e], 0x0          # 0048ac2f
    cmp dword ptr [0x5bb1ca], 0x0                # 0048ac36
    je.d8 L_0048ac8c                             # 0048ac3d
    # block 0x0048ac3f: entered by fall-through of je at 0x0048ac3d, 7 instruction(s), ends with je to 0x0048ac8c (forward)
    mov edi, 0x54e364                            # 0048ac3f
    mov esi, dword ptr [ebp - local_4]           # 0048ac44
    add esi, 0x344                               # 0048ac47
    mov ecx, 0x9                                 # 0048ac4d
    {load} xor eax, eax                          # 0048ac52
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048ac54
    je.d8 L_0048ac8c                             # 0048ac56
    # block 0x0048ac58: entered by fall-through of je at 0x0048ac56, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048ac8c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048ac58
    movsx edx, word ptr [ecx + field_365]        # 0048ac5b
    mov dword ptr [ebp - local_8], edx           # 0048ac62
    mov eax, dword ptr [ebp - local_8]           # 0048ac65
    push eax                                     # 0048ac68
    mov ecx, 0x5cf1eb                            # 0048ac69
    call FUN_004f6334                            # 0048ac6e
    test eax, eax                                # 0048ac73
    jne.d8 L_0048ac8c                            # 0048ac75
    # block 0x0048ac77: entered by fall-through of jne at 0x0048ac75, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0048ac8c
    mov ecx, dword ptr [ebp - local_4]           # 0048ac77
    mov dx, word ptr [ecx + field_365]           # 0048ac7a
    push edx                                     # 0048ac81
    mov ecx, 0x5c3a67                            # 0048ac82
    call FUN_004fb2e3                            # 0048ac87
L_0048ac8c:
    # block 0x0048ac8c: entered by je at 0x0048ab74; jne at 0x0048ab87; jne at 0x0048ab97; jne at 0x0048abb1; more, 5 instruction(s), ends with ret
    pop edi                                      # 0048ac8c
    pop esi                                      # 0048ac8d
    {load} mov esp, ebp                          # 0048ac8e
    pop ebp                                      # 0048ac90
    ret                                          # 0048ac91

