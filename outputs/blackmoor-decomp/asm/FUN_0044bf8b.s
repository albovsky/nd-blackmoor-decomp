# FUN_0044bf8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bf8b
# extent:       0x0044bf8b-0x0044bfb2 (39 code bytes)
# span:         0x0044bf8b-0x0044bfb2 (code 39, tables 0, padding 0)
# sha256:       31ae9bb8238a45f9c1f08489d3c9545dedb991ea3a2d379bd6dec7a833e93e47
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044bf8b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [edx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044bf8b - 0x401000
.globl FUN_0044bf8b
FUN_0044bf8b:
    # block 0x0044bf8b: entry, 17 instruction(s), ends with ret 0x4
    push ebp                                     # 0044bf8b
    {load} mov ebp, esp                          # 0044bf8c
    push ecx                                     # 0044bf8e
    mov dword ptr [ebp - local_4], ecx           # 0044bf8f
    mov eax, dword ptr [ebp + arg_8]             # 0044bf92
    fld dword ptr [eax]                          # 0044bf95
    fchs                                         # 0044bf97
    mov ecx, dword ptr [ebp + arg_8]             # 0044bf99
    fstp dword ptr [ecx]                         # 0044bf9c
    mov edx, dword ptr [ebp + arg_8]             # 0044bf9e
    fld dword ptr [edx + field_4]                # 0044bfa1
    fchs                                         # 0044bfa4
    mov eax, dword ptr [ebp + arg_8]             # 0044bfa6
    fstp dword ptr [eax + field_4]               # 0044bfa9
    {load} mov esp, ebp                          # 0044bfac
    pop ebp                                      # 0044bfae
    ret 0x4                                      # 0044bfaf

