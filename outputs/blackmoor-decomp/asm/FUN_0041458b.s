# FUN_0041458b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041458b
# extent:       0x0041458b-0x004145a7 (28 code bytes)
# span:         0x0041458b-0x004145a7 (code 28, tables 0, padding 0)
# sha256:       57a283fba1b810a44b7fa7b36811835b2e8cfff5372a3f8cf2fb0288f51d09a5
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041458b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0041458b - 0x401000
.globl FUN_0041458b
FUN_0041458b:
    # block 0x0041458b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0041458b
    {load} mov ebp, esp                          # 0041458c
    push ecx                                     # 0041458e
    mov dword ptr [ebp - local_4], ecx           # 0041458f
    mov eax, dword ptr [ebp - local_4]           # 00414592
    mov dword ptr [eax], 0x52c4f0                # 00414595
    mov ecx, dword ptr [ebp - local_4]           # 0041459b
    call FUN_0051d730                            # 0041459e
    {load} mov esp, ebp                          # 004145a3
    pop ebp                                      # 004145a5
    ret                                          # 004145a6

