# FUN_0051ac29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ac29
# extent:       0x0051ac29-0x0051ac62 (57 code bytes)
# span:         0x0051ac29-0x0051ac62 (code 57, tables 0, padding 0)
# sha256:       c3290538523ebac226bd8a566045117d3c54ec266cab4b2d4a5021f759814574
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ac29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4; [esi + n] field_1c; [esp + n] stk_8
# callees:      calls FUN_0051ab72, FUN_0051a5b1, FUN_0051d6ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051a5b1, .text + (0x0051a5b1 - 0x401000)
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)
.set FUN_0051d6ba, .text + (0x0051d6ba - 0x401000)

.org 0x0051ac29 - 0x401000
.globl FUN_0051ac29
FUN_0051ac29:
    # block 0x0051ac29: entry, 6 instruction(s), ends with jne to 0x0051ac39 (forward)
    push ebx                                     # 0051ac29
    mov ebx, dword ptr [esp + stk_8]             # 0051ac2a
    push esi                                     # 0051ac2e
    {load} mov esi, ecx                          # 0051ac2f
    test ebx, ebx                                # 0051ac31
    jne.d8 L_0051ac39                            # 0051ac33
    # block 0x0051ac35: entered by fall-through of jne at 0x0051ac33, 2 instruction(s), ends with forward jump to 0x0051ac5d
    {load} xor eax, eax                          # 0051ac35
    jmp.d8 L_0051ac5d                            # 0051ac37
L_0051ac39:
    # block 0x0051ac39: entered by jne at 0x0051ac33, 15 instruction(s), calls FUN_0051ab72, FUN_0051a5b1, FUN_0051d6ba, falls into the block at 0x0051ac5d
    push edi                                     # 0051ac39
    push 0x1                                     # 0051ac3a
    call FUN_0051ab72                            # 0051ac3c
    {load} mov edi, eax                          # 0051ac41
    push ebx                                     # 0051ac43
    mov dword ptr [esi + field_1c], ebx          # 0051ac44
    lea ecx, [edi + field_4]                     # 0051ac47
    call FUN_0051a5b1                            # 0051ac4a
    push edi                                     # 0051ac4f
    {load} mov ecx, esi                          # 0051ac50
    mov dword ptr [eax], esi                     # 0051ac52
    call FUN_0051d6ba                            # 0051ac54
    push 0x1                                     # 0051ac59
    pop eax                                      # 0051ac5b
    pop edi                                      # 0051ac5c
L_0051ac5d:
    # block 0x0051ac5d: entered by jmp at 0x0051ac37, 3 instruction(s), ends with ret 0x4
    pop esi                                      # 0051ac5d
    pop ebx                                      # 0051ac5e
    ret 0x4                                      # 0051ac5f

