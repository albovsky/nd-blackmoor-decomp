# FUN_0051a57e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a57e
# extent:       0x0051a57e-0x0051a5b1 (51 code bytes)
# span:         0x0051a57e-0x0051a5b1 (code 51, tables 0, padding 0)
# sha256:       f30613eb31bec89472195f38000f9162053e5e3234bf9864ec6370c85e652f89
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a57e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8; [edx + n] field_4, field_8; [esp + n] stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0051a57e - 0x401000
.globl FUN_0051a57e
FUN_0051a57e:
    # block 0x0051a57e: entry, 5 instruction(s), ends with je to 0x0051a5aa (forward)
    push esi                                     # 0051a57e
    mov esi, dword ptr [ecx + field_4]           # 0051a57f
    test esi, esi                                # 0051a582
    push edi                                     # 0051a584
    je.d8 L_0051a5aa                             # 0051a585
    # block 0x0051a587: entered by fall-through of je at 0x0051a585, 6 instruction(s), falls into the block at 0x0051a598
    mov edi, dword ptr [esp + stk_c]             # 0051a587
    {load} xor edx, edx                          # 0051a58b
    {load} mov eax, edi                          # 0051a58d
    shr eax, 0x4                                 # 0051a58f
    div dword ptr [ecx + field_8]                # 0051a592
    mov edx, dword ptr [esi + 4*edx]             # 0051a595
L_0051a598:
    # block 0x0051a598: entered by jmp at 0x0051a5a3, 2 instruction(s), ends with je to 0x0051a5aa (forward)
    test edx, edx                                # 0051a598
    je.d8 L_0051a5aa                             # 0051a59a
    # block 0x0051a59c: entered by fall-through of je at 0x0051a59a, 2 instruction(s), ends with je to 0x0051a5a5 (forward)
    cmp dword ptr [edx + field_4], edi           # 0051a59c
    je.d8 L_0051a5a5                             # 0051a59f
    # block 0x0051a5a1: entered by fall-through of je at 0x0051a59f, 2 instruction(s), ends with backward jump to 0x0051a598
    mov edx, dword ptr [edx]                     # 0051a5a1
    jmp.d8 L_0051a598                            # 0051a5a3
L_0051a5a5:
    # block 0x0051a5a5: entered by je at 0x0051a59f, 2 instruction(s), ends with forward jump to 0x0051a5ac
    mov eax, dword ptr [edx + field_8]           # 0051a5a5
    jmp.d8 L_0051a5ac                            # 0051a5a8
L_0051a5aa:
    # block 0x0051a5aa: entered by je at 0x0051a585; je at 0x0051a59a, 1 instruction(s), falls into the block at 0x0051a5ac
    {load} xor eax, eax                          # 0051a5aa
L_0051a5ac:
    # block 0x0051a5ac: entered by jmp at 0x0051a5a8, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051a5ac
    pop esi                                      # 0051a5ad
    ret 0x4                                      # 0051a5ae

