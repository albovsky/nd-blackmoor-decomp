# FUN_0050bf50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bf50
# extent:       0x0050bf50-0x0050c028 (216 code bytes)
# span:         0x0050bf50-0x0050c028 (code 216, tables 0, padding 0)
# sha256:       b3d8af94fbc3796f762c23a1512ec039f07e44aed52d955616b5d6cd1820c5bc
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bf50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetModuleHandleA; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050bf50 - 0x401000
.globl FUN_0050bf50
FUN_0050bf50:
    # block 0x0050bf50: entry, 6 instruction(s), ends with je to 0x0050bf6d (forward)
    push ebx                                     # 0050bf50
    {load} xor ebx, ebx                          # 0050bf51
    cmp dword ptr [0x63c370], ebx                # 0050bf53
    push esi                                     # 0050bf59
    push edi                                     # 0050bf5a
    je.d8 L_0050bf6d                             # 0050bf5b
    # block 0x0050bf5d: entered by fall-through of je at 0x0050bf5b, 4 instruction(s), ends with forward jump to 0x0050c024
    {load} xor eax, eax                          # 0050bf5d
    cmp dword ptr [0x63c368], ebx                # 0050bf5f
    setne al                                     # 0050bf65
    jmp.d32 L_0050c024                           # 0050bf68
L_0050bf6d:
    # block 0x0050bf6d: entered by je at 0x0050bf5b, 5 instruction(s), calls KERNEL32.dll!GetModuleHandleA, ends with je to 0x0050bff4 (forward)
    push 0x52ea34                                # 0050bf6d
    call dword ptr [0x52a248]                    # 0050bf72
    {load} mov edi, eax                          # 0050bf78
    {load} cmp edi, ebx                          # 0050bf7a
    je.d8 L_0050bff4                             # 0050bf7c
    # block 0x0050bf7e: entered by fall-through of je at 0x0050bf7c, 7 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    mov esi, dword ptr [0x52a24c]                # 0050bf7e
    push 0x52ea20                                # 0050bf84
    push edi                                     # 0050bf89
    call esi                                     # 0050bf8a
    {load} cmp eax, ebx                          # 0050bf8c
    mov dword ptr [0x63c358], eax                # 0050bf8e
    je.d8 L_0050bff4                             # 0050bf93
    # block 0x0050bf95: entered by fall-through of je at 0x0050bf93, 6 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    push 0x52ea0c                                # 0050bf95
    push edi                                     # 0050bf9a
    call esi                                     # 0050bf9b
    {load} cmp eax, ebx                          # 0050bf9d
    mov dword ptr [0x63c35c], eax                # 0050bf9f
    je.d8 L_0050bff4                             # 0050bfa4
    # block 0x0050bfa6: entered by fall-through of je at 0x0050bfa4, 6 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    push 0x52e9fc                                # 0050bfa6
    push edi                                     # 0050bfab
    call esi                                     # 0050bfac
    {load} cmp eax, ebx                          # 0050bfae
    mov dword ptr [0x63c360], eax                # 0050bfb0
    je.d8 L_0050bff4                             # 0050bfb5
    # block 0x0050bfb7: entered by fall-through of je at 0x0050bfb5, 6 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    push 0x52e9e8                                # 0050bfb7
    push edi                                     # 0050bfbc
    call esi                                     # 0050bfbd
    {load} cmp eax, ebx                          # 0050bfbf
    mov dword ptr [0x63c364], eax                # 0050bfc1
    je.d8 L_0050bff4                             # 0050bfc6
    # block 0x0050bfc8: entered by fall-through of je at 0x0050bfc6, 6 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    push 0x52e9d4                                # 0050bfc8
    push edi                                     # 0050bfcd
    call esi                                     # 0050bfce
    {load} cmp eax, ebx                          # 0050bfd0
    mov dword ptr [0x63c36c], eax                # 0050bfd2
    je.d8 L_0050bff4                             # 0050bfd7
    # block 0x0050bfd9: entered by fall-through of je at 0x0050bfd7, 6 instruction(s), calls indirect esi, ends with je to 0x0050bff4 (forward)
    push 0x52e9c4                                # 0050bfd9
    push edi                                     # 0050bfde
    call esi                                     # 0050bfdf
    {load} cmp eax, ebx                          # 0050bfe1
    mov dword ptr [0x63c368], eax                # 0050bfe3
    je.d8 L_0050bff4                             # 0050bfe8
    # block 0x0050bfea: entered by fall-through of je at 0x0050bfe8, 4 instruction(s), ends with forward jump to 0x0050c024
    push 0x1                                     # 0050bfea
    pop eax                                      # 0050bfec
    mov dword ptr [0x63c370], eax                # 0050bfed
    jmp.d8 L_0050c024                            # 0050bff2
L_0050bff4:
    # block 0x0050bff4: entered by je at 0x0050bf7c; je at 0x0050bf93; je at 0x0050bfa4; je at 0x0050bfb5; more, 8 instruction(s), falls into the block at 0x0050c024
    mov dword ptr [0x63c358], ebx                # 0050bff4
    mov dword ptr [0x63c35c], ebx                # 0050bffa
    mov dword ptr [0x63c360], ebx                # 0050c000
    mov dword ptr [0x63c364], ebx                # 0050c006
    mov dword ptr [0x63c368], ebx                # 0050c00c
    mov dword ptr [0x63c36c], ebx                # 0050c012
    mov dword ptr [0x63c370], 0x1                # 0050c018
    {load} xor eax, eax                          # 0050c022
L_0050c024:
    # block 0x0050c024: entered by jmp at 0x0050bf68; jmp at 0x0050bff2, 4 instruction(s), ends with ret
    pop edi                                      # 0050c024
    pop esi                                      # 0050c025
    pop ebx                                      # 0050c026
    ret                                          # 0050c027

