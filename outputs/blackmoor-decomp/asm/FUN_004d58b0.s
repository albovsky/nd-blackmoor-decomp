# FUN_004d58b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d58b0
# extent:       0x004d58b0-0x004d58cf (31 code bytes)
# span:         0x004d58b0-0x004d58cf (code 31, tables 0, padding 0)
# sha256:       6512be9e042d632fb80dff3714e0154c160043ec478acac6cee91fbda98961db
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d58b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d58eb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d58eb, .text + (0x004d58eb - 0x401000)

.org 0x004d58b0 - 0x401000
.globl FUN_004d58b0
FUN_004d58b0:
    # block 0x004d58b0: entry, 12 instruction(s), calls FUN_004d58eb, ends with ret
    push ebp                                     # 004d58b0
    {load} mov ebp, esp                          # 004d58b1
    push ecx                                     # 004d58b3
    mov dword ptr [ebp - local_4], ecx           # 004d58b4
    mov eax, dword ptr [ebp - local_4]           # 004d58b7
    mov dword ptr [eax], 0x52e454                # 004d58ba
    mov ecx, dword ptr [ebp - local_4]           # 004d58c0
    call FUN_004d58eb                            # 004d58c3
    mov eax, dword ptr [ebp - local_4]           # 004d58c8
    {load} mov esp, ebp                          # 004d58cb
    pop ebp                                      # 004d58cd
    ret                                          # 004d58ce

