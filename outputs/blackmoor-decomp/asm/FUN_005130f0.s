# FUN_005130f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005130f0
# extent:       0x005130f0-0x00513174 (132 code bytes)
# span:         0x005130f0-0x00513174 (code 132, tables 0, padding 0)
# sha256:       0d2e7ba2802652e4517aec0af8ad2ea5809f9077c7a301a4adb42c2e6d3c789d
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         _strcmp
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (host_libc_standard_contract, function-ledger-overrides.json not_needed_entries)
# name-note:    unsigned byte compare to first difference or NUL, returns -1/0/1; no side effects
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1, field_2, field_3; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         unreachable_code_entry:0x00513133
# note:         unreachable_code_entry:0x0051313a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x005130f0 - 0x401000
.globl FUN_005130f0
FUN_005130f0:
    # block 0x005130f0: entry, 4 instruction(s), ends with jne to 0x0051313c (forward)
    mov edx, dword ptr [esp + stk_4]             # 005130f0
    mov ecx, dword ptr [esp + stk_8]             # 005130f4
    test edx, 0x3                                # 005130f8
    jne.d8 L_0051313c                            # 005130fe
L_00513100:
    # block 0x00513100: entered by jne at 0x0051312c; je at 0x00513156; jmp at 0x00513172; fall-through of jne at 0x005130fe, 3 instruction(s), ends with jne to 0x00513134 (forward)
    mov eax, dword ptr [edx]                     # 00513100
    cmp al, byte ptr [ecx]                       # 00513102
    jne.d8 L_00513134                            # 00513104
    # block 0x00513106: entered by fall-through of jne at 0x00513104, 2 instruction(s), ends with je to 0x00513130 (forward)
    {load} or al, al                             # 00513106
    je.d8 L_00513130                             # 00513108
    # block 0x0051310a: entered by fall-through of je at 0x00513108, 2 instruction(s), ends with jne to 0x00513134 (forward)
    cmp ah, byte ptr [ecx + field_1]             # 0051310a
    jne.d8 L_00513134                            # 0051310d
    # block 0x0051310f: entered by fall-through of jne at 0x0051310d, 2 instruction(s), ends with je to 0x00513130 (forward)
    {load} or ah, ah                             # 0051310f
    je.d8 L_00513130                             # 00513111
    # block 0x00513113: entered by fall-through of je at 0x00513111, 3 instruction(s), ends with jne to 0x00513134 (forward)
    shr eax, 0x10                                # 00513113
    cmp al, byte ptr [ecx + field_2]             # 00513116
    jne.d8 L_00513134                            # 00513119
    # block 0x0051311b: entered by fall-through of jne at 0x00513119, 2 instruction(s), ends with je to 0x00513130 (forward)
    {load} or al, al                             # 0051311b
    je.d8 L_00513130                             # 0051311d
    # block 0x0051311f: entered by fall-through of je at 0x0051311d, 2 instruction(s), ends with jne to 0x00513134 (forward)
    cmp ah, byte ptr [ecx + field_3]             # 0051311f
    jne.d8 L_00513134                            # 00513122
    # block 0x00513124: entered by fall-through of jne at 0x00513122, 4 instruction(s), ends with jne to 0x00513100 (backward)
    add ecx, 0x4                                 # 00513124
    add edx, 0x4                                 # 00513127
    {load} or ah, ah                             # 0051312a
    jne.d8 L_00513100                            # 0051312c
    # block 0x0051312e: entered by fall-through of jne at 0x0051312c, 1 instruction(s), falls into the block at 0x00513130
    {load} mov edi, edi                          # 0051312e
L_00513130:
    # block 0x00513130: entered by je at 0x00513108; je at 0x00513111; je at 0x0051311d; je at 0x0051314e; more, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00513130
    ret                                          # 00513132
    # block 0x00513133: entered by follows ret at 0x00513132, 1 instruction(s), falls into the block at 0x00513134
    nop                                          # 00513133
L_00513134:
    # block 0x00513134: entered by jne at 0x00513104; jne at 0x0051310d; jne at 0x00513119; jne at 0x00513122; more, 4 instruction(s), ends with ret
    {load} sbb eax, eax                          # 00513134
    shl eax                                      # 00513136
    inc eax                                      # 00513138
    ret                                          # 00513139
    # block 0x0051313a: entered by follows ret at 0x00513139, 1 instruction(s), falls into the block at 0x0051313c
    {load} mov edi, edi                          # 0051313a
L_0051313c:
    # block 0x0051313c: entered by jne at 0x005130fe, 2 instruction(s), ends with je to 0x00513158 (forward)
    test edx, 0x1                                # 0051313c
    je.d8 L_00513158                             # 00513142
    # block 0x00513144: entered by fall-through of je at 0x00513142, 4 instruction(s), ends with jne to 0x00513134 (backward)
    mov al, byte ptr [edx]                       # 00513144
    inc edx                                      # 00513146
    cmp al, byte ptr [ecx]                       # 00513147
    jne.d8 L_00513134                            # 00513149
    # block 0x0051314b: entered by fall-through of jne at 0x00513149, 3 instruction(s), ends with je to 0x00513130 (backward)
    inc ecx                                      # 0051314b
    {load} or al, al                             # 0051314c
    je.d8 L_00513130                             # 0051314e
    # block 0x00513150: entered by fall-through of je at 0x0051314e, 2 instruction(s), ends with je to 0x00513100 (backward)
    test edx, 0x2                                # 00513150
    je.d8 L_00513100                             # 00513156
L_00513158:
    # block 0x00513158: entered by je at 0x00513142; fall-through of je at 0x00513156, 4 instruction(s), ends with jne to 0x00513134 (backward)
    mov ax, word ptr [edx]                       # 00513158
    add edx, 0x2                                 # 0051315b
    cmp al, byte ptr [ecx]                       # 0051315e
    jne.d8 L_00513134                            # 00513160
    # block 0x00513162: entered by fall-through of jne at 0x00513160, 2 instruction(s), ends with je to 0x00513130 (backward)
    {load} or al, al                             # 00513162
    je.d8 L_00513130                             # 00513164
    # block 0x00513166: entered by fall-through of je at 0x00513164, 2 instruction(s), ends with jne to 0x00513134 (backward)
    cmp ah, byte ptr [ecx + field_1]             # 00513166
    jne.d8 L_00513134                            # 00513169
    # block 0x0051316b: entered by fall-through of jne at 0x00513169, 2 instruction(s), ends with je to 0x00513130 (backward)
    {load} or ah, ah                             # 0051316b
    je.d8 L_00513130                             # 0051316d
    # block 0x0051316f: entered by fall-through of je at 0x0051316d, 2 instruction(s), ends with backward jump to 0x00513100
    add ecx, 0x2                                 # 0051316f
    jmp.d8 L_00513100                            # 00513172

