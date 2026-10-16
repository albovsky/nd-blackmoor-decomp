# FUN_0051457b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051457b
# extent:       0x0051457b-0x005145a4 (41 code bytes)
# span:         0x0051457b-0x005145a4 (code 41, tables 0, padding 0)
# sha256:       a55b0007bf7a535a9b8bd0ffe43ac8b8d02afcd978055a29207c09f2a0c6bc1d
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051457b
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_e, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_2, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0051457b - 0x401000
.globl FUN_0051457b
FUN_0051457b:
    # block 0x0051457b: entry, 16 instruction(s), ends with ret
    push ebp                                     # 0051457b
    {load} mov ebp, esp                          # 0051457c
    push ecx                                     # 0051457e
    push ecx                                     # 0051457f
    mov eax, dword ptr [ebp + arg_10]            # 00514580
    mov ecx, dword ptr [ebp + arg_e]             # 00514583
    fld qword ptr [ebp + arg_8]                  # 00514586
    add eax, 0x3fe                               # 00514589
    .insn 0x6681/4, ecx, -32753{:s16}            # 0051458e
    fstp qword ptr [ebp - local_8]               # 00514593
    shl eax, 0x4                                 # 00514596
    {load} or eax, ecx                           # 00514599
    mov word ptr [ebp - local_2], ax             # 0051459b
    fld qword ptr [ebp - local_8]                # 0051459f
    leave                                        # 005145a2
    ret                                          # 005145a3

