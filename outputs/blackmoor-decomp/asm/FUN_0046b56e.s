# FUN_0046b56e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b56e
# extent:       0x0046b56e-0x0046b58a (28 code bytes)
# span:         0x0046b56e-0x0046b58a (code 28, tables 0, padding 0)
# sha256:       a37506b8ed5544c98c70351a43426fef95e172ba266d7084554d68680ba1bfd9
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b56e
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

.org 0x0046b56e - 0x401000
.globl FUN_0046b56e
FUN_0046b56e:
    # block 0x0046b56e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0046b56e
    {load} mov ebp, esp                          # 0046b56f
    push ecx                                     # 0046b571
    mov dword ptr [ebp - local_4], ecx           # 0046b572
    mov eax, dword ptr [ebp - local_4]           # 0046b575
    mov dword ptr [eax], 0x52d2e8                # 0046b578
    mov ecx, dword ptr [ebp - local_4]           # 0046b57e
    call FUN_0051d730                            # 0046b581
    {load} mov esp, ebp                          # 0046b586
    pop ebp                                      # 0046b588
    ret                                          # 0046b589

