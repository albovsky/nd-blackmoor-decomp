# FUN_00447ce0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447ce0
# extent:       0x00447ce0-0x00447d0e (46 code bytes)
# span:         0x00447ce0-0x00447d10 (code 46, tables 0, padding 2)
# sha256:       d277bc0a66c717bf0851497605787040e2e49e8c0a6563c0a3e50918379681c9
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447ce0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00446faa, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00446faa, .text + (0x00446faa - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00447ce0 - 0x401000
.globl FUN_00447ce0
FUN_00447ce0:
    # block 0x00447ce0: entry, 10 instruction(s), calls FUN_00446faa, ends with je to 0x00447d05 (forward)
    push ebp                                     # 00447ce0
    {load} mov ebp, esp                          # 00447ce1
    push ecx                                     # 00447ce3
    mov dword ptr [ebp - local_4], ecx           # 00447ce4
    mov ecx, dword ptr [ebp - local_4]           # 00447ce7
    call FUN_00446faa                            # 00447cea
    mov eax, dword ptr [ebp + arg_8]             # 00447cef
    and eax, 0x1                                 # 00447cf2
    test eax, eax                                # 00447cf5
    je.d8 L_00447d05                             # 00447cf7
    # block 0x00447cf9: entered by fall-through of je at 0x00447cf7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00447d05
    mov ecx, dword ptr [ebp - local_4]           # 00447cf9
    push ecx                                     # 00447cfc
    call FUN_0051dc6c                            # 00447cfd
    add esp, 0x4                                 # 00447d02
L_00447d05:
    # block 0x00447d05: entered by je at 0x00447cf7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00447d05
    {load} mov esp, ebp                          # 00447d08
    pop ebp                                      # 00447d0a
    ret 0x4                                      # 00447d0b

# --- data items (not part of the function) -------------------------
.org 0x00447d0e - 0x401000
PAD_00447d0e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

