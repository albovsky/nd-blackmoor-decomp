# FUN_004b71db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b71db
# extent:       0x004b71db-0x004b71f7 (28 code bytes)
# span:         0x004b71db-0x004b71f7 (code 28, tables 0, padding 0)
# sha256:       ca5d055590986537bcc4bb9581114b071a755fab9c0cdf5ddb41b65ffc92e06a
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b71db
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

.org 0x004b71db - 0x401000
.globl FUN_004b71db
FUN_004b71db:
    # block 0x004b71db: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004b71db
    {load} mov ebp, esp                          # 004b71dc
    push ecx                                     # 004b71de
    mov dword ptr [ebp - local_4], ecx           # 004b71df
    mov eax, dword ptr [ebp - local_4]           # 004b71e2
    mov dword ptr [eax], 0x52e1a8                # 004b71e5
    mov ecx, dword ptr [ebp - local_4]           # 004b71eb
    call FUN_0051d730                            # 004b71ee
    {load} mov esp, ebp                          # 004b71f3
    pop ebp                                      # 004b71f5
    ret                                          # 004b71f6

