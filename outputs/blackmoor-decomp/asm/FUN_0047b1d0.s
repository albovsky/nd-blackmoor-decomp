# FUN_0047b1d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b1d0
# extent:       0x0047b1d0-0x0047b1fe (46 code bytes)
# span:         0x0047b1d0-0x0047b200 (code 46, tables 0, padding 2)
# sha256:       301790d297ff6285d78129a59508551ccf1e6aafef72f2ae209f5199e0eefde9
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b1d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004781de, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004781de, .text + (0x004781de - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047b1d0 - 0x401000
.globl FUN_0047b1d0
FUN_0047b1d0:
    # block 0x0047b1d0: entry, 10 instruction(s), calls FUN_004781de, ends with je to 0x0047b1f5 (forward)
    push ebp                                     # 0047b1d0
    {load} mov ebp, esp                          # 0047b1d1
    push ecx                                     # 0047b1d3
    mov dword ptr [ebp - local_4], ecx           # 0047b1d4
    mov ecx, dword ptr [ebp - local_4]           # 0047b1d7
    call FUN_004781de                            # 0047b1da
    mov eax, dword ptr [ebp + arg_8]             # 0047b1df
    and eax, 0x1                                 # 0047b1e2
    test eax, eax                                # 0047b1e5
    je.d8 L_0047b1f5                             # 0047b1e7
    # block 0x0047b1e9: entered by fall-through of je at 0x0047b1e7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047b1f5
    mov ecx, dword ptr [ebp - local_4]           # 0047b1e9
    push ecx                                     # 0047b1ec
    call FUN_0051dc6c                            # 0047b1ed
    add esp, 0x4                                 # 0047b1f2
L_0047b1f5:
    # block 0x0047b1f5: entered by je at 0x0047b1e7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0047b1f5
    {load} mov esp, ebp                          # 0047b1f8
    pop ebp                                      # 0047b1fa
    ret 0x4                                      # 0047b1fb

# --- data items (not part of the function) -------------------------
.org 0x0047b1fe - 0x401000
PAD_0047b1fe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

