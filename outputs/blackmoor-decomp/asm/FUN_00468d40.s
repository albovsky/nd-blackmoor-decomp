# FUN_00468d40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468d40
# extent:       0x00468d40-0x00468d6e (46 code bytes)
# span:         0x00468d40-0x00468d70 (code 46, tables 0, padding 2)
# sha256:       8e6a1280ade3f69af6aea99ee4ff754ac2a9e2a05bc31da1040543aacdb16e91
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00468d40
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004674ff, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004674ff, .text + (0x004674ff - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00468d40 - 0x401000
.globl FUN_00468d40
FUN_00468d40:
    # block 0x00468d40: entry, 10 instruction(s), calls FUN_004674ff, ends with je to 0x00468d65 (forward)
    push ebp                                     # 00468d40
    {load} mov ebp, esp                          # 00468d41
    push ecx                                     # 00468d43
    mov dword ptr [ebp - local_4], ecx           # 00468d44
    mov ecx, dword ptr [ebp - local_4]           # 00468d47
    call FUN_004674ff                            # 00468d4a
    mov eax, dword ptr [ebp + arg_8]             # 00468d4f
    and eax, 0x1                                 # 00468d52
    test eax, eax                                # 00468d55
    je.d8 L_00468d65                             # 00468d57
    # block 0x00468d59: entered by fall-through of je at 0x00468d57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00468d65
    mov ecx, dword ptr [ebp - local_4]           # 00468d59
    push ecx                                     # 00468d5c
    call FUN_0051dc6c                            # 00468d5d
    add esp, 0x4                                 # 00468d62
L_00468d65:
    # block 0x00468d65: entered by je at 0x00468d57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00468d65
    {load} mov esp, ebp                          # 00468d68
    pop ebp                                      # 00468d6a
    ret 0x4                                      # 00468d6b

# --- data items (not part of the function) -------------------------
.org 0x00468d6e - 0x401000
PAD_00468d6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

