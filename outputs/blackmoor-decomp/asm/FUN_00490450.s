# FUN_00490450
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00490450
# extent:       0x00490450-0x0049047e (46 code bytes)
# span:         0x00490450-0x00490480 (code 46, tables 0, padding 2)
# sha256:       9f0d033e901e8817eaadbb05ba405535aa248c3d1bbb53a40c2f7e77a1aec446
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00490450
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0048e26e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0048e26e, .text + (0x0048e26e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00490450 - 0x401000
.globl FUN_00490450
FUN_00490450:
    # block 0x00490450: entry, 10 instruction(s), calls FUN_0048e26e, ends with je to 0x00490475 (forward)
    push ebp                                     # 00490450
    {load} mov ebp, esp                          # 00490451
    push ecx                                     # 00490453
    mov dword ptr [ebp - local_4], ecx           # 00490454
    mov ecx, dword ptr [ebp - local_4]           # 00490457
    call FUN_0048e26e                            # 0049045a
    mov eax, dword ptr [ebp + arg_8]             # 0049045f
    and eax, 0x1                                 # 00490462
    test eax, eax                                # 00490465
    je.d8 L_00490475                             # 00490467
    # block 0x00490469: entered by fall-through of je at 0x00490467, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00490475
    mov ecx, dword ptr [ebp - local_4]           # 00490469
    push ecx                                     # 0049046c
    call FUN_0051dc6c                            # 0049046d
    add esp, 0x4                                 # 00490472
L_00490475:
    # block 0x00490475: entered by je at 0x00490467, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00490475
    {load} mov esp, ebp                          # 00490478
    pop ebp                                      # 0049047a
    ret 0x4                                      # 0049047b

# --- data items (not part of the function) -------------------------
.org 0x0049047e - 0x401000
PAD_0049047e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

