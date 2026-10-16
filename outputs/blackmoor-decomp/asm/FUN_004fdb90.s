# FUN_004fdb90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdb90
# extent:       0x004fdb90-0x004fdbd5 (69 code bytes)
# span:         0x004fdb90-0x004fdbe0 (code 69, tables 0, padding 11)
# sha256:       9c34f1e4ba9dfcd0057f89a68b3deac6fa2318f2b914e1f6359377993062b7b4
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdb90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8, field_c; [esp + n] stk_20, stk_28
# callees:      calls FUN_004fcff0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x004fdbe0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_004fcff0, .text + (0x004fcff0 - 0x401000)

.org 0x004fdb90 - 0x401000
.globl FUN_004fdb90
FUN_004fdb90:
    # block 0x004fdb90: entry, 25 instruction(s), calls FUN_004fcff0, ends with ret
    push esi                                     # 004fdb90
    push edi                                     # 004fdb91
    sub esp, 0x10                                # 004fdb92
    mov eax, 0x50cf61                            # 004fdb95
    {load} mov edi, esp                          # 004fdb9a
    mov ecx, 0x4fdbe0                            # 004fdb9c
    mov edx, 0x50cee4                            # 004fdba1
    mov esi, 0x50d337                            # 004fdba6
    mov dword ptr [edi], eax                     # 004fdbab
    mov eax, dword ptr [esp + stk_28]            # 004fdbad
    push eax                                     # 004fdbb1
    mov eax, dword ptr [esp + stk_20]            # 004fdbb2
    mov dword ptr [edi + field_4], ecx           # 004fdbb6
    mov ecx, dword ptr [esp + stk_28]            # 004fdbb9
    push ecx                                     # 004fdbbd
    mov dword ptr [edi + field_8], edx           # 004fdbbe
    mov edx, dword ptr [esp + stk_28]            # 004fdbc1
    push edx                                     # 004fdbc5
    push eax                                     # 004fdbc6
    mov dword ptr [edi + field_c], esi           # 004fdbc7
    call FUN_004fcff0                            # 004fdbca
    add esp, 0x20                                # 004fdbcf
    pop edi                                      # 004fdbd2
    pop esi                                      # 004fdbd3
    ret                                          # 004fdbd4

# --- data items (not part of the function) -------------------------
.org 0x004fdbd5 - 0x401000
PAD_004fdbd5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

