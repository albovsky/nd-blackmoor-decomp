# FUN_0046ebbd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ebbd
# extent:       0x0046ebbd-0x0046ebff (66 code bytes)
# span:         0x0046ebbd-0x0046ebff (code 66, tables 0, padding 0)
# sha256:       1356774788395d3a06a8f40a569f2011a7df824a3d7ec05a9e37f985033eb8dd
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046ebbd
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:call_46ebbd (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x0046ebbd - 0x401000
.globl FUN_0046ebbd
FUN_0046ebbd:
    # block 0x0046ebbd: entry, 7 instruction(s), ends with jl to 0x0046ebef (forward)
    push ebp                                     # 0046ebbd
    {load} mov ebp, esp                          # 0046ebbe
    sub esp, 0x8                                 # 0046ebc0
    mov dword ptr [ebp - local_4], ecx           # 0046ebc3
    mov eax, dword ptr [ebp + arg_c]             # 0046ebc6
    cmp eax, dword ptr [ebp + arg_14]            # 0046ebc9
    jl.d8 L_0046ebef                             # 0046ebcc
    # block 0x0046ebce: entered by fall-through of jl at 0x0046ebcc, 3 instruction(s), ends with jg to 0x0046ebef (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0046ebce
    cmp ecx, dword ptr [ebp + arg_1c]            # 0046ebd1
    jg.d8 L_0046ebef                             # 0046ebd4
    # block 0x0046ebd6: entered by fall-through of jg at 0x0046ebd4, 3 instruction(s), ends with jl to 0x0046ebef (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0046ebd6
    cmp edx, dword ptr [ebp + arg_10]            # 0046ebd9
    jl.d8 L_0046ebef                             # 0046ebdc
    # block 0x0046ebde: entered by fall-through of jl at 0x0046ebdc, 3 instruction(s), ends with jg to 0x0046ebef (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0046ebde
    cmp eax, dword ptr [ebp + arg_18]            # 0046ebe1
    jg.d8 L_0046ebef                             # 0046ebe4
    # block 0x0046ebe6: entered by fall-through of jg at 0x0046ebe4, 2 instruction(s), ends with forward jump to 0x0046ebf6
    mov dword ptr [ebp - local_8], 0x1           # 0046ebe6
    jmp.d8 L_0046ebf6                            # 0046ebed
L_0046ebef:
    # block 0x0046ebef: entered by jl at 0x0046ebcc; jg at 0x0046ebd4; jl at 0x0046ebdc; jg at 0x0046ebe4, 1 instruction(s), falls into the block at 0x0046ebf6
    mov dword ptr [ebp - local_8], 0x0           # 0046ebef
L_0046ebf6:
    # block 0x0046ebf6: entered by jmp at 0x0046ebed, 4 instruction(s), ends with ret 0x18
    mov eax, dword ptr [ebp - local_8]           # 0046ebf6
    {load} mov esp, ebp                          # 0046ebf9
    pop ebp                                      # 0046ebfb
    ret 0x18                                     # 0046ebfc

