# FUN_00518999
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518999
# extent:       0x00518999-0x00518a16 (125 code bytes)
# span:         0x00518999-0x00518a16 (code 125, tables 0, padding 0)
# sha256:       56e7ba47b3543a9a6c8e289c63367bfbd103ba308733f5c0e1062c1f30e507cd
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518999
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [esp + n] stk_10
# callees:      calls FUN_00519492, FUN_00511f30, FUN_00519453
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_00519453, .text + (0x00519453 - 0x401000)
.set FUN_00519492, .text + (0x00519492 - 0x401000)

.org 0x00518999 - 0x401000
.globl FUN_00518999
FUN_00518999:
    # block 0x00518999: entry, 6 instruction(s), ends with je to 0x00518a10 (forward)
    cmp dword ptr [0x63e12c], 0x0                # 00518999
    push ebx                                     # 005189a0
    push esi                                     # 005189a1
    mov esi, dword ptr [0x63ca2c]                # 005189a2
    push edi                                     # 005189a8
    je.d8 L_00518a10                             # 005189a9
    # block 0x005189ab: entered by fall-through of je at 0x005189a9, 2 instruction(s), ends with jne to 0x005189ca (forward)
    test esi, esi                                # 005189ab
    jne.d8 L_005189ca                            # 005189ad
    # block 0x005189af: entered by fall-through of jne at 0x005189ad, 2 instruction(s), ends with je to 0x00518a10 (forward)
    cmp dword ptr [0x63ca34], esi                # 005189af
    je.d8 L_00518a10                             # 005189b5
    # block 0x005189b7: entered by fall-through of je at 0x005189b5, 3 instruction(s), calls FUN_00519492, ends with jne to 0x00518a10 (forward)
    call FUN_00519492                            # 005189b7
    test eax, eax                                # 005189bc
    jne.d8 L_00518a10                            # 005189be
    # block 0x005189c0: entered by fall-through of jne at 0x005189be, 3 instruction(s), ends with je to 0x00518a10 (forward)
    mov esi, dword ptr [0x63ca2c]                # 005189c0
    test esi, esi                                # 005189c6
    je.d8 L_00518a10                             # 005189c8
L_005189ca:
    # block 0x005189ca: entered by jne at 0x005189ad; fall-through of je at 0x005189c8, 3 instruction(s), ends with je to 0x00518a10 (forward)
    mov ebx, dword ptr [esp + stk_10]            # 005189ca
    test ebx, ebx                                # 005189ce
    je.d8 L_00518a10                             # 005189d0
    # block 0x005189d2: entered by fall-through of je at 0x005189d0, 4 instruction(s), calls FUN_00511f30, falls into the block at 0x005189db
    push ebx                                     # 005189d2
    call FUN_00511f30                            # 005189d3
    pop ecx                                      # 005189d8
    {load} mov edi, eax                          # 005189d9
L_005189db:
    # block 0x005189db: entered by jmp at 0x00518a06, 3 instruction(s), ends with je to 0x00518a10 (forward)
    mov eax, dword ptr [esi]                     # 005189db
    test eax, eax                                # 005189dd
    je.d8 L_00518a10                             # 005189df
    # block 0x005189e1: entered by fall-through of je at 0x005189df, 5 instruction(s), calls FUN_00511f30, ends with jbe to 0x00518a03 (forward)
    push eax                                     # 005189e1
    call FUN_00511f30                            # 005189e2
    {load} cmp eax, edi                          # 005189e7
    pop ecx                                      # 005189e9
    jbe.d8 L_00518a03                            # 005189ea
    # block 0x005189ec: entered by fall-through of jbe at 0x005189ea, 3 instruction(s), ends with jne to 0x00518a03 (forward)
    mov eax, dword ptr [esi]                     # 005189ec
    cmp byte ptr [eax + edi], 0x3d               # 005189ee
    jne.d8 L_00518a03                            # 005189f2
    # block 0x005189f4: entered by fall-through of jne at 0x005189f2, 7 instruction(s), calls FUN_00519453, ends with je to 0x00518a08 (forward)
    push edi                                     # 005189f4
    push ebx                                     # 005189f5
    push eax                                     # 005189f6
    call FUN_00519453                            # 005189f7
    add esp, 0xc                                 # 005189fc
    test eax, eax                                # 005189ff
    je.d8 L_00518a08                             # 00518a01
L_00518a03:
    # block 0x00518a03: entered by jbe at 0x005189ea; jne at 0x005189f2; fall-through of je at 0x00518a01, 2 instruction(s), ends with backward jump to 0x005189db
    add esi, 0x4                                 # 00518a03
    jmp.d8 L_005189db                            # 00518a06
L_00518a08:
    # block 0x00518a08: entered by je at 0x00518a01, 3 instruction(s), ends with forward jump to 0x00518a12
    mov eax, dword ptr [esi]                     # 00518a08
    lea eax, [eax + edi + field_1]               # 00518a0a
    jmp.d8 L_00518a12                            # 00518a0e
L_00518a10:
    # block 0x00518a10: entered by je at 0x005189a9; je at 0x005189b5; jne at 0x005189be; je at 0x005189c8; more, 1 instruction(s), falls into the block at 0x00518a12
    {load} xor eax, eax                          # 00518a10
L_00518a12:
    # block 0x00518a12: entered by jmp at 0x00518a0e, 4 instruction(s), ends with ret
    pop edi                                      # 00518a12
    pop esi                                      # 00518a13
    pop ebx                                      # 00518a14
    ret                                          # 00518a15

