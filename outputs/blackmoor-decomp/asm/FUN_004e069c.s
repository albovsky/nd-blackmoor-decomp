# FUN_004e069c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e069c
# extent:       0x004e069c-0x004e06c0 (36 code bytes)
# span:         0x004e069c-0x004e06c0 (code 36, tables 0, padding 0)
# sha256:       c4b3424395eb50e066f47472ab69a231ef2c73c07f0b1995ddd117208554f808
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e069c_copy_in
# naming:       native port src/original_methods_fl39f.c:m4e069c_copy_in (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Copies 0x74b bytes from the pointer argument to [self+0x4] (rep movsd, movsw, movsb), pops 8 bytes; nothing else is written, nothing is called. No jumps; All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4e069c_copy_in (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004e069c - 0x401000
.globl FUN_004e069c
FUN_004e069c:
    # block 0x004e069c: entry, 18 instruction(s), ends with ret 0x8
    push ebp                                     # 004e069c
    {load} mov ebp, esp                          # 004e069d
    push ecx                                     # 004e069f
    push esi                                     # 004e06a0
    push edi                                     # 004e06a1
    mov dword ptr [ebp - local_4], ecx           # 004e06a2
    mov edi, dword ptr [ebp - local_4]           # 004e06a5
    add edi, 0x4                                 # 004e06a8
    mov ecx, 0x1d2                               # 004e06ab
    mov esi, dword ptr [ebp + arg_8]             # 004e06b0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e06b3
    movsw word ptr es:[edi], word ptr [esi]      # 004e06b5
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e06b7
    pop edi                                      # 004e06b8
    pop esi                                      # 004e06b9
    {load} mov esp, ebp                          # 004e06ba
    pop ebp                                      # 004e06bc
    ret 0x8                                      # 004e06bd

