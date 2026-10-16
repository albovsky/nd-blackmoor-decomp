# FUN_004a638a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a638a
# extent:       0x004a638a-0x004a63dc (82 code bytes)
# span:         0x004a638a-0x004a63dc (code 82, tables 0, padding 0)
# sha256:       6f674cde679d18cf673ffb1378c9518c1becbb3bf8157fee750938245d82b1e9
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a638a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_25, field_8b; [ecx + n] field_1c, field_86; [edx + n] field_21, field_8a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_86, 0x86  # offset +0x86
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8b, 0x8b  # offset +0x8b

# --- external targets -----------------------------------------------

.org 0x004a638a - 0x401000
.globl FUN_004a638a
FUN_004a638a:
    # block 0x004a638a: entry, 21 instruction(s), ends with ret
    push ebp                                     # 004a638a
    {load} mov ebp, esp                          # 004a638b
    push ecx                                     # 004a638d
    mov dword ptr [ebp - local_4], ecx           # 004a638e
    mov eax, dword ptr [ebp - local_4]           # 004a6391
    mov word ptr [eax + field_1e], 0xffff        # 004a6394
    mov ecx, dword ptr [ebp - local_4]           # 004a639a
    mov word ptr [ecx + field_1c], 0xffff        # 004a639d
    mov edx, dword ptr [ebp - local_4]           # 004a63a3
    mov dword ptr [edx + field_21], 0x0          # 004a63a6
    mov eax, dword ptr [ebp - local_4]           # 004a63ad
    mov dword ptr [eax + field_25], 0x0          # 004a63b0
    mov ecx, dword ptr [ebp - local_4]           # 004a63b7
    mov dword ptr [ecx + field_86], 0x0          # 004a63ba
    mov edx, dword ptr [ebp - local_4]           # 004a63c4
    mov byte ptr [edx + field_8a], 0x0           # 004a63c7
    mov eax, dword ptr [ebp - local_4]           # 004a63ce
    mov byte ptr [eax + field_8b], 0x0           # 004a63d1
    {load} mov esp, ebp                          # 004a63d8
    pop ebp                                      # 004a63da
    ret                                          # 004a63db

