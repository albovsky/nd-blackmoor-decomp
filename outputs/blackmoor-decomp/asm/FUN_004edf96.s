# FUN_004edf96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004edf96
# extent:       0x004edf96-0x004edfaf (25 code bytes)
# span:         0x004edf96-0x004edfaf (code 25, tables 0, padding 0)
# sha256:       862b97f49db13ebd6be19e4ba74589f7095908a1ebf325a5d9ee7f7269ba9369
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004edf96
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4b3
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:caption_ctb_open (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_4b3, 0x4b3  # offset +0x4b3

# --- external targets -----------------------------------------------

.org 0x004edf96 - 0x401000
.globl FUN_004edf96
FUN_004edf96:
    # block 0x004edf96: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004edf96
    {load} mov ebp, esp                          # 004edf97
    push ecx                                     # 004edf99
    mov dword ptr [ebp - local_4], ecx           # 004edf9a
    mov eax, dword ptr [ebp - local_4]           # 004edf9d
    mov ecx, dword ptr [ebp + arg_8]             # 004edfa0
    mov dword ptr [eax + field_4b3], ecx         # 004edfa3
    {load} mov esp, ebp                          # 004edfa9
    pop ebp                                      # 004edfab
    ret 0x4                                      # 004edfac

