# FUN_0051743a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051743a
# extent:       0x0051743a-0x005174bb (129 code bytes)
# span:         0x0051743a-0x005174bb (code 129, tables 0, padding 0)
# sha256:       be98ccf5683c47576f15834a2ce8b0c4cee408d777f58de1781d910b4b234089
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00516f69 (+0x4d1)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051743a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c
# callees:      calls FUN_00512c18, FUN_0050cee4, KERNEL32.dll!DeleteCriticalSection, FUN_0050e936, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0051743a - 0x401000
.globl FUN_0051743a
FUN_0051743a:
    # block 0x0051743a: entry, 10 instruction(s), calls FUN_00512c18, ends with jle to 0x005174ae (forward)
    push ebx                                     # 0051743a
    push edi                                     # 0051743b
    push 0x2                                     # 0051743c
    {load} xor ebx, ebx                          # 0051743e
    call FUN_00512c18                            # 00517440
    pop ecx                                      # 00517445
    push 0x3                                     # 00517446
    pop edi                                      # 00517448
    cmp dword ptr [0x63df00], edi                # 00517449
    jle.d8 L_005174ae                            # 0051744f
    # block 0x00517451: entered by fall-through of jle at 0x0051744f, 1 instruction(s), falls into the block at 0x00517452
    push esi                                     # 00517451
L_00517452:
    # block 0x00517452: entered by jl at 0x005174ab, 6 instruction(s), ends with je to 0x005174a4 (forward)
    mov eax, dword ptr [0x63ceec]                # 00517452
    {load} mov esi, edi                          # 00517457
    shl esi, 0x2                                 # 00517459
    mov eax, dword ptr [esi + eax]               # 0051745c
    test eax, eax                                # 0051745f
    je.d8 L_005174a4                             # 00517461
    # block 0x00517463: entered by fall-through of je at 0x00517461, 2 instruction(s), ends with je to 0x00517476 (forward)
    test byte ptr [eax + field_c], -0x7d         # 00517463
    je.d8 L_00517476                             # 00517467
    # block 0x00517469: entered by fall-through of je at 0x00517467, 5 instruction(s), calls FUN_0050cee4, ends with je to 0x00517476 (forward)
    push eax                                     # 00517469
    call FUN_0050cee4                            # 0051746a
    cmp eax, -0x1                                # 0051746f
    pop ecx                                      # 00517472
    je.d8 L_00517476                             # 00517473
    # block 0x00517475: entered by fall-through of je at 0x00517473, 1 instruction(s), falls into the block at 0x00517476
    inc ebx                                      # 00517475
L_00517476:
    # block 0x00517476: entered by je at 0x00517467; je at 0x00517473, 2 instruction(s), ends with jl to 0x005174a4 (forward)
    cmp edi, 0x14                                # 00517476
    jl.d8 L_005174a4                             # 00517479
    # block 0x0051747b: entered by fall-through of jl at 0x00517479, 11 instruction(s), calls KERNEL32.dll!DeleteCriticalSection, FUN_0050e936, falls into the block at 0x005174a4
    mov eax, dword ptr [0x63ceec]                # 0051747b
    mov eax, dword ptr [esi + eax]               # 00517480
    add eax, 0x20                                # 00517483
    push eax                                     # 00517486
    call dword ptr [0x52a0bc]                    # 00517487
    mov eax, dword ptr [0x63ceec]                # 0051748d
    push dword ptr [esi + eax]                   # 00517492
    call FUN_0050e936                            # 00517495
    mov eax, dword ptr [0x63ceec]                # 0051749a
    pop ecx                                      # 0051749f
    and dword ptr [esi + eax], 0x0               # 005174a0
L_005174a4:
    # block 0x005174a4: entered by je at 0x00517461; jl at 0x00517479, 3 instruction(s), ends with jl to 0x00517452 (backward)
    inc edi                                      # 005174a4
    cmp edi, dword ptr [0x63df00]                # 005174a5
    jl.d8 L_00517452                             # 005174ab
    # block 0x005174ad: entered by fall-through of jl at 0x005174ab, 1 instruction(s), falls into the block at 0x005174ae
    pop esi                                      # 005174ad
L_005174ae:
    # block 0x005174ae: entered by jle at 0x0051744f, 7 instruction(s), calls FUN_00512c79, ends with ret
    push 0x2                                     # 005174ae
    call FUN_00512c79                            # 005174b0
    pop ecx                                      # 005174b5
    {load} mov eax, ebx                          # 005174b6
    pop edi                                      # 005174b8
    pop ebx                                      # 005174b9
    ret                                          # 005174ba

