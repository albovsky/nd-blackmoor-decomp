# FUN_0051c74f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c74f
# extent:       0x0051c74f-0x0051c7cc (125 code bytes)
# span:         0x0051c74f-0x0051c7cc (code 125, tables 0, padding 0)
# sha256:       d88ef9a7931842f8cb68cedd431aef19244024a968a3c402b42abd314571bed9
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c74f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_14, field_1c; [esi + n] field_1c
# callees:      calls FUN_00525371, FUN_0051f929, FUN_0051ec6f, FUN_00525bd1, FUN_0051d526, FUN_0051c22e, FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_0051f929, .text + (0x0051f929 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x0051c74f - 0x401000
.globl FUN_0051c74f
FUN_0051c74f:
    # block 0x0051c74f: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x0051c76d (forward)
    push esi                                     # 0051c74f
    {load} mov esi, ecx                          # 0051c750
    call FUN_00525371                            # 0051c752
    mov eax, dword ptr [eax + field_4]           # 0051c757
    test eax, eax                                # 0051c75a
    je.d8 L_0051c76d                             # 0051c75c
    # block 0x0051c75e: entered by fall-through of je at 0x0051c75c, 2 instruction(s), ends with jne to 0x0051c76d (forward)
    cmp dword ptr [eax + field_1c], esi          # 0051c75e
    jne.d8 L_0051c76d                            # 0051c761
    # block 0x0051c763: entered by fall-through of jne at 0x0051c761, 2 instruction(s), calls FUN_0051f929, falls into the block at 0x0051c76d
    mov ecx, 0x63c748                            # 0051c763
    call FUN_0051f929                            # 0051c768
L_0051c76d:
    # block 0x0051c76d: entered by je at 0x0051c75c; jne at 0x0051c761, 3 instruction(s), calls FUN_00525371, ends with jne to 0x0051c7a3 (forward)
    call FUN_00525371                            # 0051c76d
    cmp byte ptr [eax + field_14], 0x0           # 0051c772
    jne.d8 L_0051c7a3                            # 0051c776
    # block 0x0051c778: entered by fall-through of jne at 0x0051c776, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0051c7a3 (forward)
    call FUN_0051ec6f                            # 0051c778
    test eax, eax                                # 0051c77d
    je.d8 L_0051c7a3                             # 0051c77f
    # block 0x0051c781: entered by fall-through of je at 0x0051c77f, 3 instruction(s), calls FUN_0051ec6f, ends with jne to 0x0051c7a3 (forward)
    call FUN_0051ec6f                            # 0051c781
    cmp dword ptr [eax + field_1c], esi          # 0051c786
    jne.d8 L_0051c7a3                            # 0051c789
    # block 0x0051c78b: entered by fall-through of jne at 0x0051c789, 6 instruction(s), calls FUN_00525bd1, ends with je to 0x0051c7a3 (forward)
    push 0x5249d1                                # 0051c78b
    mov ecx, 0x63c740                            # 0051c790
    call FUN_00525bd1                            # 0051c795
    mov eax, dword ptr [eax + field_1c]          # 0051c79a
    test eax, eax                                # 0051c79d
    je.d8 L_0051c7a3                             # 0051c79f
    # block 0x0051c7a1: entered by fall-through of je at 0x0051c79f, 1 instruction(s), calls indirect eax, falls into the block at 0x0051c7a3
    call eax                                     # 0051c7a1
L_0051c7a3:
    # block 0x0051c7a3: entered by jne at 0x0051c776; je at 0x0051c77f; jne at 0x0051c789; je at 0x0051c79f, 4 instruction(s), calls FUN_0051d526, ends with jne to 0x0051c7c3 (forward)
    {load} mov ecx, esi                          # 0051c7a3
    call FUN_0051d526                            # 0051c7a5
    test eax, 0x40000000                         # 0051c7aa
    jne.d8 L_0051c7c3                            # 0051c7af
    # block 0x0051c7b1: entered by fall-through of jne at 0x0051c7af, 7 instruction(s), calls FUN_0051c22e, falls into the block at 0x0051c7c3
    push 0x1                                     # 0051c7b1
    push 0x1                                     # 0051c7b3
    push 0x0                                     # 0051c7b5
    push 0x0                                     # 0051c7b7
    push 0x15                                    # 0051c7b9
    push dword ptr [esi + field_1c]              # 0051c7bb
    call FUN_0051c22e                            # 0051c7be
L_0051c7c3:
    # block 0x0051c7c3: entered by jne at 0x0051c7af, 4 instruction(s), calls FUN_0051ab4b, ends with ret
    {load} mov ecx, esi                          # 0051c7c3
    call FUN_0051ab4b                            # 0051c7c5
    pop esi                                      # 0051c7ca
    ret                                          # 0051c7cb

