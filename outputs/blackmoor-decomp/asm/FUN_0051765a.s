# FUN_0051765a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051765a
# extent:       0x0051765a-0x005176d9 (127 code bytes)
# span:         0x0051765a-0x005176d9 (code 127, tables 0, padding 0)
# sha256:       9cb8902d00b051b566376deb9405ac259bea16432f39ad9e2c9d48097952b95b
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051765a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esp + n] stk_4
# callees:      calls KERNEL32.dll!SetStdHandle, FUN_0050ea7e, FUN_0050ea87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)

.org 0x0051765a - 0x401000
.globl FUN_0051765a
FUN_0051765a:
    # block 0x0051765a: entry, 5 instruction(s), ends with jae to 0x005176c0 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0051765a
    push esi                                     # 0051765e
    cmp ecx, dword ptr [0x63cee0]                # 0051765f
    push edi                                     # 00517665
    jae.d8 L_005176c0                            # 00517666
    # block 0x00517668: entered by fall-through of jae at 0x00517666, 11 instruction(s), ends with je to 0x005176c0 (forward)
    {load} mov eax, ecx                          # 00517668
    sar eax, 0x5                                 # 0051766a
    lea edi, [4*eax + 0x63cde0]                  # 0051766d
    {load} mov eax, ecx                          # 00517674
    and eax, 0x1f                                # 00517676
    lea esi, [eax + 8*eax]                       # 00517679
    mov eax, dword ptr [edi]                     # 0051767c
    shl esi, 0x2                                 # 0051767e
    {load} add eax, esi                          # 00517681
    test byte ptr [eax + field_4], 0x1           # 00517683
    je.d8 L_005176c0                             # 00517687
    # block 0x00517689: entered by fall-through of je at 0x00517687, 2 instruction(s), ends with je to 0x005176c0 (forward)
    cmp dword ptr [eax], -0x1                    # 00517689
    je.d8 L_005176c0                             # 0051768c
    # block 0x0051768e: entered by fall-through of je at 0x0051768c, 2 instruction(s), ends with jne to 0x005176b6 (forward)
    cmp dword ptr [0x567e80], 0x1                # 0051768e
    jne.d8 L_005176b6                            # 00517695
    # block 0x00517697: entered by fall-through of jne at 0x00517695, 3 instruction(s), ends with je to 0x005176ad (forward)
    {load} xor eax, eax                          # 00517697
    {load} sub ecx, eax                          # 00517699
    je.d8 L_005176ad                             # 0051769b
    # block 0x0051769d: entered by fall-through of je at 0x0051769b, 2 instruction(s), ends with je to 0x005176a8 (forward)
    dec ecx                                      # 0051769d
    je.d8 L_005176a8                             # 0051769e
    # block 0x005176a0: entered by fall-through of je at 0x0051769e, 2 instruction(s), ends with jne to 0x005176b6 (forward)
    dec ecx                                      # 005176a0
    jne.d8 L_005176b6                            # 005176a1
    # block 0x005176a3: entered by fall-through of jne at 0x005176a1, 3 instruction(s), ends with forward jump to 0x005176b0
    push eax                                     # 005176a3
    push -0xc                                    # 005176a4
    jmp.d8 L_005176b0                            # 005176a6
L_005176a8:
    # block 0x005176a8: entered by je at 0x0051769e, 3 instruction(s), ends with forward jump to 0x005176b0
    push eax                                     # 005176a8
    push -0xb                                    # 005176a9
    jmp.d8 L_005176b0                            # 005176ab
L_005176ad:
    # block 0x005176ad: entered by je at 0x0051769b, 2 instruction(s), falls into the block at 0x005176b0
    push eax                                     # 005176ad
    push -0xa                                    # 005176ae
L_005176b0:
    # block 0x005176b0: entered by jmp at 0x005176a6; jmp at 0x005176ab, 1 instruction(s), calls KERNEL32.dll!SetStdHandle, falls into the block at 0x005176b6
    call dword ptr [0x52a1bc]                    # 005176b0
L_005176b6:
    # block 0x005176b6: entered by jne at 0x00517695; jne at 0x005176a1, 4 instruction(s), ends with forward jump to 0x005176d6
    mov eax, dword ptr [edi]                     # 005176b6
    or dword ptr [eax + esi], -0x1               # 005176b8
    {load} xor eax, eax                          # 005176bc
    jmp.d8 L_005176d6                            # 005176be
L_005176c0:
    # block 0x005176c0: entered by jae at 0x00517666; je at 0x00517687; je at 0x0051768c, 5 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, falls into the block at 0x005176d6
    call FUN_0050ea7e                            # 005176c0
    mov dword ptr [eax], 0x9                     # 005176c5
    call FUN_0050ea87                            # 005176cb
    and dword ptr [eax], 0x0                     # 005176d0
    or eax, -0x1                                 # 005176d3
L_005176d6:
    # block 0x005176d6: entered by jmp at 0x005176be, 3 instruction(s), ends with ret
    pop edi                                      # 005176d6
    pop esi                                      # 005176d7
    ret                                          # 005176d8

