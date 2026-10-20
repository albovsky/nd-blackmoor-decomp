# FUN_00459ddc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459ddc
# extent:       0x00459ddc-0x00459e49 (109 code bytes)
# span:         0x00459ddc-0x00459e49 (code 109, tables 0, padding 0)
# sha256:       71b5c77be2c32294a8166741ad002a580fa60dd0a21f7a00b880f38f63ab1f81
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459ddc
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_cc
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------

.org 0x00459ddc - 0x401000
.globl FUN_00459ddc
FUN_00459ddc:
    # block 0x00459ddc: entry, 22 instruction(s), ends with ret 0x4
    push ebp                                     # 00459ddc
    {load} mov ebp, esp                          # 00459ddd
    push ecx                                     # 00459ddf
    mov dword ptr [ebp - local_4], ecx           # 00459de0
    mov dword ptr [0x5c39e5], 0x2742             # 00459de3
    mov eax, dword ptr [ebp - local_4]           # 00459ded
    mov cx, word ptr [ebp + arg_8]               # 00459df0
    mov word ptr [eax + field_cc], cx            # 00459df4
    mov dword ptr [0x5b44f0], 0x16               # 00459dfb
    mov dword ptr [0x5b44f4], 0x1                # 00459e05
    mov edx, dword ptr [0x5d0377]                # 00459e0f
    mov dword ptr [0x5d162d], edx                # 00459e15
    mov eax, dword ptr [0x5b44f0]                # 00459e1b
    shl eax, 0x5                                 # 00459e20
    mov ecx, dword ptr [0x5b44f4]                # 00459e23
    shl ecx, 0x4                                 # 00459e29
    lea edx, [eax + ecx + 0x5b160c]              # 00459e2c
    mov dword ptr [0x5d1631], edx                # 00459e33
    mov dword ptr [0x5d1639], 0x1                # 00459e39
    {load} mov esp, ebp                          # 00459e43
    pop ebp                                      # 00459e45
    ret 0x4                                      # 00459e46

