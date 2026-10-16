# FUN_0050ce57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ce57
# extent:       0x0050ce57-0x0050cee4 (141 code bytes)
# span:         0x0050ce57-0x0050cee4 (code 141, tables 0, padding 0)
# sha256:       6f41cf127b25ea211b73a9e263a24997fb7c95b04a981b50a0c2038a8d399c71
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ce57
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10, field_18; [esp + n] stk_8, stk_14
# callees:      calls FUN_0050d359, FUN_0050dcb0, FUN_00512178, FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050d359, .text + (0x0050d359 - 0x401000)
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_00512178, .text + (0x00512178 - 0x401000)

.org 0x0050ce57 - 0x401000
.globl FUN_0050ce57
FUN_0050ce57:
    # block 0x0050ce57: entry, 6 instruction(s), ends with je to 0x0050ced3 (forward)
    push esi                                     # 0050ce57
    mov esi, dword ptr [esp + stk_8]             # 0050ce58
    push edi                                     # 0050ce5c
    mov eax, dword ptr [esi + field_c]           # 0050ce5d
    test al, -0x7d                               # 0050ce60
    je.d8 L_0050ced3                             # 0050ce62
    # block 0x0050ce64: entered by fall-through of je at 0x0050ce62, 3 instruction(s), ends with je to 0x0050ce76 (forward)
    mov edi, dword ptr [esp + stk_14]            # 0050ce64
    test edi, edi                                # 0050ce68
    je.d8 L_0050ce76                             # 0050ce6a
    # block 0x0050ce6c: entered by fall-through of je at 0x0050ce6a, 2 instruction(s), ends with je to 0x0050ce76 (forward)
    cmp edi, 0x1                                 # 0050ce6c
    je.d8 L_0050ce76                             # 0050ce6f
    # block 0x0050ce71: entered by fall-through of je at 0x0050ce6f, 2 instruction(s), ends with jne to 0x0050ced3 (forward)
    cmp edi, 0x2                                 # 0050ce71
    jne.d8 L_0050ced3                            # 0050ce74
L_0050ce76:
    # block 0x0050ce76: entered by je at 0x0050ce6a; je at 0x0050ce6f; fall-through of jne at 0x0050ce74, 4 instruction(s), ends with jne to 0x0050ce8d (forward)
    and al, -0x11                                # 0050ce76
    cmp edi, 0x1                                 # 0050ce78
    mov dword ptr [esi + field_c], eax           # 0050ce7b
    jne.d8 L_0050ce8d                            # 0050ce7e
    # block 0x0050ce80: entered by fall-through of jne at 0x0050ce7e, 5 instruction(s), calls FUN_0050d359, falls into the block at 0x0050ce8d
    push esi                                     # 0050ce80
    call FUN_0050d359                            # 0050ce81
    add dword ptr [esp + stk_14], eax            # 0050ce86
    pop ecx                                      # 0050ce8a
    {load} xor edi, edi                          # 0050ce8b
L_0050ce8d:
    # block 0x0050ce8d: entered by jne at 0x0050ce7e, 6 instruction(s), calls FUN_0050dcb0, ends with je to 0x0050cea2 (forward)
    push esi                                     # 0050ce8d
    call FUN_0050dcb0                            # 0050ce8e
    mov eax, dword ptr [esi + field_c]           # 0050ce93
    pop ecx                                      # 0050ce96
    test al, -0x80                               # 0050ce97
    je.d8 L_0050cea2                             # 0050ce99
    # block 0x0050ce9b: entered by fall-through of je at 0x0050ce99, 3 instruction(s), ends with forward jump to 0x0050ceb6
    and al, -0x4                                 # 0050ce9b
    mov dword ptr [esi + field_c], eax           # 0050ce9d
    jmp.d8 L_0050ceb6                            # 0050cea0
L_0050cea2:
    # block 0x0050cea2: entered by je at 0x0050ce99, 2 instruction(s), ends with je to 0x0050ceb6 (forward)
    test al, 0x1                                 # 0050cea2
    je.d8 L_0050ceb6                             # 0050cea4
    # block 0x0050cea6: entered by fall-through of je at 0x0050cea4, 2 instruction(s), ends with je to 0x0050ceb6 (forward)
    test al, 0x8                                 # 0050cea6
    je.d8 L_0050ceb6                             # 0050cea8
    # block 0x0050ceaa: entered by fall-through of je at 0x0050cea8, 2 instruction(s), ends with jne to 0x0050ceb6 (forward)
    test ah, 0x4                                 # 0050ceaa
    jne.d8 L_0050ceb6                            # 0050cead
    # block 0x0050ceaf: entered by fall-through of jne at 0x0050cead, 1 instruction(s), falls into the block at 0x0050ceb6
    mov dword ptr [esi + field_18], 0x200        # 0050ceaf
L_0050ceb6:
    # block 0x0050ceb6: entered by jmp at 0x0050cea0; je at 0x0050cea4; je at 0x0050cea8; jne at 0x0050cead, 11 instruction(s), calls FUN_00512178, ends with forward jump to 0x0050cee1
    push edi                                     # 0050ceb6
    push dword ptr [esp + stk_14]                # 0050ceb7
    push dword ptr [esi + field_10]              # 0050cebb
    call FUN_00512178                            # 0050cebe
    add esp, 0xc                                 # 0050cec3
    {load} xor ecx, ecx                          # 0050cec6
    cmp eax, -0x1                                # 0050cec8
    setne cl                                     # 0050cecb
    dec ecx                                      # 0050cece
    {load} mov eax, ecx                          # 0050cecf
    jmp.d8 L_0050cee1                            # 0050ced1
L_0050ced3:
    # block 0x0050ced3: entered by je at 0x0050ce62; jne at 0x0050ce74, 3 instruction(s), calls FUN_0050ea7e, falls into the block at 0x0050cee1
    call FUN_0050ea7e                            # 0050ced3
    mov dword ptr [eax], 0x16                    # 0050ced8
    or eax, -0x1                                 # 0050cede
L_0050cee1:
    # block 0x0050cee1: entered by jmp at 0x0050ced1, 3 instruction(s), ends with ret
    pop edi                                      # 0050cee1
    pop esi                                      # 0050cee2
    ret                                          # 0050cee3

