# FUN_00515d30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515d30
# extent:       0x00515d30-0x00515d6a (58 code bytes)
# span:         0x00515d30-0x00515d70 (code 58, tables 0, padding 6)
# sha256:       b85331b665adaceaf31fdb61cd5446cf78e53cfed7ca71a732198f9fb62938f3
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515d30
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [esi + n] field_minus_1
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00515d30 - 0x401000
.globl FUN_00515d30
FUN_00515d30:
    # block 0x00515d30: entry, 14 instruction(s), falls into the block at 0x00515d44
    push ebp                                     # 00515d30
    {load} mov ebp, esp                          # 00515d31
    push esi                                     # 00515d33
    {load} xor eax, eax                          # 00515d34
    push eax                                     # 00515d36
    push eax                                     # 00515d37
    push eax                                     # 00515d38
    push eax                                     # 00515d39
    push eax                                     # 00515d3a
    push eax                                     # 00515d3b
    push eax                                     # 00515d3c
    push eax                                     # 00515d3d
    mov edx, dword ptr [ebp + arg_c]             # 00515d3e
    {disp8} lea ecx, [ecx]                       # 00515d41
L_00515d44:
    # block 0x00515d44: entered by jmp at 0x00515d4f, 3 instruction(s), ends with je to 0x00515d51 (forward)
    mov al, byte ptr [edx]                       # 00515d44
    {load} or al, al                             # 00515d46
    je.d8 L_00515d51                             # 00515d48
    # block 0x00515d4a: entered by fall-through of je at 0x00515d48, 3 instruction(s), ends with backward jump to 0x00515d44
    inc edx                                      # 00515d4a
    bts dword ptr [esp], eax                     # 00515d4b
    jmp.d8 L_00515d44                            # 00515d4f
L_00515d51:
    # block 0x00515d51: entered by je at 0x00515d48, 1 instruction(s), falls into the block at 0x00515d54
    mov esi, dword ptr [ebp + arg_8]             # 00515d51
L_00515d54:
    # block 0x00515d54: entered by jae at 0x00515d5f, 3 instruction(s), ends with je to 0x00515d64 (forward)
    mov al, byte ptr [esi]                       # 00515d54
    {load} or al, al                             # 00515d56
    je.d8 L_00515d64                             # 00515d58
    # block 0x00515d5a: entered by fall-through of je at 0x00515d58, 3 instruction(s), ends with jae to 0x00515d54 (backward)
    inc esi                                      # 00515d5a
    bt dword ptr [esp], eax                      # 00515d5b
    jae.d8 L_00515d54                            # 00515d5f
    # block 0x00515d61: entered by fall-through of jae at 0x00515d5f, 1 instruction(s), falls into the block at 0x00515d64
    lea eax, [esi - field_minus_1]               # 00515d61
L_00515d64:
    # block 0x00515d64: entered by je at 0x00515d58, 4 instruction(s), ends with ret
    add esp, 0x20                                # 00515d64
    pop esi                                      # 00515d67
    leave                                        # 00515d68
    ret                                          # 00515d69

# --- data items (not part of the function) -------------------------
.org 0x00515d6a - 0x401000
PAD_00515d6a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

