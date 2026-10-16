# FUN_00513236
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513236
# extent:       0x00513236-0x005132c9 (147 code bytes)
# span:         0x00513236-0x005132c9 (code 147, tables 0, padding 0)
# sha256:       1a424a360cc47a65ea489277cbb4d2b5195916b53b1ffc622811e9f6416adf1d
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513236
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esp + n] stk_8
# callees:      calls FUN_0051771b, FUN_005176d9, KERNEL32.dll!FlushFileBuffers, KERNEL32.dll!GetLastError, FUN_0050ea87, FUN_0050ea7e, FUN_0051777a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_005176d9, .text + (0x005176d9 - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)

.org 0x00513236 - 0x401000
.globl FUN_00513236
FUN_00513236:
    # block 0x00513236: entry, 6 instruction(s), ends with jae to 0x005132b7 (forward)
    push ebx                                     # 00513236
    mov ebx, dword ptr [esp + stk_8]             # 00513237
    cmp ebx, dword ptr [0x63cee0]                # 0051323b
    push esi                                     # 00513241
    push edi                                     # 00513242
    jae.d8 L_005132b7                            # 00513243
    # block 0x00513245: entered by fall-through of jae at 0x00513243, 10 instruction(s), ends with je to 0x005132b7 (forward)
    {load} mov eax, ebx                          # 00513245
    sar eax, 0x5                                 # 00513247
    lea edi, [4*eax + 0x63cde0]                  # 0051324a
    {load} mov eax, ebx                          # 00513251
    and eax, 0x1f                                # 00513253
    lea esi, [eax + 8*eax]                       # 00513256
    mov eax, dword ptr [edi]                     # 00513259
    shl esi, 0x2                                 # 0051325b
    test byte ptr [eax + esi + field_4], 0x1     # 0051325e
    je.d8 L_005132b7                             # 00513263
    # block 0x00513265: entered by fall-through of je at 0x00513263, 6 instruction(s), calls FUN_0051771b, ends with je to 0x0051329e (forward)
    push ebx                                     # 00513265
    call FUN_0051771b                            # 00513266
    mov eax, dword ptr [edi]                     # 0051326b
    pop ecx                                      # 0051326d
    test byte ptr [eax + esi + field_4], 0x1     # 0051326e
    je.d8 L_0051329e                             # 00513273
    # block 0x00513275: entered by fall-through of je at 0x00513273, 7 instruction(s), calls FUN_005176d9, KERNEL32.dll!FlushFileBuffers, ends with jne to 0x00513291 (forward)
    push ebx                                     # 00513275
    call FUN_005176d9                            # 00513276
    pop ecx                                      # 0051327b
    push eax                                     # 0051327c
    call dword ptr [0x52a108]                    # 0051327d
    test eax, eax                                # 00513283
    jne.d8 L_00513291                            # 00513285
    # block 0x00513287: entered by fall-through of jne at 0x00513285, 3 instruction(s), calls KERNEL32.dll!GetLastError, ends with forward jump to 0x00513293
    call dword ptr [0x52a2a4]                    # 00513287
    {load} mov esi, eax                          # 0051328d
    jmp.d8 L_00513293                            # 0051328f
L_00513291:
    # block 0x00513291: entered by jne at 0x00513285, 1 instruction(s), falls into the block at 0x00513293
    {load} xor esi, esi                          # 00513291
L_00513293:
    # block 0x00513293: entered by jmp at 0x0051328f, 2 instruction(s), ends with je to 0x005132ac (forward)
    test esi, esi                                # 00513293
    je.d8 L_005132ac                             # 00513295
    # block 0x00513297: entered by fall-through of je at 0x00513295, 2 instruction(s), calls FUN_0050ea87, falls into the block at 0x0051329e
    call FUN_0050ea87                            # 00513297
    mov dword ptr [eax], esi                     # 0051329c
L_0051329e:
    # block 0x0051329e: entered by je at 0x00513273, 3 instruction(s), calls FUN_0050ea7e, falls into the block at 0x005132ac
    call FUN_0050ea7e                            # 0051329e
    mov dword ptr [eax], 0x9                     # 005132a3
    or esi, -0x1                                 # 005132a9
L_005132ac:
    # block 0x005132ac: entered by je at 0x00513295, 5 instruction(s), calls FUN_0051777a, ends with forward jump to 0x005132c5
    push ebx                                     # 005132ac
    call FUN_0051777a                            # 005132ad
    pop ecx                                      # 005132b2
    {load} mov eax, esi                          # 005132b3
    jmp.d8 L_005132c5                            # 005132b5
L_005132b7:
    # block 0x005132b7: entered by jae at 0x00513243; je at 0x00513263, 3 instruction(s), calls FUN_0050ea7e, falls into the block at 0x005132c5
    call FUN_0050ea7e                            # 005132b7
    mov dword ptr [eax], 0x9                     # 005132bc
    or eax, -0x1                                 # 005132c2
L_005132c5:
    # block 0x005132c5: entered by jmp at 0x005132b5, 4 instruction(s), ends with ret
    pop edi                                      # 005132c5
    pop esi                                      # 005132c6
    pop ebx                                      # 005132c7
    ret                                          # 005132c8

