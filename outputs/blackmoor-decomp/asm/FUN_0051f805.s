# FUN_0051f805
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f805
# extent:       0x0051f805-0x0051f8b3 (174 code bytes)
# span:         0x0051f805-0x0051f8b3 (code 174, tables 0, padding 0)
# sha256:       6571af35a1c94983f6b142295af427ec08e4d9cd1716fc5a1899c7da505eb1da
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f805
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_8, field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_4; [esi + n] field_4, field_20, field_3c, field_40, field_44
# callees:      calls FUN_0050f978, FUN_0051a57e, FUN_0051dc31, FUN_0051f5cb, FUN_00519cc0, FUN_0051a5b1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_20, 0x20  # offset +0x20
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051a5b1, .text + (0x0051a5b1 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)
.set FUN_0051f5cb, .text + (0x0051f5cb - 0x401000)

.org 0x0051f805 - 0x401000
.globl FUN_0051f805
FUN_0051f805:
    # block 0x0051f805: entry, 12 instruction(s), calls FUN_0050f978, ends with jne to 0x0051f833 (forward)
    mov eax, 0x529098                            # 0051f805
    call FUN_0050f978                            # 0051f80a
    push ecx                                     # 0051f80f
    push ecx                                     # 0051f810
    push ebx                                     # 0051f811
    push esi                                     # 0051f812
    push edi                                     # 0051f813
    mov edi, dword ptr [ebp + field_8]           # 0051f814
    test edi, edi                                # 0051f817
    mov dword ptr [ebp - field_minus_10], esp    # 0051f819
    {load} mov esi, ecx                          # 0051f81c
    jne.d8 L_0051f833                            # 0051f81e
    # block 0x0051f820: entered by fall-through of jne at 0x0051f81e, 1 instruction(s), falls into the block at 0x0051f822
    {load} xor eax, eax                          # 0051f820
L_0051f822:
    # block 0x0051f822: entered by jne at 0x0051f83e; jne at 0x0051f859; jmp at 0x0051f85e; jmp at 0x0051f8ae, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051f822
    pop edi                                      # 0051f825
    pop esi                                      # 0051f826
    mov dword ptr fs:[0x0], ecx                  # 0051f827
    pop ebx                                      # 0051f82e
    leave                                        # 0051f82f
    ret 0x4                                      # 0051f830
L_0051f833:
    # block 0x0051f833: entered by jne at 0x0051f81e, 5 instruction(s), calls FUN_0051a57e, ends with jne to 0x0051f822 (backward)
    push edi                                     # 0051f833
    lea ecx, [esi + field_4]                     # 0051f834
    call FUN_0051a57e                            # 0051f837
    test eax, eax                                # 0051f83c
    jne.d8 L_0051f822                            # 0051f83e
    # block 0x0051f840: entered by fall-through of jne at 0x0051f83e, 5 instruction(s), calls FUN_0051a57e, ends with je to 0x0051f860 (forward)
    lea ecx, [esi + field_20]                    # 0051f840
    push edi                                     # 0051f843
    call FUN_0051a57e                            # 0051f844
    test eax, eax                                # 0051f849
    je.d8 L_0051f860                             # 0051f84b
    # block 0x0051f84d: entered by fall-through of je at 0x0051f84b, 5 instruction(s), ends with jne to 0x0051f822 (backward)
    mov ecx, dword ptr [esi + field_40]          # 0051f84d
    mov dword ptr [ecx + eax], edi               # 0051f850
    {load} add ecx, eax                          # 0051f853
    cmp dword ptr [esi + field_44], 0x2          # 0051f855
    jne.d8 L_0051f822                            # 0051f859
    # block 0x0051f85b: entered by fall-through of jne at 0x0051f859, 2 instruction(s), ends with backward jump to 0x0051f822
    mov dword ptr [ecx + field_4], edi           # 0051f85b
    jmp.d8 L_0051f822                            # 0051f85e
L_0051f860:
    # block 0x0051f860: entered by je at 0x0051f84b, 9 instruction(s), calls FUN_0051dc31, FUN_0051f5cb, ends with jne to 0x0051f884 (forward)
    push 0x521235                                # 0051f860
    call FUN_0051dc31                            # 0051f865
    mov ecx, dword ptr [esi + field_3c]          # 0051f86a
    and dword ptr [ebp - field_minus_4], 0x0     # 0051f86d
    mov dword ptr [ebp + field_8], eax           # 0051f871
    call FUN_0051f5cb                            # 0051f874
    {load} mov ebx, eax                          # 0051f879
    test ebx, ebx                                # 0051f87b
    jne.d8 L_0051f884                            # 0051f87d
    # block 0x0051f87f: entered by fall-through of jne at 0x0051f87d, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x0051f884
    call FUN_00519cc0                            # 0051f87f
L_0051f884:
    # block 0x0051f884: entered by jne at 0x0051f87d, 12 instruction(s), calls FUN_0051a5b1, FUN_0051dc31, ends with jne to 0x0051f8ac (forward)
    push edi                                     # 0051f884
    lea ecx, [esi + field_20]                    # 0051f885
    call FUN_0051a5b1                            # 0051f888
    push dword ptr [ebp + field_8]               # 0051f88d
    or dword ptr [ebp - field_minus_4], -0x1     # 0051f890
    mov dword ptr [eax], ebx                     # 0051f894
    call FUN_0051dc31                            # 0051f896
    mov eax, dword ptr [esi + field_40]          # 0051f89b
    mov dword ptr [eax + ebx], edi               # 0051f89e
    {load} add eax, ebx                          # 0051f8a1
    cmp dword ptr [esi + field_44], 0x2          # 0051f8a3
    jne.d8 L_0051f8ac                            # 0051f8a7
    # block 0x0051f8a9: entered by fall-through of jne at 0x0051f8a7, 1 instruction(s), falls into the block at 0x0051f8ac
    mov dword ptr [eax + field_4], edi           # 0051f8a9
L_0051f8ac:
    # block 0x0051f8ac: entered by jne at 0x0051f8a7, 2 instruction(s), ends with backward jump to 0x0051f822
    {load} mov eax, ebx                          # 0051f8ac
    jmp.d32 L_0051f822                           # 0051f8ae

