# FUN_00515de0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515de0
# extent:       0x00515de0-0x00515e1e (62 code bytes)
# span:         0x00515de0-0x00515e1e (code 62, tables 0, padding 0)
# sha256:       a90fc2a9b7bee2168ddfeae477154f5678c99472c06ad81ddb8053c3ad8d6aa7
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515de0
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

.org 0x00515de0 - 0x401000
.globl FUN_00515de0
FUN_00515de0:
    # block 0x00515de0: entry, 14 instruction(s), falls into the block at 0x00515df4
    push ebp                                     # 00515de0
    {load} mov ebp, esp                          # 00515de1
    push esi                                     # 00515de3
    {load} xor eax, eax                          # 00515de4
    push eax                                     # 00515de6
    push eax                                     # 00515de7
    push eax                                     # 00515de8
    push eax                                     # 00515de9
    push eax                                     # 00515dea
    push eax                                     # 00515deb
    push eax                                     # 00515dec
    push eax                                     # 00515ded
    mov edx, dword ptr [ebp + arg_c]             # 00515dee
    {disp8} lea ecx, [ecx]                       # 00515df1
L_00515df4:
    # block 0x00515df4: entered by jmp at 0x00515dff, 3 instruction(s), ends with je to 0x00515e01 (forward)
    mov al, byte ptr [edx]                       # 00515df4
    {load} or al, al                             # 00515df6
    je.d8 L_00515e01                             # 00515df8
    # block 0x00515dfa: entered by fall-through of je at 0x00515df8, 3 instruction(s), ends with backward jump to 0x00515df4
    inc edx                                      # 00515dfa
    bts dword ptr [esp], eax                     # 00515dfb
    jmp.d8 L_00515df4                            # 00515dff
L_00515e01:
    # block 0x00515e01: entered by je at 0x00515df8, 3 instruction(s), falls into the block at 0x00515e08
    mov esi, dword ptr [ebp + arg_8]             # 00515e01
    or ecx, -0x1                                 # 00515e04
    nop                                          # 00515e07
L_00515e08:
    # block 0x00515e08: entered by jae at 0x00515e14, 4 instruction(s), ends with je to 0x00515e16 (forward)
    inc ecx                                      # 00515e08
    mov al, byte ptr [esi]                       # 00515e09
    {load} or al, al                             # 00515e0b
    je.d8 L_00515e16                             # 00515e0d
    # block 0x00515e0f: entered by fall-through of je at 0x00515e0d, 3 instruction(s), ends with jae to 0x00515e08 (backward)
    inc esi                                      # 00515e0f
    bt dword ptr [esp], eax                      # 00515e10
    jae.d8 L_00515e08                            # 00515e14
L_00515e16:
    # block 0x00515e16: entered by je at 0x00515e0d; fall-through of jae at 0x00515e14, 5 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00515e16
    add esp, 0x20                                # 00515e18
    pop esi                                      # 00515e1b
    leave                                        # 00515e1c
    ret                                          # 00515e1d

