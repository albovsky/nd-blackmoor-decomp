# FUN_0044c05c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c05c
# extent:       0x0044c05c-0x0044c08a (46 code bytes)
# span:         0x0044c05c-0x0044c08a (code 46, tables 0, padding 0)
# sha256:       8208ace84b41828e46f149b5dff790e5aedb551a1b6294354343ea7b0d2e962b
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c05c
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_4; [edx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0044c05c - 0x401000
.globl FUN_0044c05c
FUN_0044c05c:
    # block 0x0044c05c: entry, 19 instruction(s), ends with ret 0x8
    push ebp                                     # 0044c05c
    {load} mov ebp, esp                          # 0044c05d
    push ecx                                     # 0044c05f
    mov dword ptr [ebp - local_4], ecx           # 0044c060
    mov eax, dword ptr [ebp + arg_8]             # 0044c063
    mov ecx, dword ptr [ebp + arg_c]             # 0044c066
    fld dword ptr [eax]                          # 0044c069
    fadd dword ptr [ecx]                         # 0044c06b
    mov edx, dword ptr [ebp + arg_8]             # 0044c06d
    fstp dword ptr [edx]                         # 0044c070
    mov eax, dword ptr [ebp + arg_8]             # 0044c072
    mov ecx, dword ptr [ebp + arg_c]             # 0044c075
    fld dword ptr [eax + field_4]                # 0044c078
    fadd dword ptr [ecx + field_4]               # 0044c07b
    mov edx, dword ptr [ebp + arg_8]             # 0044c07e
    fstp dword ptr [edx + field_4]               # 0044c081
    {load} mov esp, ebp                          # 0044c084
    pop ebp                                      # 0044c086
    ret 0x8                                      # 0044c087

