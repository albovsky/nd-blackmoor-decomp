# FUN_00519c12
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519c12
# extent:       0x00519c12-0x00519c54 (66 code bytes)
# span:         0x00519c12-0x00519c54 (code 66, tables 0, padding 0)
# sha256:       3b5d520db31761362ab158e9319dd4fbd6240f0a72379facaebfd841814e22ef
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519c12
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [esp + n] stk_c
# callees:      calls FUN_0051e763, FUN_0050ffdd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)
.set FUN_0051e763, .text + (0x0051e763 - 0x401000)

.org 0x00519c12 - 0x401000
.globl FUN_00519c12
FUN_00519c12:
    # block 0x00519c12: entry, 9 instruction(s), calls FUN_0051e763, ends with je to 0x00519c4f (forward)
    push esi                                     # 00519c12
    push edi                                     # 00519c13
    {load} mov edi, ecx                          # 00519c14
    call FUN_0051e763                            # 00519c16
    mov eax, dword ptr [edi]                     # 00519c1b
    {load} xor esi, esi                          # 00519c1d
    mov cl, byte ptr [eax]                       # 00519c1f
    test cl, cl                                  # 00519c21
    je.d8 L_00519c4f                             # 00519c23
L_00519c25:
    # block 0x00519c25: entered by jne at 0x00519c40; fall-through of je at 0x00519c23, 2 instruction(s), ends with jne to 0x00519c33 (forward)
    cmp cl, byte ptr [esp + stk_c]               # 00519c25
    jne.d8 L_00519c33                            # 00519c29
    # block 0x00519c2b: entered by fall-through of jne at 0x00519c29, 2 instruction(s), ends with jne to 0x00519c35 (forward)
    test esi, esi                                # 00519c2b
    jne.d8 L_00519c35                            # 00519c2d
    # block 0x00519c2f: entered by fall-through of jne at 0x00519c2d, 2 instruction(s), ends with forward jump to 0x00519c35
    {load} mov esi, eax                          # 00519c2f
    jmp.d8 L_00519c35                            # 00519c31
L_00519c33:
    # block 0x00519c33: entered by jne at 0x00519c29, 1 instruction(s), falls into the block at 0x00519c35
    {load} xor esi, esi                          # 00519c33
L_00519c35:
    # block 0x00519c35: entered by jne at 0x00519c2d; jmp at 0x00519c31, 6 instruction(s), calls FUN_0050ffdd, ends with jne to 0x00519c25 (backward)
    push eax                                     # 00519c35
    call FUN_0050ffdd                            # 00519c36
    pop ecx                                      # 00519c3b
    mov cl, byte ptr [eax]                       # 00519c3c
    test cl, cl                                  # 00519c3e
    jne.d8 L_00519c25                            # 00519c40
    # block 0x00519c42: entered by fall-through of jne at 0x00519c40, 2 instruction(s), ends with je to 0x00519c4f (forward)
    test esi, esi                                # 00519c42
    je.d8 L_00519c4f                             # 00519c44
    # block 0x00519c46: entered by fall-through of je at 0x00519c44, 4 instruction(s), falls into the block at 0x00519c4f
    and byte ptr [esi], cl                       # 00519c46
    mov eax, dword ptr [edi]                     # 00519c48
    {load} sub esi, eax                          # 00519c4a
    mov dword ptr [eax - field_minus_8], esi     # 00519c4c
L_00519c4f:
    # block 0x00519c4f: entered by je at 0x00519c23; je at 0x00519c44, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00519c4f
    pop esi                                      # 00519c50
    ret 0x4                                      # 00519c51

