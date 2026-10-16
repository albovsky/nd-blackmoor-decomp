# FUN_004a6477
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6477
# extent:       0x004a6477-0x004a64ae (55 code bytes)
# span:         0x004a6477-0x004a64ae (code 55, tables 0, padding 0)
# sha256:       6746269cf9692c3ed24c4f1bdfe35e4b9c0799c77dfc78e440039ba1072fd880
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a6477
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_86; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_86, 0x86  # offset +0x86

# --- external targets -----------------------------------------------

.org 0x004a6477 - 0x401000
.globl FUN_004a6477
FUN_004a6477:
    # block 0x004a6477: entry, 7 instruction(s), ends with je to 0x004a64aa (forward)
    push ebp                                     # 004a6477
    {load} mov ebp, esp                          # 004a6478
    push ecx                                     # 004a647a
    mov dword ptr [ebp - local_4], ecx           # 004a647b
    mov eax, dword ptr [ebp - local_4]           # 004a647e
    cmp dword ptr [eax + field_86], 0x0          # 004a6481
    je.d8 L_004a64aa                             # 004a6488
    # block 0x004a648a: entered by fall-through of je at 0x004a6488, 4 instruction(s), ends with je to 0x004a64aa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a648a
    movsx edx, word ptr [ecx + field_1c]         # 004a648d
    cmp edx, -0x1                                # 004a6491
    je.d8 L_004a64aa                             # 004a6494
    # block 0x004a6496: entered by fall-through of je at 0x004a6494, 4 instruction(s), falls into the block at 0x004a64aa
    mov eax, dword ptr [ebp - local_4]           # 004a6496
    movsx ecx, word ptr [eax + field_1c]         # 004a6499
    imul ecx, ecx, 0x4a                          # 004a649d
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a64a0
L_004a64aa:
    # block 0x004a64aa: entered by je at 0x004a6488; je at 0x004a6494, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a64aa
    pop ebp                                      # 004a64ac
    ret                                          # 004a64ad

