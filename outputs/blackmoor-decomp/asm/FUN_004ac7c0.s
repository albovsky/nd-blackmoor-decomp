# FUN_004ac7c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac7c0
# extent:       0x004ac7c0-0x004ac7ee (46 code bytes)
# span:         0x004ac7c0-0x004ac7f0 (code 46, tables 0, padding 2)
# sha256:       8cc452fdb7b762bcb220250fc16c758c00455fbedb1dceb67fd20d2cf23f9b25
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ac7c0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ab38b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ab38b, .text + (0x004ab38b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ac7c0 - 0x401000
.globl FUN_004ac7c0
FUN_004ac7c0:
    # block 0x004ac7c0: entry, 10 instruction(s), calls FUN_004ab38b, ends with je to 0x004ac7e5 (forward)
    push ebp                                     # 004ac7c0
    {load} mov ebp, esp                          # 004ac7c1
    push ecx                                     # 004ac7c3
    mov dword ptr [ebp - local_4], ecx           # 004ac7c4
    mov ecx, dword ptr [ebp - local_4]           # 004ac7c7
    call FUN_004ab38b                            # 004ac7ca
    mov eax, dword ptr [ebp + arg_8]             # 004ac7cf
    and eax, 0x1                                 # 004ac7d2
    test eax, eax                                # 004ac7d5
    je.d8 L_004ac7e5                             # 004ac7d7
    # block 0x004ac7d9: entered by fall-through of je at 0x004ac7d7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004ac7e5
    mov ecx, dword ptr [ebp - local_4]           # 004ac7d9
    push ecx                                     # 004ac7dc
    call FUN_0051dc6c                            # 004ac7dd
    add esp, 0x4                                 # 004ac7e2
L_004ac7e5:
    # block 0x004ac7e5: entered by je at 0x004ac7d7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004ac7e5
    {load} mov esp, ebp                          # 004ac7e8
    pop ebp                                      # 004ac7ea
    ret 0x4                                      # 004ac7eb

# --- data items (not part of the function) -------------------------
.org 0x004ac7ee - 0x401000
PAD_004ac7ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

