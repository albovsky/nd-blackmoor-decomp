# FUN_0043ecc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ecc0
# extent:       0x0043ecc0-0x0043ecfb (59 code bytes)
# span:         0x0043ecc0-0x0043ecfb (code 59, tables 0, padding 0)
# sha256:       bdae5c0a1616a06f8f0557f7a09c725f942ed805d40890d67a1697d4b4132124
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ecc0
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db04f, FUN_0051ab4b
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
.set FUN_004db04f, .text + (0x004db04f - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ecc0 - 0x401000
.globl FUN_0043ecc0
FUN_0043ecc0:
    # block 0x0043ecc0: entry, 21 instruction(s), calls FUN_004db04f, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043ecc0
    {load} mov ebp, esp                          # 0043ecc1
    sub esp, 0x10                                # 0043ecc3
    mov dword ptr [ebp - local_10], ecx          # 0043ecc6
    lea eax, [ebp + arg_c]                       # 0043ecc9
    push eax                                     # 0043eccc
    lea ecx, [ebp + arg_8]                       # 0043eccd
    push ecx                                     # 0043ecd0
    mov ecx, 0x5830a6                            # 0043ecd1
    call FUN_004db04f                            # 0043ecd6
    mov edx, dword ptr [ebp + arg_c]             # 0043ecdb
    mov dword ptr [ebp - local_c], edx           # 0043ecde
    mov eax, dword ptr [ebp + arg_10]            # 0043ece1
    mov dword ptr [ebp - local_8], eax           # 0043ece4
    mov ecx, dword ptr [ebp + arg_8]             # 0043ece7
    mov dword ptr [ebp - local_4], ecx           # 0043ecea
    mov ecx, dword ptr [ebp - local_10]          # 0043eced
    call FUN_0051ab4b                            # 0043ecf0
    {load} mov esp, ebp                          # 0043ecf5
    pop ebp                                      # 0043ecf7
    ret 0xc                                      # 0043ecf8

