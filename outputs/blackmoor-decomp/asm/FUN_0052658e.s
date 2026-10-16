# FUN_0052658e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052658e
# extent:       0x0052658e-0x005265e4 (86 code bytes)
# span:         0x0052658e-0x005265e4 (code 86, tables 0, padding 0)
# sha256:       3e65727dd0a26a01d6baa3c609dda6541ba64b28e766b91a48c3c8d1e95b96f1
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052658e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_10, stk_14, stk_18
# callees:      calls FUN_0050ffdd, KERNEL32.dll!lstrlenA, KERNEL32.dll!lstrcpynA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)

.org 0x0052658e - 0x401000
.globl FUN_0052658e
FUN_0052658e:
    # block 0x0052658e: entry, 4 instruction(s), falls into the block at 0x00526596
    push esi                                     # 0052658e
    mov esi, dword ptr [esp + stk_8]             # 0052658f
    push edi                                     # 00526593
    {load} mov edi, esi                          # 00526594
L_00526596:
    # block 0x00526596: entered by jmp at 0x005265bb, 2 instruction(s), ends with je to 0x005265bd (forward)
    cmp byte ptr [esi], 0x0                      # 00526596
    je.d8 L_005265bd                             # 00526599
    # block 0x0052659b: entered by fall-through of je at 0x00526599, 3 instruction(s), ends with je to 0x005265a9 (forward)
    mov al, byte ptr [esi]                       # 0052659b
    cmp al, 0x5c                                 # 0052659d
    je.d8 L_005265a9                             # 0052659f
    # block 0x005265a1: entered by fall-through of je at 0x0052659f, 2 instruction(s), ends with je to 0x005265a9 (forward)
    cmp al, 0x2f                                 # 005265a1
    je.d8 L_005265a9                             # 005265a3
    # block 0x005265a5: entered by fall-through of je at 0x005265a3, 2 instruction(s), ends with jne to 0x005265b2 (forward)
    cmp al, 0x3a                                 # 005265a5
    jne.d8 L_005265b2                            # 005265a7
L_005265a9:
    # block 0x005265a9: entered by je at 0x0052659f; je at 0x005265a3; fall-through of jne at 0x005265a7, 4 instruction(s), calls FUN_0050ffdd, falls into the block at 0x005265b2
    push esi                                     # 005265a9
    call FUN_0050ffdd                            # 005265aa
    pop ecx                                      # 005265af
    {load} mov edi, eax                          # 005265b0
L_005265b2:
    # block 0x005265b2: entered by jne at 0x005265a7, 5 instruction(s), calls FUN_0050ffdd, ends with backward jump to 0x00526596
    push esi                                     # 005265b2
    call FUN_0050ffdd                            # 005265b3
    pop ecx                                      # 005265b8
    {load} mov esi, eax                          # 005265b9
    jmp.d8 L_00526596                            # 005265bb
L_005265bd:
    # block 0x005265bd: entered by je at 0x00526599, 2 instruction(s), ends with jne to 0x005265ce (forward)
    cmp dword ptr [esp + stk_10], 0x0            # 005265bd
    jne.d8 L_005265ce                            # 005265c2
    # block 0x005265c4: entered by fall-through of jne at 0x005265c2, 4 instruction(s), calls KERNEL32.dll!lstrlenA, ends with forward jump to 0x005265df
    push edi                                     # 005265c4
    call dword ptr [0x52a1f8]                    # 005265c5
    inc eax                                      # 005265cb
    jmp.d8 L_005265df                            # 005265cc
L_005265ce:
    # block 0x005265ce: entered by jne at 0x005265c2, 5 instruction(s), calls KERNEL32.dll!lstrcpynA, falls into the block at 0x005265df
    push dword ptr [esp + stk_14]                # 005265ce
    push edi                                     # 005265d2
    push dword ptr [esp + stk_18]                # 005265d3
    call dword ptr [0x52a1d4]                    # 005265d7
    {load} xor eax, eax                          # 005265dd
L_005265df:
    # block 0x005265df: entered by jmp at 0x005265cc, 3 instruction(s), ends with ret 0xc
    pop edi                                      # 005265df
    pop esi                                      # 005265e0
    ret 0xc                                      # 005265e1

