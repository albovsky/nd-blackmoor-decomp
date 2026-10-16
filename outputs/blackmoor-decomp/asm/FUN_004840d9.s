# FUN_004840d9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004840d9
# extent:       0x004840d9-0x00484110 (55 code bytes)
# span:         0x004840d9-0x00484110 (code 55, tables 0, padding 0)
# sha256:       bfc4645bf50fb5904256fba0e7a07ec3c0e013770086c7a66f912648de055c6e
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004840d9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_ba7; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_ba7, 0xba7  # offset +0xba7

# --- external targets -----------------------------------------------

.org 0x004840d9 - 0x401000
.globl FUN_004840d9
FUN_004840d9:
    # block 0x004840d9: entry, 7 instruction(s), ends with je to 0x0048410c (forward)
    push ebp                                     # 004840d9
    {load} mov ebp, esp                          # 004840da
    push ecx                                     # 004840dc
    mov dword ptr [ebp - local_4], ecx           # 004840dd
    mov eax, dword ptr [ebp - local_4]           # 004840e0
    cmp dword ptr [eax + field_ba7], 0x0         # 004840e3
    je.d8 L_0048410c                             # 004840ea
    # block 0x004840ec: entered by fall-through of je at 0x004840ea, 4 instruction(s), ends with je to 0x0048410c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004840ec
    movsx edx, word ptr [ecx + field_1c]         # 004840ef
    cmp edx, -0x1                                # 004840f3
    je.d8 L_0048410c                             # 004840f6
    # block 0x004840f8: entered by fall-through of je at 0x004840f6, 4 instruction(s), falls into the block at 0x0048410c
    mov eax, dword ptr [ebp - local_4]           # 004840f8
    movsx ecx, word ptr [eax + field_1c]         # 004840fb
    imul ecx, ecx, 0x4a                          # 004840ff
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00484102
L_0048410c:
    # block 0x0048410c: entered by je at 0x004840ea; je at 0x004840f6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048410c
    pop ebp                                      # 0048410e
    ret                                          # 0048410f

