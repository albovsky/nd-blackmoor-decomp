# FUN_00512ee4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512ee4
# extent:       0x00512ee4-0x00512f53 (111 code bytes)
# span:         0x00512ee4-0x00512f53 (code 111, tables 0, padding 0)
# sha256:       334e99d46f712401cfa8ae1e557b9525b88efbb5e8a92eadb72b6832f9b7c40e
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512ee4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_10
# callees:      calls KERNEL32.dll!InterlockedIncrement, FUN_00512c18, FUN_00512f53, FUN_00512c79; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00512f53, .text + (0x00512f53 - 0x401000)

.org 0x00512ee4 - 0x401000
.globl FUN_00512ee4
FUN_00512ee4:
    # block 0x00512ee4: entry, 4 instruction(s), ends with jne to 0x00512f02 (forward)
    push ebx                                     # 00512ee4
    {load} xor ebx, ebx                          # 00512ee5
    cmp dword ptr [0x63cb1c], ebx                # 00512ee7
    jne.d8 L_00512f02                            # 00512eed
    # block 0x00512eef: entered by fall-through of jne at 0x00512eed, 3 instruction(s), ends with jl to 0x00512f51 (forward)
    mov eax, dword ptr [esp + stk_8]             # 00512eef
    cmp eax, 0x41                                # 00512ef3
    jl.d8 L_00512f51                             # 00512ef6
    # block 0x00512ef8: entered by fall-through of jl at 0x00512ef6, 2 instruction(s), ends with jg to 0x00512f51 (forward)
    cmp eax, 0x5a                                # 00512ef8
    jg.d8 L_00512f51                             # 00512efb
    # block 0x00512efd: entered by fall-through of jg at 0x00512efb, 3 instruction(s), ends with ret
    add eax, 0x20                                # 00512efd
    pop ebx                                      # 00512f00
    ret                                          # 00512f01
L_00512f02:
    # block 0x00512f02: entered by jne at 0x00512eed, 8 instruction(s), calls KERNEL32.dll!InterlockedIncrement, ends with je to 0x00512f2c (forward)
    push esi                                     # 00512f02
    mov esi, 0x63cee8                            # 00512f03
    push edi                                     # 00512f08
    push esi                                     # 00512f09
    call dword ptr [0x52a200]                    # 00512f0a
    cmp dword ptr [0x63cee4], ebx                # 00512f10
    mov edi, dword ptr [0x52a1fc]                # 00512f16
    je.d8 L_00512f2c                             # 00512f1c
    # block 0x00512f1e: entered by fall-through of je at 0x00512f1c, 7 instruction(s), calls indirect edi, FUN_00512c18, falls into the block at 0x00512f2c
    push esi                                     # 00512f1e
    call edi                                     # 00512f1f
    push 0x13                                    # 00512f21
    call FUN_00512c18                            # 00512f23
    pop ecx                                      # 00512f28
    push 0x1                                     # 00512f29
    pop ebx                                      # 00512f2b
L_00512f2c:
    # block 0x00512f2c: entered by je at 0x00512f1c, 6 instruction(s), calls FUN_00512f53, ends with je to 0x00512f48 (forward)
    push dword ptr [esp + stk_10]                # 00512f2c
    call FUN_00512f53                            # 00512f30
    test ebx, ebx                                # 00512f35
    pop ecx                                      # 00512f37
    mov dword ptr [esp + stk_10], eax            # 00512f38
    je.d8 L_00512f48                             # 00512f3c
    # block 0x00512f3e: entered by fall-through of je at 0x00512f3c, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x00512f4b
    push 0x13                                    # 00512f3e
    call FUN_00512c79                            # 00512f40
    pop ecx                                      # 00512f45
    jmp.d8 L_00512f4b                            # 00512f46
L_00512f48:
    # block 0x00512f48: entered by je at 0x00512f3c, 2 instruction(s), calls indirect edi, falls into the block at 0x00512f4b
    push esi                                     # 00512f48
    call edi                                     # 00512f49
L_00512f4b:
    # block 0x00512f4b: entered by jmp at 0x00512f46, 3 instruction(s), falls into the block at 0x00512f51
    mov eax, dword ptr [esp + stk_10]            # 00512f4b
    pop edi                                      # 00512f4f
    pop esi                                      # 00512f50
L_00512f51:
    # block 0x00512f51: entered by jl at 0x00512ef6; jg at 0x00512efb, 2 instruction(s), ends with ret
    pop ebx                                      # 00512f51
    ret                                          # 00512f52

