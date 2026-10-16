# FUN_0045b2d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b2d0
# extent:       0x0045b2d0-0x0045b2fe (46 code bytes)
# span:         0x0045b2d0-0x0045b300 (code 46, tables 0, padding 2)
# sha256:       a4d7a7632157914b1e1f782832056e4ade73a726eefcc821eaedc20a9ec93511
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b2d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00459ace, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00459ace, .text + (0x00459ace - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0045b2d0 - 0x401000
.globl FUN_0045b2d0
FUN_0045b2d0:
    # block 0x0045b2d0: entry, 10 instruction(s), calls FUN_00459ace, ends with je to 0x0045b2f5 (forward)
    push ebp                                     # 0045b2d0
    {load} mov ebp, esp                          # 0045b2d1
    push ecx                                     # 0045b2d3
    mov dword ptr [ebp - local_4], ecx           # 0045b2d4
    mov ecx, dword ptr [ebp - local_4]           # 0045b2d7
    call FUN_00459ace                            # 0045b2da
    mov eax, dword ptr [ebp + arg_8]             # 0045b2df
    and eax, 0x1                                 # 0045b2e2
    test eax, eax                                # 0045b2e5
    je.d8 L_0045b2f5                             # 0045b2e7
    # block 0x0045b2e9: entered by fall-through of je at 0x0045b2e7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0045b2f5
    mov ecx, dword ptr [ebp - local_4]           # 0045b2e9
    push ecx                                     # 0045b2ec
    call FUN_0051dc6c                            # 0045b2ed
    add esp, 0x4                                 # 0045b2f2
L_0045b2f5:
    # block 0x0045b2f5: entered by je at 0x0045b2e7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0045b2f5
    {load} mov esp, ebp                          # 0045b2f8
    pop ebp                                      # 0045b2fa
    ret 0x4                                      # 0045b2fb

# --- data items (not part of the function) -------------------------
.org 0x0045b2fe - 0x401000
PAD_0045b2fe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

