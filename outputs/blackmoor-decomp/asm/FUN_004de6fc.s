# FUN_004de6fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de6fc
# extent:       0x004de6fc-0x004de743 (71 code bytes)
# span:         0x004de6fc-0x004de743 (code 71, tables 0, padding 0)
# sha256:       a64781b8bd1d9b82b862009df1ca9d3a541deccb717af887e66d4a645456ad32
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de6fc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1d34, FUN_004eead0, FUN_004c2dfb, FUN_004de6d7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004de6d7, .text + (0x004de6d7 - 0x401000)
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)
.set FUN_004eead0, .text + (0x004eead0 - 0x401000)

.org 0x004de6fc - 0x401000
.globl FUN_004de6fc
FUN_004de6fc:
    # block 0x004de6fc: entry, 12 instruction(s), calls FUN_004e1d34, FUN_004eead0, ends with je to 0x004de737 (forward)
    push ebp                                     # 004de6fc
    {load} mov ebp, esp                          # 004de6fd
    push ecx                                     # 004de6ff
    mov dword ptr [ebp - local_4], ecx           # 004de700
    mov ecx, dword ptr [ebp - local_4]           # 004de703
    add ecx, 0x3ef                               # 004de706
    call FUN_004e1d34                            # 004de70c
    mov ecx, dword ptr [ebp - local_4]           # 004de711
    add ecx, 0x57e                               # 004de714
    call FUN_004eead0                            # 004de71a
    cmp dword ptr [0x5d03b7], 0x0                # 004de71f
    je.d8 L_004de737                             # 004de726
    # block 0x004de728: entered by fall-through of je at 0x004de726, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004de737
    push 0x5d03b7                                # 004de728
    mov ecx, 0x5cf659                            # 004de72d
    call FUN_004c2dfb                            # 004de732
L_004de737:
    # block 0x004de737: entered by je at 0x004de726, 5 instruction(s), calls FUN_004de6d7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004de737
    call FUN_004de6d7                            # 004de73a
    {load} mov esp, ebp                          # 004de73f
    pop ebp                                      # 004de741
    ret                                          # 004de742

