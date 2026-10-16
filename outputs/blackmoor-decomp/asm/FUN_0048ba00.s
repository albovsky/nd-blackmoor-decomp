# FUN_0048ba00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ba00
# extent:       0x0048ba00-0x0048ba2e (46 code bytes)
# span:         0x0048ba00-0x0048ba30 (code 46, tables 0, padding 2)
# sha256:       02dccc222dfd010474698e1927e7329c563edec6d1d56615896c8d4d2a35084c
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048ba00
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0048a6ee, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0048a6ee, .text + (0x0048a6ee - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0048ba00 - 0x401000
.globl FUN_0048ba00
FUN_0048ba00:
    # block 0x0048ba00: entry, 10 instruction(s), calls FUN_0048a6ee, ends with je to 0x0048ba25 (forward)
    push ebp                                     # 0048ba00
    {load} mov ebp, esp                          # 0048ba01
    push ecx                                     # 0048ba03
    mov dword ptr [ebp - local_4], ecx           # 0048ba04
    mov ecx, dword ptr [ebp - local_4]           # 0048ba07
    call FUN_0048a6ee                            # 0048ba0a
    mov eax, dword ptr [ebp + arg_8]             # 0048ba0f
    and eax, 0x1                                 # 0048ba12
    test eax, eax                                # 0048ba15
    je.d8 L_0048ba25                             # 0048ba17
    # block 0x0048ba19: entered by fall-through of je at 0x0048ba17, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0048ba25
    mov ecx, dword ptr [ebp - local_4]           # 0048ba19
    push ecx                                     # 0048ba1c
    call FUN_0051dc6c                            # 0048ba1d
    add esp, 0x4                                 # 0048ba22
L_0048ba25:
    # block 0x0048ba25: entered by je at 0x0048ba17, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0048ba25
    {load} mov esp, ebp                          # 0048ba28
    pop ebp                                      # 0048ba2a
    ret 0x4                                      # 0048ba2b

# --- data items (not part of the function) -------------------------
.org 0x0048ba2e - 0x401000
PAD_0048ba2e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

