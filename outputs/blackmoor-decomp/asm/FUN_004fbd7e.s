# FUN_004fbd7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fbd7e
# extent:       0x004fbd7e-0x004fbd98 (26 code bytes)
# span:         0x004fbd7e-0x004fbd98 (code 26, tables 0, padding 0)
# sha256:       891fb2b97c5f9119c029d22bd0d9629d3a7f3419d9657021289b19327602018b
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fbd7e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fc808
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fbd7e - 0x401000
.globl FUN_004fbd7e
FUN_004fbd7e:
    # block 0x004fbd7e: entry, 11 instruction(s), calls FUN_004fc808, ends with ret
    push ebp                                     # 004fbd7e
    {load} mov ebp, esp                          # 004fbd7f
    push ecx                                     # 004fbd81
    mov dword ptr [ebp - local_4], ecx           # 004fbd82
    mov ax, word ptr [0x5b00d9]                  # 004fbd85
    push eax                                     # 004fbd8b
    mov ecx, dword ptr [ebp - local_4]           # 004fbd8c
    call FUN_004fc808                            # 004fbd8f
    {load} mov esp, ebp                          # 004fbd94
    pop ebp                                      # 004fbd96
    ret                                          # 004fbd97

