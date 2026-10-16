# FUN_00519e19
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519e19
# extent:       0x00519e19-0x00519e49 (48 code bytes)
# span:         0x00519e19-0x00519e49 (code 48, tables 0, padding 0)
# sha256:       93a8673eef9a8825fc186306f00d6083d99ebf4f6a0affd42df5af5a88c6860a
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519e19
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_d0
# callees:      calls FUN_0051b097, FUN_0051ab4b, FUN_0051b0e3; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_d0, 0xd0  # offset +0xd0

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)

.org 0x00519e19 - 0x401000
.globl FUN_00519e19
FUN_00519e19:
    # block 0x00519e19: entry, 13 instruction(s), calls indirect dword ptr [eax + 0xd0], FUN_0051b097, FUN_0051ab4b, FUN_0051b0e3, ends with je to 0x00519e46 (forward)
    push esi                                     # 00519e19
    {load} mov esi, ecx                          # 00519e1a
    push edi                                     # 00519e1c
    mov eax, dword ptr [esi]                     # 00519e1d
    call dword ptr [eax + field_d0]              # 00519e1f
    {load} mov edi, eax                          # 00519e25
    push edi                                     # 00519e27
    call FUN_0051b097                            # 00519e28
    {load} mov ecx, esi                          # 00519e2d
    call FUN_0051ab4b                            # 00519e2f
    call FUN_0051b0e3                            # 00519e34
    test edi, edi                                # 00519e39
    je.d8 L_00519e46                             # 00519e3b
    # block 0x00519e3d: entered by fall-through of je at 0x00519e3b, 4 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00519e46
    mov eax, dword ptr [edi]                     # 00519e3d
    push 0x1                                     # 00519e3f
    {load} mov ecx, edi                          # 00519e41
    call dword ptr [eax + field_4]               # 00519e43
L_00519e46:
    # block 0x00519e46: entered by je at 0x00519e3b, 3 instruction(s), ends with ret
    pop edi                                      # 00519e46
    pop esi                                      # 00519e47
    ret                                          # 00519e48

