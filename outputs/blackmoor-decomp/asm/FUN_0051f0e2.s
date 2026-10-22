# FUN_0051f0e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f0e2
# extent:       0x0051f0e2-0x0051f13f (93 code bytes)
# span:         0x0051f0e2-0x0051f13f (code 93, tables 0, padding 0)
# sha256:       9b4c9f367c947ccd2097375d65dc1801483061f41cfa95dfd7cbf31239ceadd1
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f0e2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_90; [esi + n] field_1c; [esp + n] stk_c
# callees:      calls FUN_0051f067, FUN_0050c193, FUN_0051c4aa, FUN_0051abe4, FUN_0051c14c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051c4aa, .text + (0x0051c4aa - 0x401000)
.set FUN_0051f067, .text + (0x0051f067 - 0x401000)

.org 0x0051f0e2 - 0x401000
.globl FUN_0051f0e2
FUN_0051f0e2:
    # block 0x0051f0e2: entry, 5 instruction(s), ends with jne to 0x0051f0f7 (forward)
    push esi                                     # 0051f0e2
    push edi                                     # 0051f0e3
    mov edi, dword ptr [esp + stk_c]             # 0051f0e4
    cmp dword ptr [edi], 0x0                     # 0051f0e8
    jne.d8 L_0051f0f7                            # 0051f0eb
    # block 0x0051f0ed: entered by fall-through of jne at 0x0051f0eb, 4 instruction(s), calls FUN_0051f067, ends with jne to 0x0051f110 (forward)
    push edi                                     # 0051f0ed
    call FUN_0051f067                            # 0051f0ee
    test eax, eax                                # 0051f0f3
    jne.d8 L_0051f110                            # 0051f0f5
L_0051f0f7:
    # block 0x0051f0f7: entered by jne at 0x0051f0eb; fall-through of jne at 0x0051f0f5, 4 instruction(s), calls FUN_0050c193, ends with je to 0x0051f105 (forward)
    call FUN_0050c193                            # 0051f0f7
    {load} mov esi, eax                          # 0051f0fc
    test esi, esi                                # 0051f0fe
    je.d8 L_0051f105                             # 0051f100
    # block 0x0051f102: entered by fall-through of je at 0x0051f100, 1 instruction(s), falls into the block at 0x0051f105
    mov eax, dword ptr [esi + field_1c]          # 0051f102
L_0051f105:
    # block 0x0051f105: entered by je at 0x0051f100, 5 instruction(s), calls FUN_0051c4aa, ends with je to 0x0051f115 (forward)
    push edi                                     # 0051f105
    push eax                                     # 0051f106
    call FUN_0051c4aa                            # 0051f107
    test eax, eax                                # 0051f10c
    je.d8 L_0051f115                             # 0051f10e
L_0051f110:
    # block 0x0051f110: entered by jne at 0x0051f0f5; fall-through of je at 0x0051f10e, 3 instruction(s), ends with forward jump to 0x0051f13a
    push 0x1                                     # 0051f110
    pop eax                                      # 0051f112
    jmp.d8 L_0051f13a                            # 0051f113
L_0051f115:
    # block 0x0051f115: entered by je at 0x0051f10e, 2 instruction(s), ends with je to 0x0051f138 (forward)
    test esi, esi                                # 0051f115
    je.d8 L_0051f138                             # 0051f117
    # block 0x0051f119: entered by fall-through of je at 0x0051f117, 6 instruction(s), calls FUN_0051abe4, FUN_0051c14c, ends with je to 0x0051f138 (forward)
    push dword ptr [edi]                         # 0051f119
    call FUN_0051abe4                            # 0051f11b
    {load} mov ecx, eax                          # 0051f120
    call FUN_0051c14c                            # 0051f122
    {load} cmp eax, esi                          # 0051f127
    je.d8 L_0051f138                             # 0051f129
    # block 0x0051f12b: entered by fall-through of je at 0x0051f129, 5 instruction(s), calls indirect dword ptr [eax + 0x90], ends with forward jump to 0x0051f13a
    mov eax, dword ptr [esi]                     # 0051f12b
    push edi                                     # 0051f12d
    {load} mov ecx, esi                          # 0051f12e
    call dword ptr [eax + field_90]              # 0051f130
    jmp.d8 L_0051f13a                            # 0051f136
L_0051f138:
    # block 0x0051f138: entered by je at 0x0051f117; je at 0x0051f129, 1 instruction(s), falls into the block at 0x0051f13a
    {load} xor eax, eax                          # 0051f138
L_0051f13a:
    # block 0x0051f13a: entered by jmp at 0x0051f113; jmp at 0x0051f136, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051f13a
    pop esi                                      # 0051f13b
    ret 0x4                                      # 0051f13c

