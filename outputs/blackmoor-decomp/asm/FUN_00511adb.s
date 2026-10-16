# FUN_00511adb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511adb
# extent:       0x00511adb-0x00511b29 (78 code bytes)
# span:         0x00511adb-0x00511b29 (code 78, tables 0, padding 0)
# sha256:       4080e1e7e05c90bbdd1b030e9d5cc3bf242d5383bfd89b2484cbfc4bd57e9dc0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00511a81 (+0x5a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511adb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00511b29
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00511adb - 0x401000
.globl FUN_00511adb
FUN_00511adb:
    # block 0x00511adb: entry, 5 instruction(s), ends with je to 0x00511af7 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00511adb
    mov dl, byte ptr [0x568410]                  # 00511adf
    mov cl, byte ptr [eax]                       # 00511ae5
    test cl, cl                                  # 00511ae7
    je.d8 L_00511af7                             # 00511ae9
L_00511aeb:
    # block 0x00511aeb: entered by jne at 0x00511af5; fall-through of je at 0x00511ae9, 2 instruction(s), ends with je to 0x00511af7 (forward)
    {load} cmp cl, dl                            # 00511aeb
    je.d8 L_00511af7                             # 00511aed
    # block 0x00511aef: entered by fall-through of je at 0x00511aed, 4 instruction(s), ends with jne to 0x00511aeb (backward)
    mov cl, byte ptr [eax + field_1]             # 00511aef
    inc eax                                      # 00511af2
    test cl, cl                                  # 00511af3
    jne.d8 L_00511aeb                            # 00511af5
L_00511af7:
    # block 0x00511af7: entered by je at 0x00511ae9; je at 0x00511aed; fall-through of jne at 0x00511af5, 4 instruction(s), ends with je to 0x00511b28 (forward)
    mov cl, byte ptr [eax]                       # 00511af7
    inc eax                                      # 00511af9
    test cl, cl                                  # 00511afa
    je.d8 L_00511b28                             # 00511afc
L_00511afe:
    # block 0x00511afe: entered by jmp at 0x00511b0f; fall-through of je at 0x00511afc, 3 instruction(s), ends with je to 0x00511b11 (forward)
    mov cl, byte ptr [eax]                       # 00511afe
    test cl, cl                                  # 00511b00
    je.d8 L_00511b11                             # 00511b02
    # block 0x00511b04: entered by fall-through of je at 0x00511b02, 2 instruction(s), ends with je to 0x00511b11 (forward)
    cmp cl, 0x65                                 # 00511b04
    je.d8 L_00511b11                             # 00511b07
    # block 0x00511b09: entered by fall-through of je at 0x00511b07, 2 instruction(s), ends with je to 0x00511b11 (forward)
    cmp cl, 0x45                                 # 00511b09
    je.d8 L_00511b11                             # 00511b0c
    # block 0x00511b0e: entered by fall-through of je at 0x00511b0c, 2 instruction(s), ends with backward jump to 0x00511afe
    inc eax                                      # 00511b0e
    jmp.d8 L_00511afe                            # 00511b0f
L_00511b11:
    # block 0x00511b11: entered by je at 0x00511b02; je at 0x00511b07; je at 0x00511b0c, 1 instruction(s), falls into the block at 0x00511b13
    {load} mov ecx, eax                          # 00511b11
L_00511b13:
    # block 0x00511b13: entered by je at 0x00511b17, 3 instruction(s), ends with je to 0x00511b13 (backward)
    dec eax                                      # 00511b13
    cmp byte ptr [eax], 0x30                     # 00511b14
    je.d8 L_00511b13                             # 00511b17
    # block 0x00511b19: entered by fall-through of je at 0x00511b17, 2 instruction(s), ends with jne to 0x00511b1e (forward)
    cmp byte ptr [eax], dl                       # 00511b19
    jne.d8 L_00511b1e                            # 00511b1b
    # block 0x00511b1d: entered by fall-through of jne at 0x00511b1b, 1 instruction(s), falls into the block at 0x00511b1e
    dec eax                                      # 00511b1d
L_00511b1e:
    # block 0x00511b1e: entered by jne at 0x00511b1b; jne at 0x00511b26, 6 instruction(s), ends with jne to 0x00511b1e (backward)
    mov dl, byte ptr [ecx]                       # 00511b1e
    inc eax                                      # 00511b20
    inc ecx                                      # 00511b21
    test dl, dl                                  # 00511b22
    mov byte ptr [eax], dl                       # 00511b24
    jne.d8 L_00511b1e                            # 00511b26
L_00511b28:
    # block 0x00511b28: entered by je at 0x00511afc; fall-through of jne at 0x00511b26, 1 instruction(s), ends with ret
    ret                                          # 00511b28

