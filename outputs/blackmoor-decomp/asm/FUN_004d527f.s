# FUN_004d527f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d527f
# extent:       0x004d527f-0x004d529b (28 code bytes)
# span:         0x004d527f-0x004d529b (code 28, tables 0, padding 0)
# sha256:       6327f7c9e3856fc8d761898bc738d37b6ef78ab4d9178e721120b1fd468a0816
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d527f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d52a6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d52a6, .text + (0x004d52a6 - 0x401000)

.org 0x004d527f - 0x401000
.globl FUN_004d527f
FUN_004d527f:
    # block 0x004d527f: entry, 11 instruction(s), calls FUN_004d52a6, ends with ret
    push ebp                                     # 004d527f
    {load} mov ebp, esp                          # 004d5280
    push ecx                                     # 004d5282
    mov dword ptr [ebp - local_4], ecx           # 004d5283
    mov eax, dword ptr [ebp - local_4]           # 004d5286
    mov dword ptr [eax], 0x52e450                # 004d5289
    mov ecx, dword ptr [ebp - local_4]           # 004d528f
    call FUN_004d52a6                            # 004d5292
    {load} mov esp, ebp                          # 004d5297
    pop ebp                                      # 004d5299
    ret                                          # 004d529a

