# FUN_004599d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004599d0
# extent:       0x004599d0-0x004599fe (46 code bytes)
# span:         0x004599d0-0x00459a00 (code 46, tables 0, padding 2)
# sha256:       370b2b54e732be0fd105991a20c50dd15c3093f521dbf8941d67c9f1fd5ffd91
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004599d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00457f5e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00457f5e, .text + (0x00457f5e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004599d0 - 0x401000
.globl FUN_004599d0
FUN_004599d0:
    # block 0x004599d0: entry, 10 instruction(s), calls FUN_00457f5e, ends with je to 0x004599f5 (forward)
    push ebp                                     # 004599d0
    {load} mov ebp, esp                          # 004599d1
    push ecx                                     # 004599d3
    mov dword ptr [ebp - local_4], ecx           # 004599d4
    mov ecx, dword ptr [ebp - local_4]           # 004599d7
    call FUN_00457f5e                            # 004599da
    mov eax, dword ptr [ebp + arg_8]             # 004599df
    and eax, 0x1                                 # 004599e2
    test eax, eax                                # 004599e5
    je.d8 L_004599f5                             # 004599e7
    # block 0x004599e9: entered by fall-through of je at 0x004599e7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004599f5
    mov ecx, dword ptr [ebp - local_4]           # 004599e9
    push ecx                                     # 004599ec
    call FUN_0051dc6c                            # 004599ed
    add esp, 0x4                                 # 004599f2
L_004599f5:
    # block 0x004599f5: entered by je at 0x004599e7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004599f5
    {load} mov esp, ebp                          # 004599f8
    pop ebp                                      # 004599fa
    ret 0x4                                      # 004599fb

# --- data items (not part of the function) -------------------------
.org 0x004599fe - 0x401000
PAD_004599fe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

