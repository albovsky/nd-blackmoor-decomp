# FUN_00512bc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512bc4
# extent:       0x00512bc4-0x00512bef (43 code bytes)
# span:         0x00512bc4-0x00512bef (code 43, tables 0, padding 0)
# sha256:       b67fe6e7812efed1741593bed7ebbacf75b01ba12349fbdd095a0116a7792075
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512bc4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_1; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00512bc4 - 0x401000
.globl FUN_00512bc4
FUN_00512bc4:
    # block 0x00512bc4: entry, 6 instruction(s), ends with je to 0x00512be1 (forward)
    mov edx, dword ptr [esp + stk_8]             # 00512bc4
    mov eax, dword ptr [esp + stk_4]             # 00512bc8
    test edx, edx                                # 00512bcc
    push esi                                     # 00512bce
    lea ecx, [edx - field_minus_1]               # 00512bcf
    je.d8 L_00512be1                             # 00512bd2
L_00512bd4:
    # block 0x00512bd4: entered by jne at 0x00512bdf; fall-through of je at 0x00512bd2, 2 instruction(s), ends with je to 0x00512be1 (forward)
    cmp byte ptr [eax], 0x0                      # 00512bd4
    je.d8 L_00512be1                             # 00512bd7
    # block 0x00512bd9: entered by fall-through of je at 0x00512bd7, 5 instruction(s), ends with jne to 0x00512bd4 (backward)
    inc eax                                      # 00512bd9
    {load} mov esi, ecx                          # 00512bda
    dec ecx                                      # 00512bdc
    test esi, esi                                # 00512bdd
    jne.d8 L_00512bd4                            # 00512bdf
L_00512be1:
    # block 0x00512be1: entered by je at 0x00512bd2; je at 0x00512bd7; fall-through of jne at 0x00512bdf, 3 instruction(s), ends with jne to 0x00512bec (forward)
    cmp byte ptr [eax], 0x0                      # 00512be1
    pop esi                                      # 00512be4
    jne.d8 L_00512bec                            # 00512be5
    # block 0x00512be7: entered by fall-through of jne at 0x00512be5, 2 instruction(s), ends with ret
    sub eax, dword ptr [esp + stk_4]             # 00512be7
    ret                                          # 00512beb
L_00512bec:
    # block 0x00512bec: entered by jne at 0x00512be5, 2 instruction(s), ends with ret
    {load} mov eax, edx                          # 00512bec
    ret                                          # 00512bee

