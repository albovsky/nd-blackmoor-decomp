# FUN_004a1efd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1efd
# extent:       0x004a1efd-0x004a1f59 (92 code bytes)
# span:         0x004a1efd-0x004a1f59 (code 92, tables 0, padding 0)
# sha256:       c4c19b2830215f189f9c423872456c4c3081c369e4be2ca7aae4a33adb86e38b
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1efd_click_2760
# naming:       native port src/original_methods_fl23b.c:m4a1efd_click_2760 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4a1efd_click_2760 (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4b, field_4c, field_60; [ecx + n] field_1e, field_4c, field_58
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m4a1efd_click_2760 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4c, 0x4c  # offset +0x4c
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------

.org 0x004a1efd - 0x401000
.globl FUN_004a1efd
FUN_004a1efd:
    # block 0x004a1efd: entry, 7 instruction(s), ends with je to 0x004a1f55 (forward)
    push ebp                                     # 004a1efd
    {load} mov ebp, esp                          # 004a1efe
    push ecx                                     # 004a1f00
    mov dword ptr [ebp - local_4], ecx           # 004a1f01
    mov eax, dword ptr [ebp - local_4]           # 004a1f04
    cmp dword ptr [eax + field_60], 0x0          # 004a1f07
    je.d8 L_004a1f55                             # 004a1f0b
    # block 0x004a1f0d: entered by fall-through of je at 0x004a1f0b, 5 instruction(s), ends with jne to 0x004a1f55 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1f0d
    {load} xor edx, edx                          # 004a1f10
    mov dl, byte ptr [ecx + field_58]            # 004a1f12
    test edx, edx                                # 004a1f15
    jne.d8 L_004a1f55                            # 004a1f17
    # block 0x004a1f19: entered by fall-through of jne at 0x004a1f17, 3 instruction(s), ends with jne to 0x004a1f55 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a1f19
    cmp dword ptr [eax + field_4c], 0x0          # 004a1f1c
    jne.d8 L_004a1f55                            # 004a1f20
    # block 0x004a1f22: entered by fall-through of jne at 0x004a1f20, 5 instruction(s), ends with jne to 0x004a1f55 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1f22
    movsx edx, word ptr [ecx + field_1e]         # 004a1f25
    imul edx, edx, 0x8d                          # 004a1f29
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004a1f2f
    jne.d8 L_004a1f55                            # 004a1f36
    # block 0x004a1f38: entered by fall-through of jne at 0x004a1f36, 2 instruction(s), ends with jne to 0x004a1f55 (forward)
    cmp dword ptr [0x5c39e5], 0x2760             # 004a1f38
    jne.d8 L_004a1f55                            # 004a1f42
    # block 0x004a1f44: entered by fall-through of jne at 0x004a1f42, 4 instruction(s), falls into the block at 0x004a1f55
    mov eax, dword ptr [ebp - local_4]           # 004a1f44
    mov byte ptr [eax + field_4b], 0x1           # 004a1f47
    mov ecx, dword ptr [ebp - local_4]           # 004a1f4b
    mov dword ptr [ecx + field_4c], 0x3          # 004a1f4e
L_004a1f55:
    # block 0x004a1f55: entered by je at 0x004a1f0b; jne at 0x004a1f17; jne at 0x004a1f20; jne at 0x004a1f36; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a1f55
    pop ebp                                      # 004a1f57
    ret                                          # 004a1f58

