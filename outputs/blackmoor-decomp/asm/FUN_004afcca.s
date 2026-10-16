# FUN_004afcca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afcca
# extent:       0x004afcca-0x004afd1e (84 code bytes)
# span:         0x004afcca-0x004afd1e (code 84, tables 0, padding 0)
# sha256:       a7ed7863c3521d68b0648074e392978b058978d5baed67a92edf374127a7eb77
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afcca
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004afd3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004afd3a, .text + (0x004afd3a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004afcca - 0x401000
.globl FUN_004afcca
FUN_004afcca:
    # block 0x004afcca: entry, 23 instruction(s), calls FUN_0051d716, FUN_004afd3a, ends with ret
    push ebp                                     # 004afcca
    {load} mov ebp, esp                          # 004afccb
    push -0x1                                    # 004afccd
    push 0x5286ed                                # 004afccf
    mov eax, dword ptr fs:[0x0]                  # 004afcd4
    push eax                                     # 004afcda
    mov dword ptr fs:[0x0], esp                  # 004afcdb
    push ecx                                     # 004afce2
    mov dword ptr [ebp - local_10], ecx          # 004afce3
    mov ecx, dword ptr [ebp - local_10]          # 004afce6
    call FUN_0051d716                            # 004afce9
    mov dword ptr [ebp - local_4], 0x0           # 004afcee
    mov eax, dword ptr [ebp - local_10]          # 004afcf5
    mov dword ptr [eax], 0x52e010                # 004afcf8
    mov ecx, dword ptr [ebp - local_10]          # 004afcfe
    call FUN_004afd3a                            # 004afd01
    mov dword ptr [ebp - local_4], 0xffffffff    # 004afd06
    mov eax, dword ptr [ebp - local_10]          # 004afd0d
    mov ecx, dword ptr [ebp - local_c]           # 004afd10
    mov dword ptr fs:[0x0], ecx                  # 004afd13
    {load} mov esp, ebp                          # 004afd1a
    pop ebp                                      # 004afd1c
    ret                                          # 004afd1d

