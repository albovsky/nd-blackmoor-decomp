# FUN_0051a44d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a44d
# extent:       0x0051a44d-0x0051a492 (69 code bytes)
# span:         0x0051a44d-0x0051a492 (code 69, tables 0, padding 0)
# sha256:       ecd015187eb82da44916581f2f6db1f8d203d90e8e680e091beb6d4ecd556423
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a44d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_c, stk_10
# callees:      calls FUN_0051dc6c, FUN_0051dc43, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a44d - 0x401000
.globl FUN_0051a44d
FUN_0051a44d:
    # block 0x0051a44d: entry, 6 instruction(s), ends with je to 0x0051a463 (forward)
    push ebx                                     # 0051a44d
    push esi                                     # 0051a44e
    {load} mov esi, ecx                          # 0051a44f
    mov eax, dword ptr [esi + field_4]           # 0051a451
    test eax, eax                                # 0051a454
    je.d8 L_0051a463                             # 0051a456
    # block 0x0051a458: entered by fall-through of je at 0x0051a456, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0051a463
    push eax                                     # 0051a458
    call FUN_0051dc6c                            # 0051a459
    and dword ptr [esi + field_4], 0x0           # 0051a45e
    pop ecx                                      # 0051a462
L_0051a463:
    # block 0x0051a463: entered by je at 0x0051a456, 3 instruction(s), ends with je to 0x0051a48a (forward)
    cmp dword ptr [esp + stk_10], 0x0            # 0051a463
    mov ebx, dword ptr [esp + stk_c]             # 0051a468
    je.d8 L_0051a48a                             # 0051a46c
    # block 0x0051a46e: entered by fall-through of je at 0x0051a46c, 12 instruction(s), calls FUN_0051dc43, FUN_0050f920, falls into the block at 0x0051a48a
    push edi                                     # 0051a46e
    {load} mov edi, ebx                          # 0051a46f
    shl edi, 0x2                                 # 0051a471
    push edi                                     # 0051a474
    call FUN_0051dc43                            # 0051a475
    push edi                                     # 0051a47a
    push 0x0                                     # 0051a47b
    push eax                                     # 0051a47d
    mov dword ptr [esi + field_4], eax           # 0051a47e
    call FUN_0050f920                            # 0051a481
    add esp, 0x10                                # 0051a486
    pop edi                                      # 0051a489
L_0051a48a:
    # block 0x0051a48a: entered by je at 0x0051a46c, 4 instruction(s), ends with ret 0x8
    mov dword ptr [esi + field_8], ebx           # 0051a48a
    pop esi                                      # 0051a48d
    pop ebx                                      # 0051a48e
    ret 0x8                                      # 0051a48f

