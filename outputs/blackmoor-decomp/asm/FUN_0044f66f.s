# FUN_0044f66f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f66f
# extent:       0x0044f66f-0x0044f68b (28 code bytes)
# span:         0x0044f66f-0x0044f68b (code 28, tables 0, padding 0)
# sha256:       b36a29385fb4e3cc9fe657ce63290ef616e466a3e15efc5bd55b75229f497bc9
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044f66f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044f996
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044f996, .text + (0x0044f996 - 0x401000)

.org 0x0044f66f - 0x401000
.globl FUN_0044f66f
FUN_0044f66f:
    # block 0x0044f66f: entry, 11 instruction(s), calls FUN_0044f996, ends with ret
    push ebp                                     # 0044f66f
    {load} mov ebp, esp                          # 0044f670
    push ecx                                     # 0044f672
    mov dword ptr [ebp - local_4], ecx           # 0044f673
    mov eax, dword ptr [ebp - local_4]           # 0044f676
    mov dword ptr [eax], 0x52cd10                # 0044f679
    mov ecx, dword ptr [ebp - local_4]           # 0044f67f
    call FUN_0044f996                            # 0044f682
    {load} mov esp, ebp                          # 0044f687
    pop ebp                                      # 0044f689
    ret                                          # 0044f68a

