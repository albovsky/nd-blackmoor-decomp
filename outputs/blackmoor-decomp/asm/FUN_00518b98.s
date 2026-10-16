# FUN_00518b98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518b98
# extent:       0x00518b98-0x00518bd5 (61 code bytes)
# span:         0x00518b98-0x00518bd5 (code 61, tables 0, padding 0)
# sha256:       9256cc0d2a197d1b33483ec25795c94bbaddf3beb1624605b778c674e36e031e
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518b98
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [edx + n] field_4; [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00518b98 - 0x401000
.globl FUN_00518b98
FUN_00518b98:
    # block 0x00518b98: entry, 8 instruction(s), ends with je to 0x00518bc1 (forward)
    mov edx, dword ptr [esp + stk_8]             # 00518b98
    mov ecx, dword ptr [0x568adc]                # 00518b9c
    push esi                                     # 00518ba2
    mov esi, dword ptr [esp + stk_8]             # 00518ba3
    cmp dword ptr [edx + field_4], esi           # 00518ba7
    push edi                                     # 00518baa
    {load} mov eax, edx                          # 00518bab
    je.d8 L_00518bc1                             # 00518bad
    # block 0x00518baf: entered by fall-through of je at 0x00518bad, 2 instruction(s), falls into the block at 0x00518bb5
    lea edi, [ecx + 2*ecx]                       # 00518baf
    lea edi, [edx + 4*edi]                       # 00518bb2
L_00518bb5:
    # block 0x00518bb5: entered by jne at 0x00518bbf, 3 instruction(s), ends with jae to 0x00518bc1 (forward)
    add eax, 0xc                                 # 00518bb5
    {load} cmp eax, edi                          # 00518bb8
    jae.d8 L_00518bc1                            # 00518bba
    # block 0x00518bbc: entered by fall-through of jae at 0x00518bba, 2 instruction(s), ends with jne to 0x00518bb5 (backward)
    cmp dword ptr [eax + field_4], esi           # 00518bbc
    jne.d8 L_00518bb5                            # 00518bbf
L_00518bc1:
    # block 0x00518bc1: entered by je at 0x00518bad; jae at 0x00518bba; fall-through of jne at 0x00518bbf, 4 instruction(s), ends with jae to 0x00518bd0 (forward)
    lea ecx, [ecx + 2*ecx]                       # 00518bc1
    lea ecx, [edx + 4*ecx]                       # 00518bc4
    {load} cmp eax, ecx                          # 00518bc7
    jae.d8 L_00518bd0                            # 00518bc9
    # block 0x00518bcb: entered by fall-through of jae at 0x00518bc9, 2 instruction(s), ends with je to 0x00518bd2 (forward)
    cmp dword ptr [eax + field_4], esi           # 00518bcb
    je.d8 L_00518bd2                             # 00518bce
L_00518bd0:
    # block 0x00518bd0: entered by jae at 0x00518bc9; fall-through of je at 0x00518bce, 1 instruction(s), falls into the block at 0x00518bd2
    {load} xor eax, eax                          # 00518bd0
L_00518bd2:
    # block 0x00518bd2: entered by je at 0x00518bce, 3 instruction(s), ends with ret
    pop edi                                      # 00518bd2
    pop esi                                      # 00518bd3
    ret                                          # 00518bd4

