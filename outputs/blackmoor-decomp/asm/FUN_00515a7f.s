# FUN_00515a7f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515a7f
# extent:       0x00515a7f-0x00515aa0 (33 code bytes)
# span:         0x00515a7f-0x00515aa0 (code 33, tables 0, padding 0)
# sha256:       c3f4c8bdb1d08fc8b24f65b1fe8101ec14eefbdc92c3ad338d0b2f7b04bf7dfe
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __copysign
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x00515a7f - 0x401000
.globl FUN_00515a7f
FUN_00515a7f:
    # block 0x00515a7f: entry, 14 instruction(s), ends with ret
    push ebp                                     # 00515a7f
    {load} mov ebp, esp                          # 00515a80
    push ecx                                     # 00515a82
    push ecx                                     # 00515a83
    mov eax, dword ptr [ebp + arg_8]             # 00515a84
    mov dword ptr [ebp - local_8], eax           # 00515a87
    mov eax, dword ptr [ebp + arg_14]            # 00515a8a
    xor eax, dword ptr [ebp + arg_c]             # 00515a8d
    and eax, 0x7fffffff                          # 00515a90
    xor eax, dword ptr [ebp + arg_14]            # 00515a95
    mov dword ptr [ebp - local_4], eax           # 00515a98
    fld qword ptr [ebp - local_8]                # 00515a9b
    leave                                        # 00515a9e
    ret                                          # 00515a9f

