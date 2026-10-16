# FUN_004d3c42
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c42
# extent:       0x004d3c42-0x004d3c5f (29 code bytes)
# span:         0x004d3c42-0x004d3c5f (code 29, tables 0, padding 0)
# sha256:       641260cf5f094ffc365ad74ea43d96aa6336db14f1f7db18aac4ec00504bac36
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3c42
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c
# callees:      calls FUN_004d3bef
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004d3bef, .text + (0x004d3bef - 0x401000)

.org 0x004d3c42 - 0x401000
.globl FUN_004d3c42
FUN_004d3c42:
    # block 0x004d3c42: entry, 11 instruction(s), calls FUN_004d3bef, ends with ret
    push ebp                                     # 004d3c42
    {load} mov ebp, esp                          # 004d3c43
    push ecx                                     # 004d3c45
    mov dword ptr [ebp - local_4], ecx           # 004d3c46
    mov eax, dword ptr [ebp - local_4]           # 004d3c49
    mov dword ptr [eax + field_1c], 0x1          # 004d3c4c
    mov ecx, dword ptr [ebp - local_4]           # 004d3c53
    call FUN_004d3bef                            # 004d3c56
    {load} mov esp, ebp                          # 004d3c5b
    pop ebp                                      # 004d3c5d
    ret                                          # 004d3c5e

