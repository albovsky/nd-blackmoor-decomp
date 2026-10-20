# FUN_00513bd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513bd7
# extent:       0x00513bd7-0x00513c13 (60 code bytes)
# span:         0x00513bd7-0x00513c20 (code 60, tables 0, padding 13)
# sha256:       bd96e821e53c26a36a0b0757115cb3224bfeb1e6633f0576c745bdd625c69fe2
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __startOneArgErrorHandling
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_8, local_14, local_18, local_1c, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005187fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00513c20
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_005187fb, .text + (0x005187fb - 0x401000)

.org 0x00513bd7 - 0x401000
.globl FUN_00513bd7
FUN_00513bd7:
    # block 0x00513bd7: entry, 20 instruction(s), calls FUN_005187fb, ends with je to 0x00513c11 (forward)
    push ebp                                     # 00513bd7
    {load} mov ebp, esp                          # 00513bd8
    add esp, -0x20                               # 00513bda
    mov dword ptr [ebp - local_20], eax          # 00513bdd
    fstp qword ptr [ebp - local_8]               # 00513be0
    mov dword ptr [ebp - local_1c], ecx          # 00513be3
    mov eax, dword ptr [ebp + arg_10]            # 00513be6
    mov ecx, dword ptr [ebp + arg_14]            # 00513be9
    mov dword ptr [ebp - local_18], eax          # 00513bec
    mov dword ptr [ebp - local_14], ecx          # 00513bef
    lea eax, [ebp + arg_8]                       # 00513bf2
    lea ecx, [ebp - local_20]                    # 00513bf5
    push eax                                     # 00513bf8
    push ecx                                     # 00513bf9
    push edx                                     # 00513bfa
    call FUN_005187fb                            # 00513bfb
    add esp, 0xc                                 # 00513c00
    fld qword ptr [ebp - local_8]                # 00513c03
    .insn 0x6681/7, dword ptr [ebp + arg_8], 639{:s16} # 00513c06
    je.d8 L_00513c11                             # 00513c0c
    # block 0x00513c0e: entered by fall-through of je at 0x00513c0c, 1 instruction(s), falls into the block at 0x00513c11
    fldcw word ptr [ebp + arg_8]                 # 00513c0e
L_00513c11:
    # block 0x00513c11: entered by je at 0x00513c0c, 2 instruction(s), ends with ret
    leave                                        # 00513c11
    ret                                          # 00513c12

# --- data items (not part of the function) -------------------------
.org 0x00513c13 - 0x401000
PAD_00513c13:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

