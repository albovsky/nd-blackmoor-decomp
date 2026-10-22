# FUN_004eda10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eda10
# extent:       0x004eda10-0x004eda7c (108 code bytes)
# span:         0x004eda10-0x004eda7c (code 108, tables 0, padding 0)
# sha256:       148d6fb50e339634becd65b3f16afe0a7b2c224491bd8255fd01d3d9cd2d1b9c
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eda10_lifted
# naming:       native port src/original_methods_fl39d.c:m4eda10_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c50, FUN_004ee980, FUN_004edae5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4eda10_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e1c50, .text + (0x004e1c50 - 0x401000)
.set FUN_004edae5, .text + (0x004edae5 - 0x401000)
.set FUN_004ee980, .text + (0x004ee980 - 0x401000)

.org 0x004eda10 - 0x401000
.globl FUN_004eda10
FUN_004eda10:
    # block 0x004eda10: entry, 28 instruction(s), calls FUN_004e1c50, FUN_004ee980, FUN_004edae5, ends with ret
    push ebp                                     # 004eda10
    {load} mov ebp, esp                          # 004eda11
    push -0x1                                    # 004eda13
    push 0x528b0e                                # 004eda15
    mov eax, dword ptr fs:[0x0]                  # 004eda1a
    push eax                                     # 004eda20
    mov dword ptr fs:[0x0], esp                  # 004eda21
    push ecx                                     # 004eda28
    mov dword ptr [ebp - local_10], ecx          # 004eda29
    mov ecx, dword ptr [ebp - local_10]          # 004eda2c
    add ecx, 0x31c                               # 004eda2f
    call FUN_004e1c50                            # 004eda35
    mov dword ptr [ebp - local_4], 0x0           # 004eda3a
    mov ecx, dword ptr [ebp - local_10]          # 004eda41
    add ecx, 0x4b7                               # 004eda44
    call FUN_004ee980                            # 004eda4a
    mov byte ptr [ebp - local_4], 0x1            # 004eda4f
    mov eax, dword ptr [ebp - local_10]          # 004eda53
    mov dword ptr [eax], 0x52e4fc                # 004eda56
    mov ecx, dword ptr [ebp - local_10]          # 004eda5c
    call FUN_004edae5                            # 004eda5f
    mov dword ptr [ebp - local_4], 0xffffffff    # 004eda64
    mov eax, dword ptr [ebp - local_10]          # 004eda6b
    mov ecx, dword ptr [ebp - local_c]           # 004eda6e
    mov dword ptr fs:[0x0], ecx                  # 004eda71
    {load} mov esp, ebp                          # 004eda78
    pop ebp                                      # 004eda7a
    ret                                          # 004eda7b

