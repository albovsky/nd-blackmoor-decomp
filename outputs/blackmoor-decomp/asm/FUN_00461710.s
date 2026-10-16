# FUN_00461710
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461710
# extent:       0x00461710-0x0046173e (46 code bytes)
# span:         0x00461710-0x00461740 (code 46, tables 0, padding 2)
# sha256:       8f940e18cccadbb503172512d0c8432e4a19812d2d1965dc7386c1eb69b0a76d
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00461710
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0045dc6e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0045dc6e, .text + (0x0045dc6e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00461710 - 0x401000
.globl FUN_00461710
FUN_00461710:
    # block 0x00461710: entry, 10 instruction(s), calls FUN_0045dc6e, ends with je to 0x00461735 (forward)
    push ebp                                     # 00461710
    {load} mov ebp, esp                          # 00461711
    push ecx                                     # 00461713
    mov dword ptr [ebp - local_4], ecx           # 00461714
    mov ecx, dword ptr [ebp - local_4]           # 00461717
    call FUN_0045dc6e                            # 0046171a
    mov eax, dword ptr [ebp + arg_8]             # 0046171f
    and eax, 0x1                                 # 00461722
    test eax, eax                                # 00461725
    je.d8 L_00461735                             # 00461727
    # block 0x00461729: entered by fall-through of je at 0x00461727, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00461735
    mov ecx, dword ptr [ebp - local_4]           # 00461729
    push ecx                                     # 0046172c
    call FUN_0051dc6c                            # 0046172d
    add esp, 0x4                                 # 00461732
L_00461735:
    # block 0x00461735: entered by je at 0x00461727, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00461735
    {load} mov esp, ebp                          # 00461738
    pop ebp                                      # 0046173a
    ret 0x4                                      # 0046173b

# --- data items (not part of the function) -------------------------
.org 0x0046173e - 0x401000
PAD_0046173e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

