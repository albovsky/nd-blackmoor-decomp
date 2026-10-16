# FUN_0051e52f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e52f
# extent:       0x0051e52f-0x0051e562 (51 code bytes)
# span:         0x0051e52f-0x0051e562 (code 51, tables 0, padding 0)
# sha256:       1d98ef443eb7006b7c91e4a081f2cdf78828cd53200f6174c517631e2033bd5b
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e52f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_c; [esp + n] stk_8
# callees:      calls KERNEL32.dll!InterlockedIncrement, FUN_0051e8f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e562
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)

.org 0x0051e52f - 0x401000
.globl FUN_0051e52f
FUN_0051e52f:
    # block 0x0051e52f: entry, 6 instruction(s), ends with jl to 0x0051e54c (forward)
    push esi                                     # 0051e52f
    {load} mov esi, ecx                          # 0051e530
    mov ecx, dword ptr [esp + stk_8]             # 0051e532
    mov eax, dword ptr [ecx]                     # 0051e536
    cmp dword ptr [eax - field_minus_c], 0x0     # 0051e538
    jl.d8 L_0051e54c                             # 0051e53c
    # block 0x0051e53e: entered by fall-through of jl at 0x0051e53c, 5 instruction(s), calls KERNEL32.dll!InterlockedIncrement, ends with forward jump to 0x0051e55c
    mov dword ptr [esi], eax                     # 0051e53e
    add eax, -0xc                                # 0051e540
    push eax                                     # 0051e543
    call dword ptr [0x52a200]                    # 0051e544
    jmp.d8 L_0051e55c                            # 0051e54a
L_0051e54c:
    # block 0x0051e54c: entered by jl at 0x0051e53c, 5 instruction(s), calls FUN_0051e8f7, falls into the block at 0x0051e55c
    mov eax, dword ptr [0x5679b0]                # 0051e54c
    mov dword ptr [esi], eax                     # 0051e551
    push dword ptr [ecx]                         # 0051e553
    {load} mov ecx, esi                          # 0051e555
    call FUN_0051e8f7                            # 0051e557
L_0051e55c:
    # block 0x0051e55c: entered by jmp at 0x0051e54a, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051e55c
    pop esi                                      # 0051e55e
    ret 0x4                                      # 0051e55f

