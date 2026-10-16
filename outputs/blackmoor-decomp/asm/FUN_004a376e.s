# FUN_004a376e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a376e
# extent:       0x004a376e-0x004a378a (28 code bytes)
# span:         0x004a376e-0x004a378a (code 28, tables 0, padding 0)
# sha256:       c85e519ba77eb68ea450072b7d092748f63c6c3ab0221b7be703a309337068b7
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a376e
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

.org 0x004a376e - 0x401000
.globl FUN_004a376e
FUN_004a376e:
    # block 0x004a376e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004a376e
    {load} mov ebp, esp                          # 004a376f
    push ecx                                     # 004a3771
    mov dword ptr [ebp - local_4], ecx           # 004a3772
    mov eax, dword ptr [ebp - local_4]           # 004a3775
    mov dword ptr [eax], 0x52dce0                # 004a3778
    mov ecx, dword ptr [ebp - local_4]           # 004a377e
    call FUN_0051d730                            # 004a3781
    {load} mov esp, ebp                          # 004a3786
    pop ebp                                      # 004a3788
    ret                                          # 004a3789

