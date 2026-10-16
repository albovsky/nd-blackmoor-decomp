# FUN_005121dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005121dd
# extent:       0x005121dd-0x00512250 (115 code bytes)
# span:         0x005121dd-0x00512250 (code 115, tables 0, padding 0)
# sha256:       a922990d2c8d4a108519186ce7a4b1f14ce0ce980e93a2137e89c35b56a8a64f
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005121dd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8, stk_14, stk_18
# callees:      calls FUN_005176d9, FUN_0050ea7e, KERNEL32.dll!SetFilePointer, KERNEL32.dll!GetLastError, FUN_0050ea0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_005176d9, .text + (0x005176d9 - 0x401000)

.org 0x005121dd - 0x401000
.globl FUN_005121dd
FUN_005121dd:
    # block 0x005121dd: entry, 8 instruction(s), calls FUN_005176d9, ends with jne to 0x005121fc (forward)
    push esi                                     # 005121dd
    mov esi, dword ptr [esp + stk_8]             # 005121de
    push edi                                     # 005121e2
    push esi                                     # 005121e3
    call FUN_005176d9                            # 005121e4
    cmp eax, -0x1                                # 005121e9
    pop ecx                                      # 005121ec
    jne.d8 L_005121fc                            # 005121ed
    # block 0x005121ef: entered by fall-through of jne at 0x005121ed, 3 instruction(s), calls FUN_0050ea7e, ends with forward jump to 0x00512229
    call FUN_0050ea7e                            # 005121ef
    mov dword ptr [eax], 0x9                     # 005121f4
    jmp.d8 L_00512229                            # 005121fa
L_005121fc:
    # block 0x005121fc: entered by jne at 0x005121ed, 8 instruction(s), calls KERNEL32.dll!SetFilePointer, ends with jne to 0x0051221c (forward)
    push dword ptr [esp + stk_14]                # 005121fc
    push 0x0                                     # 00512200
    push dword ptr [esp + stk_18]                # 00512202
    push eax                                     # 00512206
    call dword ptr [0x52a104]                    # 00512207
    {load} mov edi, eax                          # 0051220d
    cmp edi, -0x1                                # 0051220f
    jne.d8 L_0051221c                            # 00512212
    # block 0x00512214: entered by fall-through of jne at 0x00512212, 2 instruction(s), calls KERNEL32.dll!GetLastError, ends with forward jump to 0x0051221e
    call dword ptr [0x52a2a4]                    # 00512214
    jmp.d8 L_0051221e                            # 0051221a
L_0051221c:
    # block 0x0051221c: entered by jne at 0x00512212, 1 instruction(s), falls into the block at 0x0051221e
    {load} xor eax, eax                          # 0051221c
L_0051221e:
    # block 0x0051221e: entered by jmp at 0x0051221a, 2 instruction(s), ends with je to 0x0051222e (forward)
    test eax, eax                                # 0051221e
    je.d8 L_0051222e                             # 00512220
    # block 0x00512222: entered by fall-through of je at 0x00512220, 3 instruction(s), calls FUN_0050ea0b, falls into the block at 0x00512229
    push eax                                     # 00512222
    call FUN_0050ea0b                            # 00512223
    pop ecx                                      # 00512228
L_00512229:
    # block 0x00512229: entered by jmp at 0x005121fa, 2 instruction(s), ends with forward jump to 0x0051224d
    or eax, -0x1                                 # 00512229
    jmp.d8 L_0051224d                            # 0051222c
L_0051222e:
    # block 0x0051222e: entered by je at 0x00512220, 9 instruction(s), falls into the block at 0x0051224d
    {load} mov ecx, esi                          # 0051222e
    and esi, 0x1f                                # 00512230
    sar ecx, 0x5                                 # 00512233
    {load} mov eax, esi                          # 00512236
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00512238
    lea eax, [eax + 8*eax]                       # 0051223f
    and byte ptr [ecx + 4*eax + field_4], -0x3   # 00512242
    lea eax, [ecx + 4*eax + field_4]             # 00512247
    {load} mov eax, edi                          # 0051224b
L_0051224d:
    # block 0x0051224d: entered by jmp at 0x0051222c, 3 instruction(s), ends with ret
    pop edi                                      # 0051224d
    pop esi                                      # 0051224e
    ret                                          # 0051224f

