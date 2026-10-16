# FUN_0044c1a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c1a3
# extent:       0x0044c1a3-0x0044c223 (128 code bytes)
# span:         0x0044c1a3-0x0044c223 (code 128, tables 0, padding 0)
# sha256:       20d23ebbacf052a0f4dfc0d35a8d9c6fa7c3c9d9985d6df166a4c13023969a73
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c1a3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [ecx + n] field_4; [edx + n] field_4
# callees:      calls FUN_0050e104, FUN_0050e054, FUN_0044bf4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0044bf4b, .text + (0x0044bf4b - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)

.org 0x0044c1a3 - 0x401000
.globl FUN_0044c1a3
FUN_0044c1a3:
    # block 0x0044c1a3: entry, 44 instruction(s), calls FUN_0050e104, FUN_0050e054, FUN_0044bf4b, ends with ret 0xc
    push ebp                                     # 0044c1a3
    {load} mov ebp, esp                          # 0044c1a4
    sub esp, 0x10                                # 0044c1a6
    mov dword ptr [ebp - local_10], ecx          # 0044c1a9
    fld dword ptr [ebp + arg_10]                 # 0044c1ac
    fmul dword ptr [0x52cbf8]                    # 0044c1af
    fstp dword ptr [ebp - local_c]               # 0044c1b5
    fld dword ptr [ebp - local_c]                # 0044c1b8
    sub esp, 0x8                                 # 0044c1bb
    fstp qword ptr [esp]                         # 0044c1be
    call FUN_0050e104                            # 0044c1c1
    add esp, 0x8                                 # 0044c1c6
    fstp dword ptr [ebp - local_4]               # 0044c1c9
    fld dword ptr [ebp - local_c]                # 0044c1cc
    sub esp, 0x8                                 # 0044c1cf
    fstp qword ptr [esp]                         # 0044c1d2
    call FUN_0050e054                            # 0044c1d5
    add esp, 0x8                                 # 0044c1da
    fstp dword ptr [ebp - local_8]               # 0044c1dd
    mov eax, dword ptr [ebp + arg_8]             # 0044c1e0
    fld dword ptr [ebp - local_8]                # 0044c1e3
    fmul dword ptr [eax]                         # 0044c1e6
    mov ecx, dword ptr [ebp + arg_8]             # 0044c1e8
    fld dword ptr [ebp - local_4]                # 0044c1eb
    fmul dword ptr [ecx + field_4]               # 0044c1ee
    fsubp st(1), st                              # 0044c1f1
    mov edx, dword ptr [ebp + arg_c]             # 0044c1f3
    fstp dword ptr [edx]                         # 0044c1f6
    mov eax, dword ptr [ebp + arg_8]             # 0044c1f8
    fld dword ptr [ebp - local_4]                # 0044c1fb
    fmul dword ptr [eax]                         # 0044c1fe
    mov ecx, dword ptr [ebp + arg_8]             # 0044c200
    fld dword ptr [ebp - local_8]                # 0044c203
    fmul dword ptr [ecx + field_4]               # 0044c206
    faddp st(1), st                              # 0044c209
    mov edx, dword ptr [ebp + arg_c]             # 0044c20b
    fstp dword ptr [edx + field_4]               # 0044c20e
    mov eax, dword ptr [ebp + arg_c]             # 0044c211
    push eax                                     # 0044c214
    mov ecx, dword ptr [ebp - local_10]          # 0044c215
    call FUN_0044bf4b                            # 0044c218
    {load} mov esp, ebp                          # 0044c21d
    pop ebp                                      # 0044c21f
    ret 0xc                                      # 0044c220

