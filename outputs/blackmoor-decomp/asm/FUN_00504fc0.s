# FUN_00504fc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00504fc0
# extent:       0x00504fc0-0x00504ff7 (55 code bytes)
# span:         0x00504fc0-0x00505000 (code 55, tables 0, padding 9)
# sha256:       7b90faac83469e56c8dd5a1386060cb124452d1466fbd12b3d7201625ea71e0e
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00504fc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8; [esp + n] stk_c
# callees:      calls FUN_0050e97e, FUN_00505000
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00505000, .text + (0x00505000 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x00504fc0 - 0x401000
.globl FUN_00504fc0
FUN_00504fc0:
    # block 0x00504fc0: entry, 23 instruction(s), calls FUN_0050e97e, FUN_00505000, ends with ret
    push esi                                     # 00504fc0
    mov esi, dword ptr [esp + stk_c]             # 00504fc1
    push edi                                     # 00504fc5
    mov edi, dword ptr [esp + stk_c]             # 00504fc6
    lea eax, [esi + 2*esi]                       # 00504fca
    push 0x4                                     # 00504fcd
    push eax                                     # 00504fcf
    mov dword ptr [edi], esi                     # 00504fd0
    call FUN_0050e97e                            # 00504fd2
    push 0x4                                     # 00504fd7
    push 0x20                                    # 00504fd9
    mov dword ptr [edi + field_4], eax           # 00504fdb
    call FUN_0050e97e                            # 00504fde
    mov ecx, dword ptr [edi + field_4]           # 00504fe3
    push eax                                     # 00504fe6
    push ecx                                     # 00504fe7
    push esi                                     # 00504fe8
    mov dword ptr [edi + field_8], eax           # 00504fe9
    call FUN_00505000                            # 00504fec
    add esp, 0x1c                                # 00504ff1
    pop edi                                      # 00504ff4
    pop esi                                      # 00504ff5
    ret                                          # 00504ff6

# --- data items (not part of the function) -------------------------
.org 0x00504ff7 - 0x401000
PAD_00504ff7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

