# FUN_0050c382
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c382
# extent:       0x0050c382-0x0050c3b2 (48 code bytes)
# span:         0x0050c382-0x0050c3b2 (code 48, tables 0, padding 0)
# sha256:       d1d5a2b8f39bc29e0525995dd83eb762c77c464c36ba5edb9ad493d1edef7440
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c382
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; ret 0x20 (callee pops 32 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      calls USER32.dll!GrayStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c3b2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0050c382 - 0x401000
.globl FUN_0050c382
FUN_0050c382:
    # block 0x0050c382: entry, 5 instruction(s), ends with je to 0x0050c38f (forward)
    push ebp                                     # 0050c382
    {load} mov ebp, esp                          # 0050c383
    mov eax, dword ptr [ebp + arg_8]             # 0050c385
    test eax, eax                                # 0050c388
    je.d8 L_0050c38f                             # 0050c38a
    # block 0x0050c38c: entered by fall-through of je at 0x0050c38a, 1 instruction(s), falls into the block at 0x0050c38f
    mov eax, dword ptr [eax + field_4]           # 0050c38c
L_0050c38f:
    # block 0x0050c38f: entered by je at 0x0050c38a, 12 instruction(s), calls USER32.dll!GrayStringA, ends with ret 0x20
    push dword ptr [ebp + arg_24]                # 0050c38f
    push dword ptr [ebp + arg_20]                # 0050c392
    push dword ptr [ebp + arg_1c]                # 0050c395
    push dword ptr [ebp + arg_18]                # 0050c398
    push dword ptr [ebp + arg_14]                # 0050c39b
    push dword ptr [ebp + arg_10]                # 0050c39e
    push dword ptr [ebp + arg_c]                 # 0050c3a1
    push eax                                     # 0050c3a4
    push dword ptr [ecx + field_4]               # 0050c3a5
    call dword ptr [0x52a3b4]                    # 0050c3a8
    pop ebp                                      # 0050c3ae
    ret 0x20                                     # 0050c3af

