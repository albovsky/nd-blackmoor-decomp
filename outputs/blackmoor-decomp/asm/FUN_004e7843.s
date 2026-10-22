# FUN_004e7843
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7843
# extent:       0x004e7843-0x004e78c2 (127 code bytes)
# span:         0x004e7843-0x004e78c2 (code 127, tables 0, padding 0)
# sha256:       b69f89f27ee6b61ffcf72f3912924815737308da6da24ef694c0f30d9165310a
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7843_copy_block
# naming:       native port src/original_methods_fl39c.c:m4e7843_copy_block (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Copies 0x300 bytes from src to [self+0x691]; when 0x300 > limit (signed) runs the diagnostic calls 0x50ca3e, 0x4264e8, 0x4c97b4. Limits below, at and above the size, negative and 0x7fffffff; All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4e7843_copy_block (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e7843 - 0x401000
.globl FUN_004e7843
FUN_004e7843:
    # block 0x004e7843: entry, 21 instruction(s), ends with jle to 0x004e78ba (forward)
    push ebp                                     # 004e7843
    {load} mov ebp, esp                          # 004e7844
    sub esp, 0x8                                 # 004e7846
    push esi                                     # 004e7849
    push edi                                     # 004e784a
    mov dword ptr [ebp - local_8], ecx           # 004e784b
    mov dword ptr [ebp - local_4], 0x0           # 004e784e
    mov edi, dword ptr [ebp - local_8]           # 004e7855
    add edi, 0x691                               # 004e7858
    mov ecx, 0xc0                                # 004e785e
    mov esi, dword ptr [ebp + arg_8]             # 004e7863
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e7866
    mov eax, dword ptr [ebp + arg_8]             # 004e7868
    add eax, 0x300                               # 004e786b
    mov dword ptr [ebp + arg_8], eax             # 004e7870
    mov ecx, dword ptr [ebp - local_4]           # 004e7873
    add ecx, 0x300                               # 004e7876
    mov dword ptr [ebp - local_4], ecx           # 004e787c
    mov edx, dword ptr [ebp - local_4]           # 004e787f
    cmp edx, dword ptr [ebp + arg_c]             # 004e7882
    jle.d8 L_004e78ba                            # 004e7885
    # block 0x004e7887: entered by fall-through of jle at 0x004e7885, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004e78ba
    mov eax, dword ptr [ebp + arg_c]             # 004e7887
    push eax                                     # 004e788a
    mov ecx, dword ptr [ebp - local_4]           # 004e788b
    push ecx                                     # 004e788e
    push 0x55c4c4                                # 004e788f
    push 0x63888b                                # 004e7894
    call FUN_0050ca3e                            # 004e7899
    add esp, 0x10                                # 004e789e
    push 0x63888b                                # 004e78a1
    mov ecx, 0x583979                            # 004e78a6
    call FUN_004264e8                            # 004e78ab
    mov ecx, 0x5cf659                            # 004e78b0
    call FUN_004c97b4                            # 004e78b5
L_004e78ba:
    # block 0x004e78ba: entered by jle at 0x004e7885, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004e78ba
    pop esi                                      # 004e78bb
    {load} mov esp, ebp                          # 004e78bc
    pop ebp                                      # 004e78be
    ret 0x8                                      # 004e78bf

