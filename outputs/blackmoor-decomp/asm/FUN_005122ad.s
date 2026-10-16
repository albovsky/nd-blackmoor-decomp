# FUN_005122ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005122ad
# extent:       0x005122ad-0x00512330 (131 code bytes)
# span:         0x005122ad-0x00512330 (code 131, tables 0, padding 0)
# sha256:       bfb7462fc1a01120bb44d7c7283ce382c071623279b6b8b5d4e6685e395b3eca
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005122ad
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esp + n] stk_8
# callees:      calls FUN_005176d9, KERNEL32.dll!CloseHandle, KERNEL32.dll!GetLastError, FUN_0051765a, FUN_0050ea0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_0051765a, .text + (0x0051765a - 0x401000)
.set FUN_005176d9, .text + (0x005176d9 - 0x401000)

.org 0x005122ad - 0x401000
.globl FUN_005122ad
FUN_005122ad:
    # block 0x005122ad: entry, 8 instruction(s), calls FUN_005176d9, ends with je to 0x005122fb (forward)
    push esi                                     # 005122ad
    mov esi, dword ptr [esp + stk_8]             # 005122ae
    push edi                                     # 005122b2
    push esi                                     # 005122b3
    call FUN_005176d9                            # 005122b4
    cmp eax, -0x1                                # 005122b9
    pop ecx                                      # 005122bc
    je.d8 L_005122fb                             # 005122bd
    # block 0x005122bf: entered by fall-through of je at 0x005122bd, 2 instruction(s), ends with je to 0x005122c9 (forward)
    cmp esi, 0x1                                 # 005122bf
    je.d8 L_005122c9                             # 005122c2
    # block 0x005122c4: entered by fall-through of je at 0x005122c2, 2 instruction(s), ends with jne to 0x005122df (forward)
    cmp esi, 0x2                                 # 005122c4
    jne.d8 L_005122df                            # 005122c7
L_005122c9:
    # block 0x005122c9: entered by je at 0x005122c2; fall-through of jne at 0x005122c7, 9 instruction(s), calls FUN_005176d9, ends with je to 0x005122fb (forward)
    push 0x2                                     # 005122c9
    call FUN_005176d9                            # 005122cb
    push 0x1                                     # 005122d0
    {load} mov edi, eax                          # 005122d2
    call FUN_005176d9                            # 005122d4
    pop ecx                                      # 005122d9
    {load} cmp eax, edi                          # 005122da
    pop ecx                                      # 005122dc
    je.d8 L_005122fb                             # 005122dd
L_005122df:
    # block 0x005122df: entered by jne at 0x005122c7; fall-through of je at 0x005122dd, 7 instruction(s), calls FUN_005176d9, KERNEL32.dll!CloseHandle, ends with jne to 0x005122fb (forward)
    push esi                                     # 005122df
    call FUN_005176d9                            # 005122e0
    pop ecx                                      # 005122e5
    push eax                                     # 005122e6
    call dword ptr [0x52a2b8]                    # 005122e7
    test eax, eax                                # 005122ed
    jne.d8 L_005122fb                            # 005122ef
    # block 0x005122f1: entered by fall-through of jne at 0x005122ef, 3 instruction(s), calls KERNEL32.dll!GetLastError, ends with forward jump to 0x005122fd
    call dword ptr [0x52a2a4]                    # 005122f1
    {load} mov edi, eax                          # 005122f7
    jmp.d8 L_005122fd                            # 005122f9
L_005122fb:
    # block 0x005122fb: entered by je at 0x005122bd; je at 0x005122dd; jne at 0x005122ef, 1 instruction(s), falls into the block at 0x005122fd
    {load} xor edi, edi                          # 005122fb
L_005122fd:
    # block 0x005122fd: entered by jmp at 0x005122f9, 11 instruction(s), calls FUN_0051765a, ends with je to 0x0051232b (forward)
    push esi                                     # 005122fd
    call FUN_0051765a                            # 005122fe
    {load} mov eax, esi                          # 00512303
    and esi, 0x1f                                # 00512305
    sar eax, 0x5                                 # 00512308
    pop ecx                                      # 0051230b
    mov eax, dword ptr [4*eax + 0x63cde0]        # 0051230c
    lea ecx, [esi + 8*esi]                       # 00512313
    and byte ptr [eax + 4*ecx + field_4], 0x0    # 00512316
    test edi, edi                                # 0051231b
    je.d8 L_0051232b                             # 0051231d
    # block 0x0051231f: entered by fall-through of je at 0x0051231d, 5 instruction(s), calls FUN_0050ea0b, ends with forward jump to 0x0051232d
    push edi                                     # 0051231f
    call FUN_0050ea0b                            # 00512320
    pop ecx                                      # 00512325
    or eax, -0x1                                 # 00512326
    jmp.d8 L_0051232d                            # 00512329
L_0051232b:
    # block 0x0051232b: entered by je at 0x0051231d, 1 instruction(s), falls into the block at 0x0051232d
    {load} xor eax, eax                          # 0051232b
L_0051232d:
    # block 0x0051232d: entered by jmp at 0x00512329, 3 instruction(s), ends with ret
    pop edi                                      # 0051232d
    pop esi                                      # 0051232e
    ret                                          # 0051232f

