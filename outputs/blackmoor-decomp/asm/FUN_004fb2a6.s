# FUN_004fb2a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb2a6
# extent:       0x004fb2a6-0x004fb2e3 (61 code bytes)
# span:         0x004fb2a6-0x004fb2e3 (code 61, tables 0, padding 0)
# sha256:       65e719953fa348882d3b1f80d555dfd05b5057802cfeab9ae95630274bdce52d
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb2a6
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_132
# callees:      calls FUN_004faf98
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)

.org 0x004fb2a6 - 0x401000
.globl FUN_004fb2a6
FUN_004fb2a6:
    # block 0x004fb2a6: entry, 12 instruction(s), ends with jne to 0x004fb2dd (forward)
    push ebp                                     # 004fb2a6
    {load} mov ebp, esp                          # 004fb2a7
    push ecx                                     # 004fb2a9
    mov dword ptr [ebp - local_4], ecx           # 004fb2aa
    mov eax, dword ptr [ebp + arg_c]             # 004fb2ad
    and eax, 0xffff                              # 004fb2b0
    imul eax, eax, 0x5bb                         # 004fb2b5
    mov ecx, dword ptr [ebp - local_4]           # 004fb2bb
    {load} xor edx, edx                          # 004fb2be
    mov dx, word ptr [ecx + eax + field_132]     # 004fb2c0
    test edx, edx                                # 004fb2c8
    jne.d8 L_004fb2dd                            # 004fb2ca
    # block 0x004fb2cc: entered by fall-through of jne at 0x004fb2ca, 6 instruction(s), calls FUN_004faf98, falls into the block at 0x004fb2dd
    mov ax, word ptr [ebp + arg_c]               # 004fb2cc
    push eax                                     # 004fb2d0
    mov ecx, dword ptr [ebp + arg_8]             # 004fb2d1
    push ecx                                     # 004fb2d4
    mov ecx, dword ptr [ebp - local_4]           # 004fb2d5
    call FUN_004faf98                            # 004fb2d8
L_004fb2dd:
    # block 0x004fb2dd: entered by jne at 0x004fb2ca, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004fb2dd
    pop ebp                                      # 004fb2df
    ret 0x8                                      # 004fb2e0

