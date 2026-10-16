# FUN_0051c8ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c8ce
# extent:       0x0051c8ce-0x0051c917 (73 code bytes)
# span:         0x0051c8ce-0x0051c917 (code 73, tables 0, padding 0)
# sha256:       f25e5a711c89f227024ab8d164e576083ce826058d243b25d593d214afd8ba7b
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c8ce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [esi + n] field_1c
# callees:      calls FUN_0050c193, FUN_0051f96d, FUN_0051d526, FUN_0051ab16, FUN_0051c22e, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_0051ab16, .text + (0x0051ab16 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051f96d, .text + (0x0051f96d - 0x401000)

.org 0x0051c8ce - 0x401000
.globl FUN_0051c8ce
FUN_0051c8ce:
    # block 0x0051c8ce: entry, 5 instruction(s), calls FUN_0050c193, ends with jne to 0x0051c8e4 (forward)
    push esi                                     # 0051c8ce
    {load} mov esi, ecx                          # 0051c8cf
    call FUN_0050c193                            # 0051c8d1
    {load} cmp eax, esi                          # 0051c8d6
    jne.d8 L_0051c8e4                            # 0051c8d8
    # block 0x0051c8da: entered by fall-through of jne at 0x0051c8d8, 2 instruction(s), calls FUN_0051f96d, falls into the block at 0x0051c8e4
    mov ecx, 0x63c748                            # 0051c8da
    call FUN_0051f96d                            # 0051c8df
L_0051c8e4:
    # block 0x0051c8e4: entered by jne at 0x0051c8d8, 4 instruction(s), calls FUN_0051d526, ends with jne to 0x0051c90c (forward)
    {load} mov ecx, esi                          # 0051c8e4
    call FUN_0051d526                            # 0051c8e6
    test eax, 0x40000000                         # 0051c8eb
    jne.d8 L_0051c90c                            # 0051c8f0
    # block 0x0051c8f2: entered by fall-through of jne at 0x0051c8f0, 8 instruction(s), calls FUN_0051ab16, FUN_0051c22e, falls into the block at 0x0051c90c
    call FUN_0051ab16                            # 0051c8f2
    push 0x1                                     # 0051c8f7
    push 0x1                                     # 0051c8f9
    push dword ptr [eax + field_c]               # 0051c8fb
    push dword ptr [eax + field_8]               # 0051c8fe
    push dword ptr [eax + field_4]               # 0051c901
    push dword ptr [esi + field_1c]              # 0051c904
    call FUN_0051c22e                            # 0051c907
L_0051c90c:
    # block 0x0051c90c: entered by jne at 0x0051c8f0, 4 instruction(s), calls FUN_0051ab4b, ends with ret 0x8
    {load} mov ecx, esi                          # 0051c90c
    call FUN_0051ab4b                            # 0051c90e
    pop esi                                      # 0051c913
    ret 0x8                                      # 0051c914

