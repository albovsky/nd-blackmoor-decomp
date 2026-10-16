# FUN_0050c920
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c920
# extent:       0x0050c920-0x0050c94f (47 code bytes)
# span:         0x0050c920-0x0050c950 (code 47, tables 0, padding 1)
# sha256:       4be32df90e8e3db3f5eed0d31857bddd88255c7ed09ae57e0e20e4510124a255
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c920
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050c920 - 0x401000
.globl FUN_0050c920
FUN_0050c920:
    # block 0x0050c920: entry, 4 instruction(s), ends with jb to 0x0050c940 (forward)
    push ecx                                     # 0050c920
    cmp eax, 0x1000                              # 0050c921
    lea ecx, [esp + stk_8]                       # 0050c926
    jb.d8 L_0050c940                             # 0050c92a
L_0050c92c:
    # block 0x0050c92c: entered by jae at 0x0050c93e; fall-through of jb at 0x0050c92a, 5 instruction(s), ends with jae to 0x0050c92c (backward)
    sub ecx, 0x1000                              # 0050c92c
    sub eax, 0x1000                              # 0050c932
    test dword ptr [ecx], eax                    # 0050c937
    cmp eax, 0x1000                              # 0050c939
    jae.d8 L_0050c92c                            # 0050c93e
L_0050c940:
    # block 0x0050c940: entered by jb at 0x0050c92a; fall-through of jae at 0x0050c93e, 8 instruction(s), ends with ret
    {load} sub ecx, eax                          # 0050c940
    {load} mov eax, esp                          # 0050c942
    test dword ptr [ecx], eax                    # 0050c944
    {load} mov esp, ecx                          # 0050c946
    mov ecx, dword ptr [eax]                     # 0050c948
    mov eax, dword ptr [eax + field_4]           # 0050c94a
    push eax                                     # 0050c94d
    ret                                          # 0050c94e

# --- data items (not part of the function) -------------------------
.org 0x0050c94f - 0x401000
PAD_0050c94f:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

