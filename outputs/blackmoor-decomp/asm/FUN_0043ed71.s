# FUN_0043ed71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ed71
# extent:       0x0043ed71-0x0043edac (59 code bytes)
# span:         0x0043ed71-0x0043edac (code 59, tables 0, padding 0)
# sha256:       d345c1b9550c4a62de404b7cb4c505ed6ef4dd7f8442298b01f41654ea769e19
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ed71
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004daf9f, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:pointer (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004daf9f, .text + (0x004daf9f - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ed71 - 0x401000
.globl FUN_0043ed71
FUN_0043ed71:
    # block 0x0043ed71: entry, 21 instruction(s), calls FUN_004daf9f, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043ed71
    {load} mov ebp, esp                          # 0043ed72
    sub esp, 0x10                                # 0043ed74
    mov dword ptr [ebp - local_10], ecx          # 0043ed77
    lea eax, [ebp + arg_c]                       # 0043ed7a
    push eax                                     # 0043ed7d
    lea ecx, [ebp + arg_8]                       # 0043ed7e
    push ecx                                     # 0043ed81
    mov ecx, 0x5830a6                            # 0043ed82
    call FUN_004daf9f                            # 0043ed87
    mov edx, dword ptr [ebp + arg_c]             # 0043ed8c
    mov dword ptr [ebp - local_c], edx           # 0043ed8f
    mov eax, dword ptr [ebp + arg_10]            # 0043ed92
    mov dword ptr [ebp - local_8], eax           # 0043ed95
    mov ecx, dword ptr [ebp + arg_8]             # 0043ed98
    mov dword ptr [ebp - local_4], ecx           # 0043ed9b
    mov ecx, dword ptr [ebp - local_10]          # 0043ed9e
    call FUN_0051ab4b                            # 0043eda1
    {load} mov esp, ebp                          # 0043eda6
    pop ebp                                      # 0043eda8
    ret 0xc                                      # 0043eda9

