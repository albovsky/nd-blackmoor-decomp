# FUN_004757be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004757be
# extent:       0x004757be-0x004757da (28 code bytes)
# span:         0x004757be-0x004757da (code 28, tables 0, padding 0)
# sha256:       2df72d4194cad90827536483d34e647394221b32d93e16f8d1818827bc141564
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004757be
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

.org 0x004757be - 0x401000
.globl FUN_004757be
FUN_004757be:
    # block 0x004757be: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004757be
    {load} mov ebp, esp                          # 004757bf
    push ecx                                     # 004757c1
    mov dword ptr [ebp - local_4], ecx           # 004757c2
    mov eax, dword ptr [ebp - local_4]           # 004757c5
    mov dword ptr [eax], 0x52d490                # 004757c8
    mov ecx, dword ptr [ebp - local_4]           # 004757ce
    call FUN_0051d730                            # 004757d1
    {load} mov esp, ebp                          # 004757d6
    pop ebp                                      # 004757d8
    ret                                          # 004757d9

