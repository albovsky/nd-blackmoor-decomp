# FUN_004effd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004effd0
# extent:       0x004effd0-0x004efffe (46 code bytes)
# span:         0x004effd0-0x004f0000 (code 46, tables 0, padding 2)
# sha256:       4aa47d2752f7698fa0700e87ab46f8ddfafd545964d1f612bd67a4a45b9d6e34
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004effd0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee99f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee99f, .text + (0x004ee99f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004effd0 - 0x401000
.globl FUN_004effd0
FUN_004effd0:
    # block 0x004effd0: entry, 10 instruction(s), calls FUN_004ee99f, ends with je to 0x004efff5 (forward)
    push ebp                                     # 004effd0
    {load} mov ebp, esp                          # 004effd1
    push ecx                                     # 004effd3
    mov dword ptr [ebp - local_4], ecx           # 004effd4
    mov ecx, dword ptr [ebp - local_4]           # 004effd7
    call FUN_004ee99f                            # 004effda
    mov eax, dword ptr [ebp + arg_8]             # 004effdf
    and eax, 0x1                                 # 004effe2
    test eax, eax                                # 004effe5
    je.d8 L_004efff5                             # 004effe7
    # block 0x004effe9: entered by fall-through of je at 0x004effe7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004efff5
    mov ecx, dword ptr [ebp - local_4]           # 004effe9
    push ecx                                     # 004effec
    call FUN_0051dc6c                            # 004effed
    add esp, 0x4                                 # 004efff2
L_004efff5:
    # block 0x004efff5: entered by je at 0x004effe7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004efff5
    {load} mov esp, ebp                          # 004efff8
    pop ebp                                      # 004efffa
    ret 0x4                                      # 004efffb

# --- data items (not part of the function) -------------------------
.org 0x004efffe - 0x401000
PAD_004efffe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

