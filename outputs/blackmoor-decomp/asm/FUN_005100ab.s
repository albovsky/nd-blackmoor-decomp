# FUN_005100ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005100ab
# extent:       0x005100ab-0x00510122 (119 code bytes)
# span:         0x005100ab-0x00510122 (code 119, tables 0, padding 0)
# sha256:       eb8445c6609d59cbd1f1be7856b87afaa83a2ac29bb76335425e2be89ca4b7dc
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005100ab
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10
# callees:      calls FUN_00512c18, FUN_00514f63, FUN_0051576e, FUN_00512c79, KERNEL32.dll!HeapReAlloc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00514f63, .text + (0x00514f63 - 0x401000)
.set FUN_0051576e, .text + (0x0051576e - 0x401000)

.org 0x005100ab - 0x401000
.globl FUN_005100ab
FUN_005100ab:
    # block 0x005100ab: entry, 5 instruction(s), ends with jbe to 0x005100ba (forward)
    push ebx                                     # 005100ab
    push esi                                     # 005100ac
    mov esi, dword ptr [esp + stk_10]            # 005100ad
    cmp esi, -0x20                               # 005100b1
    jbe.d8 L_005100ba                            # 005100b4
    # block 0x005100b6: entered by fall-through of jbe at 0x005100b4, 2 instruction(s), ends with forward jump to 0x0051011f
    {load} xor eax, eax                          # 005100b6
    jmp.d8 L_0051011f                            # 005100b8
L_005100ba:
    # block 0x005100ba: entered by jbe at 0x005100b4, 9 instruction(s), calls FUN_00512c18, FUN_00514f63, ends with je to 0x005100fa (forward)
    push 0x9                                     # 005100ba
    call FUN_00512c18                            # 005100bc
    mov ebx, dword ptr [esp + stk_10]            # 005100c1
    push ebx                                     # 005100c5
    call FUN_00514f63                            # 005100c6
    pop ecx                                      # 005100cb
    test eax, eax                                # 005100cc
    pop ecx                                      # 005100ce
    je.d8 L_005100fa                             # 005100cf
    # block 0x005100d1: entered by fall-through of je at 0x005100cf, 4 instruction(s), ends with ja to 0x005100ed (forward)
    push edi                                     # 005100d1
    {load} xor edi, edi                          # 005100d2
    cmp esi, dword ptr [0x568b78]                # 005100d4
    ja.d8 L_005100ed                             # 005100da
    # block 0x005100dc: entered by fall-through of ja at 0x005100da, 7 instruction(s), calls FUN_0051576e, ends with je to 0x005100ed (forward)
    push esi                                     # 005100dc
    push ebx                                     # 005100dd
    push eax                                     # 005100de
    call FUN_0051576e                            # 005100df
    add esp, 0xc                                 # 005100e4
    test eax, eax                                # 005100e7
    je.d8 L_005100ed                             # 005100e9
    # block 0x005100eb: entered by fall-through of je at 0x005100e9, 1 instruction(s), falls into the block at 0x005100ed
    {load} mov edi, ebx                          # 005100eb
L_005100ed:
    # block 0x005100ed: entered by ja at 0x005100da; je at 0x005100e9, 6 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0051011f
    push 0x9                                     # 005100ed
    call FUN_00512c79                            # 005100ef
    pop ecx                                      # 005100f4
    {load} mov eax, edi                          # 005100f5
    pop edi                                      # 005100f7
    jmp.d8 L_0051011f                            # 005100f8
L_005100fa:
    # block 0x005100fa: entered by je at 0x005100cf, 5 instruction(s), calls FUN_00512c79, ends with jne to 0x00510109 (forward)
    push 0x9                                     # 005100fa
    call FUN_00512c79                            # 005100fc
    test esi, esi                                # 00510101
    pop ecx                                      # 00510103
    jne.d8 L_00510109                            # 00510104
    # block 0x00510106: entered by fall-through of jne at 0x00510104, 2 instruction(s), falls into the block at 0x00510109
    push 0x1                                     # 00510106
    pop esi                                      # 00510108
L_00510109:
    # block 0x00510109: entered by jne at 0x00510104, 7 instruction(s), calls KERNEL32.dll!HeapReAlloc, falls into the block at 0x0051011f
    add esi, 0xf                                 # 00510109
    and esi, -0x10                               # 0051010c
    push esi                                     # 0051010f
    push ebx                                     # 00510110
    push 0x10                                    # 00510111
    push dword ptr [0x63cdd8]                    # 00510113
    call dword ptr [0x52a154]                    # 00510119
L_0051011f:
    # block 0x0051011f: entered by jmp at 0x005100b8; jmp at 0x005100f8, 3 instruction(s), ends with ret
    pop esi                                      # 0051011f
    pop ebx                                      # 00510120
    ret                                          # 00510121

