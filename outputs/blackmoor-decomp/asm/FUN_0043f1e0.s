# FUN_0043f1e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f1e0
# extent:       0x0043f1e0-0x0043f20e (46 code bytes)
# span:         0x0043f1e0-0x0043f210 (code 46, tables 0, padding 2)
# sha256:       2d1ab42d9ff976d36d4e26fbcbf529ab38c74fe89b71a5dbefd08910e4570cca
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043f1e0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043ef27, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043f1e0 - 0x401000
.globl FUN_0043f1e0
FUN_0043f1e0:
    # block 0x0043f1e0: entry, 10 instruction(s), calls FUN_0043ef27, ends with je to 0x0043f205 (forward)
    push ebp                                     # 0043f1e0
    {load} mov ebp, esp                          # 0043f1e1
    push ecx                                     # 0043f1e3
    mov dword ptr [ebp - local_4], ecx           # 0043f1e4
    mov ecx, dword ptr [ebp - local_4]           # 0043f1e7
    call FUN_0043ef27                            # 0043f1ea
    mov eax, dword ptr [ebp + arg_8]             # 0043f1ef
    and eax, 0x1                                 # 0043f1f2
    test eax, eax                                # 0043f1f5
    je.d8 L_0043f205                             # 0043f1f7
    # block 0x0043f1f9: entered by fall-through of je at 0x0043f1f7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043f205
    mov ecx, dword ptr [ebp - local_4]           # 0043f1f9
    push ecx                                     # 0043f1fc
    call FUN_0051dc6c                            # 0043f1fd
    add esp, 0x4                                 # 0043f202
L_0043f205:
    # block 0x0043f205: entered by je at 0x0043f1f7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0043f205
    {load} mov esp, ebp                          # 0043f208
    pop ebp                                      # 0043f20a
    ret 0x4                                      # 0043f20b

# --- data items (not part of the function) -------------------------
.org 0x0043f20e - 0x401000
PAD_0043f20e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

