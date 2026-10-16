# FUN_004a1c2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1c2b
# extent:       0x004a1c2b-0x004a1c47 (28 code bytes)
# span:         0x004a1c2b-0x004a1c47 (code 28, tables 0, padding 0)
# sha256:       880ce7ee64e6e2dfee003897268d9572b063c15fe5780a2cab6fb1e5ea1d1d8c
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1c2b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004a1c2b - 0x401000
.globl FUN_004a1c2b
FUN_004a1c2b:
    # block 0x004a1c2b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004a1c2b
    {load} mov ebp, esp                          # 004a1c2c
    push ecx                                     # 004a1c2e
    mov dword ptr [ebp - local_4], ecx           # 004a1c2f
    mov eax, dword ptr [ebp - local_4]           # 004a1c32
    mov dword ptr [eax], 0x52dc58                # 004a1c35
    mov ecx, dword ptr [ebp - local_4]           # 004a1c3b
    call FUN_0051d730                            # 004a1c3e
    {load} mov esp, ebp                          # 004a1c43
    pop ebp                                      # 004a1c45
    ret                                          # 004a1c46

