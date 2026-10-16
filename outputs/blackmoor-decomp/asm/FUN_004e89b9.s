# FUN_004e89b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e89b9
# extent:       0x004e89b9-0x004e89d2 (25 code bytes)
# span:         0x004e89b9-0x004e89d2 (code 25, tables 0, padding 0)
# sha256:       7098f2e52b98e6454cc0da37a4256fa7d3127e43da413849a66535eed41b19a8
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e89b9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edfaf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004edfaf, .text + (0x004edfaf - 0x401000)

.org 0x004e89b9 - 0x401000
.globl FUN_004e89b9
FUN_004e89b9:
    # block 0x004e89b9: entry, 11 instruction(s), calls FUN_004edfaf, ends with ret 0x4
    push ebp                                     # 004e89b9
    {load} mov ebp, esp                          # 004e89ba
    push ecx                                     # 004e89bc
    mov dword ptr [ebp - local_4], ecx           # 004e89bd
    mov eax, dword ptr [ebp + arg_8]             # 004e89c0
    push eax                                     # 004e89c3
    mov ecx, dword ptr [ebp - local_4]           # 004e89c4
    call FUN_004edfaf                            # 004e89c7
    {load} mov esp, ebp                          # 004e89cc
    pop ebp                                      # 004e89ce
    ret 0x4                                      # 004e89cf

