# FUN_00447e62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447e62
# extent:       0x00447e62-0x00447e78 (22 code bytes)
# span:         0x00447e62-0x00447e78 (code 22, tables 0, padding 0)
# sha256:       bdd6b3475a89760874547f51cdd87227a58c0cc78e2055bb51d0ca5ce2f833e6
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447e62
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e

# --- external targets -----------------------------------------------

.org 0x00447e62 - 0x401000
.globl FUN_00447e62
FUN_00447e62:
    # block 0x00447e62: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 00447e62
    {load} mov ebp, esp                          # 00447e63
    push ecx                                     # 00447e65
    mov dword ptr [ebp - local_4], ecx           # 00447e66
    mov eax, dword ptr [ebp - local_4]           # 00447e69
    mov ecx, dword ptr [ebp + arg_8]             # 00447e6c
    mov dword ptr [eax + field_1e], ecx          # 00447e6f
    {load} mov esp, ebp                          # 00447e72
    pop ebp                                      # 00447e74
    ret 0x4                                      # 00447e75

