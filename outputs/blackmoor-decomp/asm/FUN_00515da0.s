# FUN_00515da0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515da0
# extent:       0x00515da0-0x00515dde (62 code bytes)
# span:         0x00515da0-0x00515de0 (code 62, tables 0, padding 2)
# sha256:       4c3c0d189e565781b80a75768e480fbb7dacced7e613457d8a31b7c0cf82cf76
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515da0
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00515da0 - 0x401000
.globl FUN_00515da0
FUN_00515da0:
    # block 0x00515da0: entry, 14 instruction(s), falls into the block at 0x00515db4
    push ebp                                     # 00515da0
    {load} mov ebp, esp                          # 00515da1
    push esi                                     # 00515da3
    {load} xor eax, eax                          # 00515da4
    push eax                                     # 00515da6
    push eax                                     # 00515da7
    push eax                                     # 00515da8
    push eax                                     # 00515da9
    push eax                                     # 00515daa
    push eax                                     # 00515dab
    push eax                                     # 00515dac
    push eax                                     # 00515dad
    mov edx, dword ptr [ebp + arg_c]             # 00515dae
    {disp8} lea ecx, [ecx]                       # 00515db1
L_00515db4:
    # block 0x00515db4: entered by jmp at 0x00515dbf, 3 instruction(s), ends with je to 0x00515dc1 (forward)
    mov al, byte ptr [edx]                       # 00515db4
    {load} or al, al                             # 00515db6
    je.d8 L_00515dc1                             # 00515db8
    # block 0x00515dba: entered by fall-through of je at 0x00515db8, 3 instruction(s), ends with backward jump to 0x00515db4
    inc edx                                      # 00515dba
    bts dword ptr [esp], eax                     # 00515dbb
    jmp.d8 L_00515db4                            # 00515dbf
L_00515dc1:
    # block 0x00515dc1: entered by je at 0x00515db8, 3 instruction(s), falls into the block at 0x00515dc8
    mov esi, dword ptr [ebp + arg_8]             # 00515dc1
    or ecx, -0x1                                 # 00515dc4
    nop                                          # 00515dc7
L_00515dc8:
    # block 0x00515dc8: entered by jb at 0x00515dd4, 4 instruction(s), ends with je to 0x00515dd6 (forward)
    inc ecx                                      # 00515dc8
    mov al, byte ptr [esi]                       # 00515dc9
    {load} or al, al                             # 00515dcb
    je.d8 L_00515dd6                             # 00515dcd
    # block 0x00515dcf: entered by fall-through of je at 0x00515dcd, 3 instruction(s), ends with jb to 0x00515dc8 (backward)
    inc esi                                      # 00515dcf
    bt dword ptr [esp], eax                      # 00515dd0
    jb.d8 L_00515dc8                             # 00515dd4
L_00515dd6:
    # block 0x00515dd6: entered by je at 0x00515dcd; fall-through of jb at 0x00515dd4, 5 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00515dd6
    add esp, 0x20                                # 00515dd8
    pop esi                                      # 00515ddb
    leave                                        # 00515ddc
    ret                                          # 00515ddd

# --- data items (not part of the function) -------------------------
.org 0x00515dde - 0x401000
PAD_00515dde:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

