# FUN_0044c033
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c033
# extent:       0x0044c033-0x0044c05c (41 code bytes)
# span:         0x0044c033-0x0044c05c (code 41, tables 0, padding 0)
# sha256:       f98730ca1d3777e94ceb715ea5219693cd33a30094dabc805bc83653421012a7
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c033
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
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
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0044c033 - 0x401000
.globl FUN_0044c033
FUN_0044c033:
    # block 0x0044c033: entry, 17 instruction(s), ends with ret 0xc
    push ebp                                     # 0044c033
    {load} mov ebp, esp                          # 0044c034
    push ecx                                     # 0044c036
    mov dword ptr [ebp - local_4], ecx           # 0044c037
    mov eax, dword ptr [ebp + arg_8]             # 0044c03a
    fld dword ptr [ebp + arg_10]                 # 0044c03d
    fmul dword ptr [eax]                         # 0044c040
    mov ecx, dword ptr [ebp + arg_c]             # 0044c042
    fstp dword ptr [ecx]                         # 0044c045
    mov edx, dword ptr [ebp + arg_8]             # 0044c047
    fld dword ptr [ebp + arg_10]                 # 0044c04a
    fmul dword ptr [edx + field_4]               # 0044c04d
    mov eax, dword ptr [ebp + arg_c]             # 0044c050
    fstp dword ptr [eax + field_4]               # 0044c053
    {load} mov esp, ebp                          # 0044c056
    pop ebp                                      # 0044c058
    ret 0xc                                      # 0044c059

