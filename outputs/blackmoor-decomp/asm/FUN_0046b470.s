# FUN_0046b470
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b470
# extent:       0x0046b470-0x0046b49e (46 code bytes)
# span:         0x0046b470-0x0046b4a0 (code 46, tables 0, padding 2)
# sha256:       f890c8cc9faf0383c86b7ce8efc69e039bfcfe0074941cbf67d6bbdc7e05e75f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b470
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00468e3e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00468e3e, .text + (0x00468e3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0046b470 - 0x401000
.globl FUN_0046b470
FUN_0046b470:
    # block 0x0046b470: entry, 10 instruction(s), calls FUN_00468e3e, ends with je to 0x0046b495 (forward)
    push ebp                                     # 0046b470
    {load} mov ebp, esp                          # 0046b471
    push ecx                                     # 0046b473
    mov dword ptr [ebp - local_4], ecx           # 0046b474
    mov ecx, dword ptr [ebp - local_4]           # 0046b477
    call FUN_00468e3e                            # 0046b47a
    mov eax, dword ptr [ebp + arg_8]             # 0046b47f
    and eax, 0x1                                 # 0046b482
    test eax, eax                                # 0046b485
    je.d8 L_0046b495                             # 0046b487
    # block 0x0046b489: entered by fall-through of je at 0x0046b487, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0046b495
    mov ecx, dword ptr [ebp - local_4]           # 0046b489
    push ecx                                     # 0046b48c
    call FUN_0051dc6c                            # 0046b48d
    add esp, 0x4                                 # 0046b492
L_0046b495:
    # block 0x0046b495: entered by je at 0x0046b487, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0046b495
    {load} mov esp, ebp                          # 0046b498
    pop ebp                                      # 0046b49a
    ret 0x4                                      # 0046b49b

# --- data items (not part of the function) -------------------------
.org 0x0046b49e - 0x401000
PAD_0046b49e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

