# FUN_00524da3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524da3
# extent:       0x00524da3-0x00524e1f (124 code bytes)
# span:         0x00524da3-0x00524e1f (code 124, tables 0, padding 0)
# sha256:       f1fefd9f4bb284697e396ddafe68e409a0966589bdad743c9f57430e2bc8b4a0
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524da3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c, field_minus_10; [edx + n] field_c; [esi + n] field_a8, field_b4
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_00520069, FUN_0052628b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_a8, 0xa8  # offset +0xa8
.equ field_b4, 0xb4  # offset +0xb4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_00520069, .text + (0x00520069 - 0x401000)
.set FUN_0052628b, .text + (0x0052628b - 0x401000)

.org 0x00524da3 - 0x401000
.globl FUN_00524da3
FUN_00524da3:
    # block 0x00524da3: entry, 7 instruction(s), calls FUN_0050f978, ends with je to 0x00524df7 (forward)
    mov eax, 0x528e6e                            # 00524da3
    call FUN_0050f978                            # 00524da8
    push ecx                                     # 00524dad
    cmp dword ptr [ebp + field_8], 0x0           # 00524dae
    push esi                                     # 00524db2
    {load} mov esi, ecx                          # 00524db3
    je.d8 L_00524df7                             # 00524db5
    # block 0x00524db7: entered by fall-through of je at 0x00524db5, 8 instruction(s), calls FUN_0051dc43, ends with je to 0x00524de4 (forward)
    push 0x20                                    # 00524db7
    call FUN_0051dc43                            # 00524db9
    pop ecx                                      # 00524dbe
    {load} mov ecx, eax                          # 00524dbf
    mov dword ptr [ebp - field_minus_10], ecx    # 00524dc1
    and dword ptr [ebp - field_minus_4], 0x0     # 00524dc4
    test ecx, ecx                                # 00524dc8
    je.d8 L_00524de4                             # 00524dca
    # block 0x00524dcc: entered by fall-through of je at 0x00524dca, 7 instruction(s), calls FUN_00520069, ends with forward jump to 0x00524de6
    push 0x1e                                    # 00524dcc
    push dword ptr [ebp + field_8]               # 00524dce
    push 0x52f4ec                                # 00524dd1
    push 0x52f4f4                                # 00524dd6
    push 0x0                                     # 00524ddb
    call FUN_00520069                            # 00524ddd
    jmp.d8 L_00524de6                            # 00524de2
L_00524de4:
    # block 0x00524de4: entered by je at 0x00524dca, 1 instruction(s), falls into the block at 0x00524de6
    {load} xor eax, eax                          # 00524de4
L_00524de6:
    # block 0x00524de6: entered by jmp at 0x00524de2, 5 instruction(s), calls indirect dword ptr [edx + 0xc], falls into the block at 0x00524df7
    or dword ptr [ebp - field_minus_4], -0x1     # 00524de6
    mov dword ptr [esi + field_a8], eax          # 00524dea
    mov edx, dword ptr [eax]                     # 00524df0
    {load} mov ecx, eax                          # 00524df2
    call dword ptr [edx + field_c]               # 00524df4
L_00524df7:
    # block 0x00524df7: entered by je at 0x00524db5, 11 instruction(s), calls FUN_0052628b, ends with ret 0x4
    push 0x0                                     # 00524df7
    push 0x52f4d0                                # 00524df9
    push 0x52f4e0                                # 00524dfe
    {load} mov ecx, esi                          # 00524e03
    call FUN_0052628b                            # 00524e05
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524e0a
    mov dword ptr [esi + field_b4], eax          # 00524e0d
    pop esi                                      # 00524e13
    mov dword ptr fs:[0x0], ecx                  # 00524e14
    leave                                        # 00524e1b
    ret 0x4                                      # 00524e1c

