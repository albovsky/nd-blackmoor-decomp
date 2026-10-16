# FUN_0051a54c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a54c
# extent:       0x0051a54c-0x0051a57e (50 code bytes)
# span:         0x0051a54c-0x0051a57e (code 50, tables 0, padding 0)
# sha256:       5d8f62b6fe1b627f47299bcdf960814d1badc0a949aa23f46a8c1ad729b1cec3
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a54c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_4, field_8; [esp + n] stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0051a54c - 0x401000
.globl FUN_0051a54c
FUN_0051a54c:
    # block 0x0051a54c: entry, 11 instruction(s), ends with je to 0x0051a578 (forward)
    push esi                                     # 0051a54c
    mov esi, dword ptr [esp + stk_8]             # 0051a54d
    {load} mov eax, esi                          # 0051a551
    {load} xor edx, edx                          # 0051a553
    shr eax, 0x4                                 # 0051a555
    div dword ptr [ecx + field_8]                # 0051a558
    mov eax, dword ptr [esp + stk_c]             # 0051a55b
    mov dword ptr [eax], edx                     # 0051a55f
    mov ecx, dword ptr [ecx + field_4]           # 0051a561
    test ecx, ecx                                # 0051a564
    je.d8 L_0051a578                             # 0051a566
    # block 0x0051a568: entered by fall-through of je at 0x0051a566, 1 instruction(s), falls into the block at 0x0051a56b
    mov eax, dword ptr [ecx + 4*edx]             # 0051a568
L_0051a56b:
    # block 0x0051a56b: entered by jmp at 0x0051a576, 2 instruction(s), ends with je to 0x0051a578 (forward)
    test eax, eax                                # 0051a56b
    je.d8 L_0051a578                             # 0051a56d
    # block 0x0051a56f: entered by fall-through of je at 0x0051a56d, 2 instruction(s), ends with je to 0x0051a57a (forward)
    cmp dword ptr [eax + field_4], esi           # 0051a56f
    je.d8 L_0051a57a                             # 0051a572
    # block 0x0051a574: entered by fall-through of je at 0x0051a572, 2 instruction(s), ends with backward jump to 0x0051a56b
    mov eax, dword ptr [eax]                     # 0051a574
    jmp.d8 L_0051a56b                            # 0051a576
L_0051a578:
    # block 0x0051a578: entered by je at 0x0051a566; je at 0x0051a56d, 1 instruction(s), falls into the block at 0x0051a57a
    {load} xor eax, eax                          # 0051a578
L_0051a57a:
    # block 0x0051a57a: entered by je at 0x0051a572, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051a57a
    ret 0x8                                      # 0051a57b

