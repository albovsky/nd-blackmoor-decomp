# FUN_00519965
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519965
# extent:       0x00519965-0x005199bd (88 code bytes)
# span:         0x00519965-0x005199bd (code 88, tables 0, padding 0)
# sha256:       c82907d5f07a1e9cc6ae08248f4c8903f36ce1eb429e69c338ee558de6e03cae
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519965
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4; [esp + n] stk_10, stk_14
# callees:      calls FUN_00519453
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00519453, .text + (0x00519453 - 0x401000)

.org 0x00519965 - 0x401000
.globl FUN_00519965
FUN_00519965:
    # block 0x00519965: entry, 6 instruction(s), ends with je to 0x005199a0 (forward)
    push esi                                     # 00519965
    mov esi, dword ptr [0x63ca2c]                # 00519966
    push edi                                     # 0051996c
    mov eax, dword ptr [esi]                     # 0051996d
    test eax, eax                                # 0051996f
    je.d8 L_005199a0                             # 00519971
    # block 0x00519973: entered by fall-through of je at 0x00519971, 1 instruction(s), falls into the block at 0x00519977
    mov edi, dword ptr [esp + stk_10]            # 00519973
L_00519977:
    # block 0x00519977: entered by jne at 0x0051999e, 7 instruction(s), calls FUN_00519453, ends with jne to 0x00519996 (forward)
    push edi                                     # 00519977
    push eax                                     # 00519978
    push dword ptr [esp + stk_14]                # 00519979
    call FUN_00519453                            # 0051997d
    add esp, 0xc                                 # 00519982
    test eax, eax                                # 00519985
    jne.d8 L_00519996                            # 00519987
    # block 0x00519989: entered by fall-through of jne at 0x00519987, 4 instruction(s), ends with je to 0x005199b0 (forward)
    mov eax, dword ptr [esi]                     # 00519989
    mov al, byte ptr [eax + edi]                 # 0051998b
    cmp al, 0x3d                                 # 0051998e
    je.d8 L_005199b0                             # 00519990
    # block 0x00519992: entered by fall-through of je at 0x00519990, 2 instruction(s), ends with je to 0x005199b0 (forward)
    test al, al                                  # 00519992
    je.d8 L_005199b0                             # 00519994
L_00519996:
    # block 0x00519996: entered by jne at 0x00519987; fall-through of je at 0x00519994, 4 instruction(s), ends with jne to 0x00519977 (backward)
    mov eax, dword ptr [esi + field_4]           # 00519996
    add esi, 0x4                                 # 00519999
    test eax, eax                                # 0051999c
    jne.d8 L_00519977                            # 0051999e
L_005199a0:
    # block 0x005199a0: entered by je at 0x00519971; fall-through of jne at 0x0051999e, 4 instruction(s), falls into the block at 0x005199ad
    {load} mov eax, esi                          # 005199a0
    sub eax, dword ptr [0x63ca2c]                # 005199a2
    sar eax, 0x2                                 # 005199a8
    neg eax                                      # 005199ab
L_005199ad:
    # block 0x005199ad: entered by jmp at 0x005199bb, 3 instruction(s), ends with ret
    pop edi                                      # 005199ad
    pop esi                                      # 005199ae
    ret                                          # 005199af
L_005199b0:
    # block 0x005199b0: entered by je at 0x00519990; je at 0x00519994, 4 instruction(s), ends with backward jump to 0x005199ad
    {load} mov eax, esi                          # 005199b0
    sub eax, dword ptr [0x63ca2c]                # 005199b2
    sar eax, 0x2                                 # 005199b8
    jmp.d8 L_005199ad                            # 005199bb

