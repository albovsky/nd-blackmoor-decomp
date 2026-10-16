# FUN_0044c00a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c00a
# extent:       0x0044c00a-0x0044c033 (41 code bytes)
# span:         0x0044c00a-0x0044c033 (code 41, tables 0, padding 0)
# sha256:       e4be3f158522dac034e41646caa1cdecb8128b2b91714792572ab3de274f9cba
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c00a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [edx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0044c00a - 0x401000
.globl FUN_0044c00a
FUN_0044c00a:
    # block 0x0044c00a: entry, 17 instruction(s), ends with ret 0x8
    push ebp                                     # 0044c00a
    {load} mov ebp, esp                          # 0044c00b
    push ecx                                     # 0044c00d
    mov dword ptr [ebp - local_4], ecx           # 0044c00e
    mov eax, dword ptr [ebp + arg_8]             # 0044c011
    fld dword ptr [ebp + arg_c]                  # 0044c014
    fmul dword ptr [eax]                         # 0044c017
    mov ecx, dword ptr [ebp + arg_8]             # 0044c019
    fstp dword ptr [ecx]                         # 0044c01c
    mov edx, dword ptr [ebp + arg_8]             # 0044c01e
    fld dword ptr [ebp + arg_c]                  # 0044c021
    fmul dword ptr [edx + field_4]               # 0044c024
    mov eax, dword ptr [ebp + arg_8]             # 0044c027
    fstp dword ptr [eax + field_4]               # 0044c02a
    {load} mov esp, ebp                          # 0044c02d
    pop ebp                                      # 0044c02f
    ret 0x8                                      # 0044c030

