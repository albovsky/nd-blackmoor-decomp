# FUN_00519bbf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519bbf
# extent:       0x00519bbf-0x00519c12 (83 code bytes)
# span:         0x00519bbf-0x00519c12 (code 83, tables 0, padding 0)
# sha256:       8922be84929011e6e32d6f505c4b727a357b867003d63bffb634458bdf8c4acf
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519bbf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_minus_8; [esp + n] stk_14
# callees:      calls FUN_0051e763, FUN_0050fde2, FUN_0050ffdd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050fde2, .text + (0x0050fde2 - 0x401000)
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)
.set FUN_0051e763, .text + (0x0051e763 - 0x401000)

.org 0x00519bbf - 0x401000
.globl FUN_00519bbf
FUN_00519bbf:
    # block 0x00519bbf: entry, 10 instruction(s), calls FUN_0051e763, ends with je to 0x00519c0c (forward)
    push ebx                                     # 00519bbf
    push esi                                     # 00519bc0
    push edi                                     # 00519bc1
    {load} mov ebx, ecx                          # 00519bc2
    call FUN_0051e763                            # 00519bc4
    mov edi, dword ptr [ebx]                     # 00519bc9
    {load} xor esi, esi                          # 00519bcb
    mov al, byte ptr [edi]                       # 00519bcd
    test al, al                                  # 00519bcf
    je.d8 L_00519c0c                             # 00519bd1
L_00519bd3:
    # block 0x00519bd3: entered by jne at 0x00519bfd; fall-through of je at 0x00519bd1, 8 instruction(s), calls FUN_0050fde2, ends with je to 0x00519bee (forward)
    movsx eax, al                                # 00519bd3
    push eax                                     # 00519bd6
    push dword ptr [esp + stk_14]                # 00519bd7
    call FUN_0050fde2                            # 00519bdb
    pop ecx                                      # 00519be0
    test eax, eax                                # 00519be1
    pop ecx                                      # 00519be3
    je.d8 L_00519bee                             # 00519be4
    # block 0x00519be6: entered by fall-through of je at 0x00519be4, 2 instruction(s), ends with jne to 0x00519bf0 (forward)
    test esi, esi                                # 00519be6
    jne.d8 L_00519bf0                            # 00519be8
    # block 0x00519bea: entered by fall-through of jne at 0x00519be8, 2 instruction(s), ends with forward jump to 0x00519bf0
    {load} mov esi, edi                          # 00519bea
    jmp.d8 L_00519bf0                            # 00519bec
L_00519bee:
    # block 0x00519bee: entered by je at 0x00519be4, 1 instruction(s), falls into the block at 0x00519bf0
    {load} xor esi, esi                          # 00519bee
L_00519bf0:
    # block 0x00519bf0: entered by jne at 0x00519be8; jmp at 0x00519bec, 7 instruction(s), calls FUN_0050ffdd, ends with jne to 0x00519bd3 (backward)
    push edi                                     # 00519bf0
    call FUN_0050ffdd                            # 00519bf1
    {load} mov edi, eax                          # 00519bf6
    pop ecx                                      # 00519bf8
    mov al, byte ptr [edi]                       # 00519bf9
    test al, al                                  # 00519bfb
    jne.d8 L_00519bd3                            # 00519bfd
    # block 0x00519bff: entered by fall-through of jne at 0x00519bfd, 2 instruction(s), ends with je to 0x00519c0c (forward)
    test esi, esi                                # 00519bff
    je.d8 L_00519c0c                             # 00519c01
    # block 0x00519c03: entered by fall-through of je at 0x00519c01, 4 instruction(s), falls into the block at 0x00519c0c
    and byte ptr [esi], al                       # 00519c03
    mov ebx, dword ptr [ebx]                     # 00519c05
    {load} sub esi, ebx                          # 00519c07
    mov dword ptr [ebx - field_minus_8], esi     # 00519c09
L_00519c0c:
    # block 0x00519c0c: entered by je at 0x00519bd1; je at 0x00519c01, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 00519c0c
    pop esi                                      # 00519c0d
    pop ebx                                      # 00519c0e
    ret 0x4                                      # 00519c0f

