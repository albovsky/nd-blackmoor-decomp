# FUN_004fcff0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcff0
# extent:       0x004fcff0-0x004fd03c (76 code bytes)
# span:         0x004fcff0-0x004fd040 (code 76, tables 0, padding 4)
# sha256:       fbca3e67743d1a8d7da92eefcbc03d1b62010fc6089345a29cc05cb89c520597
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcff0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [esp + n] stk_14, stk_18, stk_1c, stk_20, stk_24, stk_30, stk_34
# callees:      calls FUN_004fd040, FUN_004fd3e0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_004fd040, .text + (0x004fd040 - 0x401000)
.set FUN_004fd3e0, .text + (0x004fd3e0 - 0x401000)

.org 0x004fcff0 - 0x401000
.globl FUN_004fcff0
FUN_004fcff0:
    # block 0x004fcff0: entry, 23 instruction(s), calls FUN_004fd040, ends with jne to 0x004fd03a (forward)
    mov ecx, dword ptr [esp + stk_14]            # 004fcff0
    push esi                                     # 004fcff4
    mov edx, dword ptr [esp + stk_1c]            # 004fcff5
    sub esp, 0x10                                # 004fcff9
    {load} mov eax, esp                          # 004fcffc
    mov esi, dword ptr [esp + stk_1c]            # 004fcffe
    mov dword ptr [eax], ecx                     # 004fd002
    mov ecx, dword ptr [esp + stk_30]            # 004fd004
    mov dword ptr [eax + field_4], edx           # 004fd008
    mov edx, dword ptr [esp + stk_34]            # 004fd00b
    mov dword ptr [eax + field_8], ecx           # 004fd00f
    mov ecx, dword ptr [esp + stk_20]            # 004fd012
    mov dword ptr [eax + field_c], edx           # 004fd016
    mov eax, dword ptr [esp + stk_24]            # 004fd019
    mov edx, dword ptr [esp + stk_18]            # 004fd01d
    push eax                                     # 004fd021
    push ecx                                     # 004fd022
    push esi                                     # 004fd023
    push edx                                     # 004fd024
    call FUN_004fd040                            # 004fd025
    add esp, 0x20                                # 004fd02a
    test eax, eax                                # 004fd02d
    jne.d8 L_004fd03a                            # 004fd02f
    # block 0x004fd031: entered by fall-through of jne at 0x004fd02f, 3 instruction(s), calls FUN_004fd3e0, falls into the block at 0x004fd03a
    push esi                                     # 004fd031
    call FUN_004fd3e0                            # 004fd032
    add esp, 0x4                                 # 004fd037
L_004fd03a:
    # block 0x004fd03a: entered by jne at 0x004fd02f, 2 instruction(s), ends with ret
    pop esi                                      # 004fd03a
    ret                                          # 004fd03b

# --- data items (not part of the function) -------------------------
.org 0x004fd03c - 0x401000
PAD_004fd03c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

