# FUN_0051ed28
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ed28
# extent:       0x0051ed28-0x0051ed8c (100 code bytes)
# span:         0x0051ed28-0x0051ed8c (code 100, tables 0, padding 0)
# sha256:       81cf755a37c536c3ca94c9488c11b2d38893c827da05c7d555a6d732aa0af366
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ed28
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_58; [esi + n] field_cc; [esp + n] stk_8
# callees:      calls FUN_0051f69d, FUN_0051f6a6, FUN_00525b86, FUN_00525ab6; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_58, 0x58  # offset +0x58
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------
.set FUN_0051f69d, .text + (0x0051f69d - 0x401000)
.set FUN_0051f6a6, .text + (0x0051f6a6 - 0x401000)
.set FUN_00525ab6, .text + (0x00525ab6 - 0x401000)
.set FUN_00525b86, .text + (0x00525b86 - 0x401000)

.org 0x0051ed28 - 0x401000
.globl FUN_0051ed28
FUN_0051ed28:
    # block 0x0051ed28: entry, 6 instruction(s), calls FUN_0051f69d, FUN_0051f6a6, ends with jne to 0x0051ed73 (forward)
    push esi                                     # 0051ed28
    call FUN_0051f69d                            # 0051ed29
    push -0x1                                    # 0051ed2e
    call FUN_0051f6a6                            # 0051ed30
    cmp dword ptr [esp + stk_8], 0x0             # 0051ed35
    jne.d8 L_0051ed73                            # 0051ed3a
    # block 0x0051ed3c: entered by fall-through of jne at 0x0051ed3a, 5 instruction(s), calls FUN_00525b86, ends with je to 0x0051ed73 (forward)
    mov ecx, 0x63c444                            # 0051ed3c
    call FUN_00525b86                            # 0051ed41
    {load} mov esi, eax                          # 0051ed46
    test esi, esi                                # 0051ed48
    je.d8 L_0051ed73                             # 0051ed4a
    # block 0x0051ed4c: entered by fall-through of je at 0x0051ed4a, 3 instruction(s), ends with je to 0x0051ed73 (forward)
    mov ecx, dword ptr [esi + field_cc]          # 0051ed4c
    test ecx, ecx                                # 0051ed52
    je.d8 L_0051ed73                             # 0051ed54
    # block 0x0051ed56: entered by fall-through of je at 0x0051ed54, 5 instruction(s), calls indirect dword ptr [eax + 0x58], ends with je to 0x0051ed6c (forward)
    mov eax, dword ptr [ecx]                     # 0051ed56
    call dword ptr [eax + field_58]              # 0051ed58
    mov ecx, dword ptr [esi + field_cc]          # 0051ed5b
    test ecx, ecx                                # 0051ed61
    je.d8 L_0051ed6c                             # 0051ed63
    # block 0x0051ed65: entered by fall-through of je at 0x0051ed63, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051ed6c
    mov eax, dword ptr [ecx]                     # 0051ed65
    push 0x1                                     # 0051ed67
    call dword ptr [eax + field_4]               # 0051ed69
L_0051ed6c:
    # block 0x0051ed6c: entered by je at 0x0051ed63, 1 instruction(s), falls into the block at 0x0051ed73
    and dword ptr [esi + field_cc], 0x0          # 0051ed6c
L_0051ed73:
    # block 0x0051ed73: entered by jne at 0x0051ed3a; je at 0x0051ed4a; je at 0x0051ed54, 4 instruction(s), ends with je to 0x0051ed89 (forward)
    mov ecx, dword ptr [0x63c704]                # 0051ed73
    pop esi                                      # 0051ed79
    test ecx, ecx                                # 0051ed7a
    je.d8 L_0051ed89                             # 0051ed7c
    # block 0x0051ed7e: entered by fall-through of je at 0x0051ed7c, 3 instruction(s), calls FUN_00525ab6, falls into the block at 0x0051ed89
    push 0x0                                     # 0051ed7e
    push dword ptr [esp + stk_8]                 # 0051ed80
    call FUN_00525ab6                            # 0051ed84
L_0051ed89:
    # block 0x0051ed89: entered by je at 0x0051ed7c, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051ed89

