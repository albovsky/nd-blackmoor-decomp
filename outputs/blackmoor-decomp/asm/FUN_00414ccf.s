# FUN_00414ccf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414ccf
# extent:       0x00414ccf-0x00414ceb (28 code bytes)
# span:         0x00414ccf-0x00414ceb (code 28, tables 0, padding 0)
# sha256:       4b625db212f2f7b6241d76a5f1b3f2810267d31ebd2627dadaa53a7caa44a97e
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00414ccf
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

.org 0x00414ccf - 0x401000
.globl FUN_00414ccf
FUN_00414ccf:
    # block 0x00414ccf: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00414ccf
    {load} mov ebp, esp                          # 00414cd0
    push ecx                                     # 00414cd2
    mov dword ptr [ebp - local_4], ecx           # 00414cd3
    mov eax, dword ptr [ebp - local_4]           # 00414cd6
    mov dword ptr [eax], 0x52c540                # 00414cd9
    mov ecx, dword ptr [ebp - local_4]           # 00414cdf
    call FUN_0051d730                            # 00414ce2
    {load} mov esp, ebp                          # 00414ce7
    pop ebp                                      # 00414ce9
    ret                                          # 00414cea

