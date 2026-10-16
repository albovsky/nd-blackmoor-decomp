# FUN_00518910
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518910
# extent:       0x00518910-0x00518999 (137 code bytes)
# span:         0x00518910-0x00518999 (code 137, tables 0, padding 0)
# sha256:       0f3ed45b2e6dbdca9208959f57d444620ef920f3d9188c9db8457f20b7ea50ca
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518910
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_18
# callees:      calls KERNEL32.dll!LoadLibraryA; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x00518910 - 0x401000
.globl FUN_00518910
FUN_00518910:
    # block 0x00518910: entry, 6 instruction(s), ends with jne to 0x0051895f (forward)
    push ebx                                     # 00518910
    {load} xor ebx, ebx                          # 00518911
    cmp dword ptr [0x63cd7c], ebx                # 00518913
    push esi                                     # 00518919
    push edi                                     # 0051891a
    jne.d8 L_0051895f                            # 0051891b
    # block 0x0051891d: entered by fall-through of jne at 0x0051891b, 5 instruction(s), calls KERNEL32.dll!LoadLibraryA, ends with je to 0x00518995 (forward)
    push 0x5309a8                                # 0051891d
    call dword ptr [0x52a210]                    # 00518922
    {load} mov edi, eax                          # 00518928
    {load} cmp edi, ebx                          # 0051892a
    je.d8 L_00518995                             # 0051892c
    # block 0x0051892e: entered by fall-through of je at 0x0051892c, 7 instruction(s), calls indirect esi, ends with je to 0x00518995 (forward)
    mov esi, dword ptr [0x52a24c]                # 0051892e
    push 0x53099c                                # 00518934
    push edi                                     # 00518939
    call esi                                     # 0051893a
    test eax, eax                                # 0051893c
    mov dword ptr [0x63cd7c], eax                # 0051893e
    je.d8 L_00518995                             # 00518943
    # block 0x00518945: entered by fall-through of je at 0x00518943, 8 instruction(s), calls indirect esi, falls into the block at 0x0051895f
    push 0x53098c                                # 00518945
    push edi                                     # 0051894a
    call esi                                     # 0051894b
    push 0x530978                                # 0051894d
    push edi                                     # 00518952
    mov dword ptr [0x63cd80], eax                # 00518953
    call esi                                     # 00518958
    mov dword ptr [0x63cd84], eax                # 0051895a
L_0051895f:
    # block 0x0051895f: entered by jne at 0x0051891b, 3 instruction(s), ends with je to 0x0051897e (forward)
    mov eax, dword ptr [0x63cd80]                # 0051895f
    test eax, eax                                # 00518964
    je.d8 L_0051897e                             # 00518966
    # block 0x00518968: entered by fall-through of je at 0x00518966, 4 instruction(s), calls indirect eax, ends with je to 0x0051897e (forward)
    call eax                                     # 00518968
    {load} mov ebx, eax                          # 0051896a
    test ebx, ebx                                # 0051896c
    je.d8 L_0051897e                             # 0051896e
    # block 0x00518970: entered by fall-through of je at 0x0051896e, 3 instruction(s), ends with je to 0x0051897e (forward)
    mov eax, dword ptr [0x63cd84]                # 00518970
    test eax, eax                                # 00518975
    je.d8 L_0051897e                             # 00518977
    # block 0x00518979: entered by fall-through of je at 0x00518977, 3 instruction(s), calls indirect eax, falls into the block at 0x0051897e
    push ebx                                     # 00518979
    call eax                                     # 0051897a
    {load} mov ebx, eax                          # 0051897c
L_0051897e:
    # block 0x0051897e: entered by je at 0x00518966; je at 0x0051896e; je at 0x00518977, 5 instruction(s), calls indirect dword ptr [0x63cd7c], falls into the block at 0x00518991
    push dword ptr [esp + stk_18]                # 0051897e
    push dword ptr [esp + stk_18]                # 00518982
    push dword ptr [esp + stk_18]                # 00518986
    push ebx                                     # 0051898a
    call dword ptr [0x63cd7c]                    # 0051898b
L_00518991:
    # block 0x00518991: entered by jmp at 0x00518997, 4 instruction(s), ends with ret
    pop edi                                      # 00518991
    pop esi                                      # 00518992
    pop ebx                                      # 00518993
    ret                                          # 00518994
L_00518995:
    # block 0x00518995: entered by je at 0x0051892c; je at 0x00518943, 2 instruction(s), ends with backward jump to 0x00518991
    {load} xor eax, eax                          # 00518995
    jmp.d8 L_00518991                            # 00518997

