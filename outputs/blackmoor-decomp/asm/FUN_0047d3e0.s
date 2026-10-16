# FUN_0047d3e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d3e0
# extent:       0x0047d3e0-0x0047d40e (46 code bytes)
# span:         0x0047d3e0-0x0047d410 (code 46, tables 0, padding 2)
# sha256:       cc38062baff4b65d667e8ce3bde0df8210ee84798244154f156daa0a88de3a67
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047d3e0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047b21f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0047b21f, .text + (0x0047b21f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047d3e0 - 0x401000
.globl FUN_0047d3e0
FUN_0047d3e0:
    # block 0x0047d3e0: entry, 10 instruction(s), calls FUN_0047b21f, ends with je to 0x0047d405 (forward)
    push ebp                                     # 0047d3e0
    {load} mov ebp, esp                          # 0047d3e1
    push ecx                                     # 0047d3e3
    mov dword ptr [ebp - local_4], ecx           # 0047d3e4
    mov ecx, dword ptr [ebp - local_4]           # 0047d3e7
    call FUN_0047b21f                            # 0047d3ea
    mov eax, dword ptr [ebp + arg_8]             # 0047d3ef
    and eax, 0x1                                 # 0047d3f2
    test eax, eax                                # 0047d3f5
    je.d8 L_0047d405                             # 0047d3f7
    # block 0x0047d3f9: entered by fall-through of je at 0x0047d3f7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047d405
    mov ecx, dword ptr [ebp - local_4]           # 0047d3f9
    push ecx                                     # 0047d3fc
    call FUN_0051dc6c                            # 0047d3fd
    add esp, 0x4                                 # 0047d402
L_0047d405:
    # block 0x0047d405: entered by je at 0x0047d3f7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0047d405
    {load} mov esp, ebp                          # 0047d408
    pop ebp                                      # 0047d40a
    ret 0x4                                      # 0047d40b

# --- data items (not part of the function) -------------------------
.org 0x0047d40e - 0x401000
PAD_0047d40e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

