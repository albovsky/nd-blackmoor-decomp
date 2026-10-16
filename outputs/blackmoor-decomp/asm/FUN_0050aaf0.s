# FUN_0050aaf0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050aaf0
# extent:       0x0050aaf0-0x0050ab83 (147 code bytes)
# span:         0x0050aaf0-0x0050ab90 (code 147, tables 0, padding 13)
# sha256:       0d9d241b166e507d0cb0e7ddff444d4bb12ffc0087424e5fdaaafc7415b174e0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050a9c0 (+0x130)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050aaf0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [edx + n] field_minus_4; [esi + n] field_4, field_8, field_14, field_18, field_2c; [esp + n] stk_8, stk_c, stk_14
# callees:      calls FUN_0050e97e, FUN_00506600, FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050ab90
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00506600, .text + (0x00506600 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050aaf0 - 0x401000
.globl FUN_0050aaf0
FUN_0050aaf0:
    # block 0x0050aaf0: entry, 15 instruction(s), calls FUN_0050e97e, ends with je to 0x0050ab2a (forward)
    push esi                                     # 0050aaf0
    push 0x38                                    # 0050aaf1
    push 0x1                                     # 0050aaf3
    call FUN_0050e97e                            # 0050aaf5
    {load} mov esi, eax                          # 0050aafa
    mov eax, dword ptr [esp + stk_14]            # 0050aafc
    add esp, 0x8                                 # 0050ab00
    mov ecx, dword ptr [eax]                     # 0050ab03
    mov dword ptr [esi + field_4], ecx           # 0050ab05
    mov edx, dword ptr [eax + field_8]           # 0050ab08
    mov dword ptr [esi + field_14], eax          # 0050ab0b
    mov eax, dword ptr [esp + stk_8]             # 0050ab0e
    mov dword ptr [esi], edx                     # 0050ab12
    cmp dword ptr [eax], 0x0                     # 0050ab14
    je.d8 L_0050ab2a                             # 0050ab17
    # block 0x0050ab19: entered by fall-through of je at 0x0050ab17, 7 instruction(s), calls FUN_00506600, falls into the block at 0x0050ab2a
    mov ecx, dword ptr [esi + field_4]           # 0050ab19
    lea eax, [esi + field_18]                    # 0050ab1c
    push ecx                                     # 0050ab1f
    push edx                                     # 0050ab20
    push eax                                     # 0050ab21
    call FUN_00506600                            # 0050ab22
    add esp, 0xc                                 # 0050ab27
L_0050ab2a:
    # block 0x0050ab2a: entered by je at 0x0050ab17, 16 instruction(s), calls FUN_0050e97e, FUN_0050ea90, ends with jle to 0x0050ab7f (forward)
    push 0x4                                     # 0050ab2a
    push 0x2                                     # 0050ab2c
    call FUN_0050e97e                            # 0050ab2e
    mov ecx, dword ptr [esi]                     # 0050ab33
    mov dword ptr [esi + field_8], eax           # 0050ab35
    shl ecx, 0x2                                 # 0050ab38
    push ecx                                     # 0050ab3b
    call FUN_0050ea90                            # 0050ab3c
    mov ecx, dword ptr [esi]                     # 0050ab41
    mov dword ptr [esi + field_2c], eax          # 0050ab43
    add esp, 0xc                                 # 0050ab46
    {load} xor eax, eax                          # 0050ab49
    test ecx, ecx                                # 0050ab4b
    mov dword ptr [esp + stk_c], eax             # 0050ab4d
    mov dword ptr [esp + stk_8], ecx             # 0050ab51
    jle.d8 L_0050ab7f                            # 0050ab55
L_0050ab57:
    # block 0x0050ab57: entered by jl at 0x0050ab7d; fall-through of jle at 0x0050ab55, 13 instruction(s), ends with jl to 0x0050ab57 (backward)
    fild dword ptr [esp + stk_8]                 # 0050ab57
    mov edx, dword ptr [esi + field_2c]          # 0050ab5b
    inc eax                                      # 0050ab5e
    fdivr dword ptr [0x52e624]                   # 0050ab5f
    fimul dword ptr [esp + stk_c]                # 0050ab65
    mov dword ptr [esp + stk_c], eax             # 0050ab69
    fcos                                         # 0050ab6d
    .insn 0xdc, 0xc0                             # 0050ab6f
    fstp dword ptr [edx + 4*eax - field_minus_4] # 0050ab71
    mov ecx, dword ptr [esi]                     # 0050ab75
    {load} cmp eax, ecx                          # 0050ab77
    mov dword ptr [esp + stk_8], ecx             # 0050ab79
    jl.d8 L_0050ab57                             # 0050ab7d
L_0050ab7f:
    # block 0x0050ab7f: entered by jle at 0x0050ab55; fall-through of jl at 0x0050ab7d, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 0050ab7f
    pop esi                                      # 0050ab81
    ret                                          # 0050ab82

# --- data items (not part of the function) -------------------------
.org 0x0050ab83 - 0x401000
PAD_0050ab83:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

