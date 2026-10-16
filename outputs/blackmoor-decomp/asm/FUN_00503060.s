# FUN_00503060
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503060
# extent:       0x00503060-0x00503094 (52 code bytes)
# span:         0x00503060-0x005030a0 (code 52, tables 0, padding 12)
# sha256:       0b335905ee9be26d4e2d85bc15f61c0e2267cb8e6631215cdec6dd2cf164fdc5
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503060
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [esi + n] field_c, field_14; [esp + n] stk_8, stk_10, stk_18
# callees:      calls FUN_0050bc80
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x00503060 - 0x401000
.globl FUN_00503060
FUN_00503060:
    # block 0x00503060: entry, 21 instruction(s), calls FUN_0050bc80, ends with ret
    push esi                                     # 00503060
    mov esi, dword ptr [esp + stk_8]             # 00503061
    push edi                                     # 00503065
    mov edi, dword ptr [esp + stk_10]            # 00503066
    mov eax, dword ptr [esi + field_c]           # 0050306a
    mov ecx, dword ptr [eax + field_8]           # 0050306d
    mov eax, dword ptr [esi + field_14]          # 00503070
    mov edx, dword ptr [ecx + 4*edi]             # 00503073
    mov ecx, dword ptr [eax + 4*edi]             # 00503076
    push edx                                     # 00503079
    mov edx, dword ptr [esp + stk_18]            # 0050307a
    push ecx                                     # 0050307e
    push edx                                     # 0050307f
    call FUN_0050bc80                            # 00503080
    mov eax, dword ptr [esi + field_c]           # 00503085
    add esp, 0xc                                 # 00503088
    mov ecx, dword ptr [eax + field_8]           # 0050308b
    mov eax, dword ptr [ecx + 4*edi]             # 0050308e
    pop edi                                      # 00503091
    pop esi                                      # 00503092
    ret                                          # 00503093

# --- data items (not part of the function) -------------------------
.org 0x00503094 - 0x401000
PAD_00503094:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

