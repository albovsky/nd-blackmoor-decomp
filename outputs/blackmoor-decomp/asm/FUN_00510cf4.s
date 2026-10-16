# FUN_00510cf4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510cf4
# extent:       0x00510cf4-0x00510d17 (35 code bytes)
# span:         0x00510cf4-0x00510d20 (code 35, tables 0, padding 9)
# sha256:       bb8e16b687ff07247250aef78b1af60a6ae41a1725039e317d24cf67ed674f86
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510cf4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8; [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00510cf4 - 0x401000
.globl FUN_00510cf4
FUN_00510cf4:
    # block 0x00510cf4: entry, 8 instruction(s), ends with jl to 0x00510d15 (forward)
    mov ecx, dword ptr [esp + stk_8]             # 00510cf4
    push esi                                     # 00510cf8
    mov esi, dword ptr [esp + stk_8]             # 00510cf9
    mov eax, dword ptr [ecx]                     # 00510cfd
    mov edx, dword ptr [ecx + field_4]           # 00510cff
    {load} add eax, esi                          # 00510d02
    test edx, edx                                # 00510d04
    jl.d8 L_00510d15                             # 00510d06
    # block 0x00510d08: entered by fall-through of jl at 0x00510d06, 5 instruction(s), falls into the block at 0x00510d15
    mov esi, dword ptr [edx + esi]               # 00510d08
    mov ecx, dword ptr [ecx + field_8]           # 00510d0b
    mov ecx, dword ptr [esi + ecx]               # 00510d0e
    {load} add ecx, edx                          # 00510d11
    {load} add eax, ecx                          # 00510d13
L_00510d15:
    # block 0x00510d15: entered by jl at 0x00510d06, 2 instruction(s), ends with ret
    pop esi                                      # 00510d15
    ret                                          # 00510d16

# --- data items (not part of the function) -------------------------
.org 0x00510d17 - 0x401000
PAD_00510d17:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

