# FUN_004cf0a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf0a9
# extent:       0x004cf0a9-0x004cf0ce (37 code bytes)
# span:         0x004cf0a9-0x004cf0ce (code 37, tables 0, padding 0)
# sha256:       24e8dbe00ba45e3995fd8436054035a3361119567e4c5db158a97143a51c9c84
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf0a9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004cf0a9 - 0x401000
.globl FUN_004cf0a9
FUN_004cf0a9:
    # block 0x004cf0a9: entry, 6 instruction(s), ends with jne to 0x004cf0bd (forward)
    push ebp                                     # 004cf0a9
    {load} mov ebp, esp                          # 004cf0aa
    push ecx                                     # 004cf0ac
    mov dword ptr [ebp - local_4], ecx           # 004cf0ad
    cmp dword ptr [ebp + arg_8], -0x1            # 004cf0b0
    jne.d8 L_004cf0bd                            # 004cf0b4
    # block 0x004cf0b6: entered by fall-through of jne at 0x004cf0b4, 2 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004cf0c8
    call FUN_0050cd50                            # 004cf0b6
    jmp.d8 L_004cf0c8                            # 004cf0bb
L_004cf0bd:
    # block 0x004cf0bd: entered by jne at 0x004cf0b4, 4 instruction(s), calls FUN_0050cd50, falls into the block at 0x004cf0c8
    call FUN_0050cd50                            # 004cf0bd
    cdq                                          # 004cf0c2
    idiv dword ptr [ebp + arg_8]                 # 004cf0c3
    {load} mov eax, edx                          # 004cf0c6
L_004cf0c8:
    # block 0x004cf0c8: entered by jmp at 0x004cf0bb, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004cf0c8
    pop ebp                                      # 004cf0ca
    ret 0x4                                      # 004cf0cb

