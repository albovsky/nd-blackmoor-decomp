# FUN_004a9f0b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9f0b
# extent:       0x004a9f0b-0x004a9f27 (28 code bytes)
# span:         0x004a9f0b-0x004a9f27 (code 28, tables 0, padding 0)
# sha256:       344b891ece74d346fa93f027e91123fc8e9f2846c3a453c04ebced4bc2cdf5ac
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a9f0b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004a9f0b - 0x401000
.globl FUN_004a9f0b
FUN_004a9f0b:
    # block 0x004a9f0b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004a9f0b
    {load} mov ebp, esp                          # 004a9f0c
    push ecx                                     # 004a9f0e
    mov dword ptr [ebp - local_4], ecx           # 004a9f0f
    mov eax, dword ptr [ebp - local_4]           # 004a9f12
    mov dword ptr [eax], 0x52de78                # 004a9f15
    mov ecx, dword ptr [ebp - local_4]           # 004a9f1b
    call FUN_0051d730                            # 004a9f1e
    {load} mov esp, ebp                          # 004a9f23
    pop ebp                                      # 004a9f25
    ret                                          # 004a9f26

