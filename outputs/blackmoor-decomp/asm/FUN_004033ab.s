# FUN_004033ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004033ab
# extent:       0x004033ab-0x004033cb (32 code bytes)
# span:         0x004033ab-0x004033cb (code 32, tables 0, padding 0)
# sha256:       3b1ed3c0495eb2e3f16349a5599894195f24fdb58d2fbb6717963a09132602f3
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004033ab
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521b22, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_00521b22, .text + (0x00521b22 - 0x401000)

.org 0x004033ab - 0x401000
.globl FUN_004033ab
FUN_004033ab:
    # block 0x004033ab: entry, 12 instruction(s), calls FUN_00521b22, FUN_004033db, ends with ret
    push ebp                                     # 004033ab
    {load} mov ebp, esp                          # 004033ac
    push ecx                                     # 004033ae
    mov dword ptr [ebp - local_4], ecx           # 004033af
    mov ecx, dword ptr [ebp - local_4]           # 004033b2
    call FUN_00521b22                            # 004033b5
    mov ecx, dword ptr [ebp - local_4]           # 004033ba
    call FUN_004033db                            # 004033bd
    mov eax, 0x1                                 # 004033c2
    {load} mov esp, ebp                          # 004033c7
    pop ebp                                      # 004033c9
    ret                                          # 004033ca

