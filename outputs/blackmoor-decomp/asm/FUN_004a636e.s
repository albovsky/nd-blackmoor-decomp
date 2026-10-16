# FUN_004a636e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a636e
# extent:       0x004a636e-0x004a638a (28 code bytes)
# span:         0x004a636e-0x004a638a (code 28, tables 0, padding 0)
# sha256:       51f7351cad7fca1a868638d5ddc2885946dc8e77003c783ebbf33e62ab61d710
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a636e
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

.org 0x004a636e - 0x401000
.globl FUN_004a636e
FUN_004a636e:
    # block 0x004a636e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004a636e
    {load} mov ebp, esp                          # 004a636f
    push ecx                                     # 004a6371
    mov dword ptr [ebp - local_4], ecx           # 004a6372
    mov eax, dword ptr [ebp - local_4]           # 004a6375
    mov dword ptr [eax], 0x52dd68                # 004a6378
    mov ecx, dword ptr [ebp - local_4]           # 004a637e
    call FUN_0051d730                            # 004a6381
    {load} mov esp, ebp                          # 004a6386
    pop ebp                                      # 004a6388
    ret                                          # 004a6389

