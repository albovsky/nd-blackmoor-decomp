# FUN_0052401f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052401f
# extent:       0x0052401f-0x005240f6 (215 code bytes)
# span:         0x0052401f-0x005240f6 (code 215, tables 0, padding 0)
# sha256:       4343235e5b8f3ce9b120441679ba94ee43de857fab824b7e1fa2b360b3a9f985
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052401f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_c, field_10, field_minus_4, field_minus_c, field_minus_10, field_minus_110; [esi + n] field_4, field_8, field_10, field_64, field_b4
# callees:      calls FUN_0050f978, USER32.dll!GetDlgCtrlID, FUN_0051fb2e, FUN_0051fb55, KERNEL32.dll!lstrcpynA, FUN_0051eb0c, USER32.dll!SetWindowPos, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 74 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005240f6
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_110, 0x110  # offset -0x110
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_64, 0x64  # offset +0x64
.equ field_b4, 0xb4  # offset +0xb4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051eb0c, .text + (0x0051eb0c - 0x401000)
.set FUN_0051fb2e, .text + (0x0051fb2e - 0x401000)
.set FUN_0051fb55, .text + (0x0051fb55 - 0x401000)

.org 0x0052401f - 0x401000
.globl FUN_0052401f
FUN_0052401f:
    # block 0x0052401f: entry, 16 instruction(s), calls FUN_0050f978, ends with jne to 0x00524057 (forward)
    mov eax, 0x528f94                            # 0052401f
    call FUN_0050f978                            # 00524024
    sub esp, 0x104                               # 00524029
    mov eax, dword ptr [0x5679b0]                # 0052402f
    push ebx                                     # 00524034
    push esi                                     # 00524035
    push edi                                     # 00524036
    mov dword ptr [ebp - field_minus_10], eax    # 00524037
    mov esi, dword ptr [ebp + field_c]           # 0052403a
    mov edi, 0xfffffdf8                          # 0052403d
    {load} xor ebx, ebx                          # 00524042
    mov eax, dword ptr [esi + field_8]           # 00524044
    mov ecx, dword ptr [esi + field_4]           # 00524047
    {load} cmp eax, edi                          # 0052404a
    mov dword ptr [ebp - field_minus_4], ebx     # 0052404c
    jne.d8 L_00524057                            # 0052404f
    # block 0x00524051: entered by fall-through of jne at 0x0052404f, 2 instruction(s), ends with jne to 0x00524067 (forward)
    test byte ptr [esi + field_64], 0x1          # 00524051
    jne.d8 L_00524067                            # 00524055
L_00524057:
    # block 0x00524057: entered by jne at 0x0052404f; fall-through of jne at 0x00524055, 2 instruction(s), ends with jne to 0x00524071 (forward)
    cmp eax, 0xfffffdee                          # 00524057
    jne.d8 L_00524071                            # 0052405c
    # block 0x0052405e: entered by fall-through of jne at 0x0052405c, 2 instruction(s), ends with je to 0x00524071 (forward)
    test byte ptr [esi + field_b4], 0x1          # 0052405e
    je.d8 L_00524071                             # 00524065
L_00524067:
    # block 0x00524067: entered by jne at 0x00524055; fall-through of je at 0x00524065, 3 instruction(s), calls USER32.dll!GetDlgCtrlID, falls into the block at 0x00524071
    push ecx                                     # 00524067
    call dword ptr [0x52a40c]                    # 00524068
    movzx ecx, ax                                # 0052406e
L_00524071:
    # block 0x00524071: entered by jne at 0x0052405c; je at 0x00524065, 2 instruction(s), ends with je to 0x0052409f (forward)
    {load} cmp ecx, ebx                          # 00524071
    je.d8 L_0052409f                             # 00524073
    # block 0x00524075: entered by fall-through of je at 0x00524073, 7 instruction(s), calls FUN_0051fb2e, ends with je to 0x005240d7 (forward)
    lea eax, [ebp - field_minus_110]             # 00524075
    push 0x100                                   # 0052407b
    push eax                                     # 00524080
    push ecx                                     # 00524081
    call FUN_0051fb2e                            # 00524082
    test eax, eax                                # 00524087
    je.d8 L_005240d7                             # 00524089
    # block 0x0052408b: entered by fall-through of je at 0x00524089, 7 instruction(s), calls FUN_0051fb55, falls into the block at 0x0052409f
    push 0xa                                     # 0052408b
    lea eax, [ebp - field_minus_110]             # 0052408d
    push 0x1                                     # 00524093
    push eax                                     # 00524095
    lea eax, [ebp - field_minus_10]              # 00524096
    push eax                                     # 00524099
    call FUN_0051fb55                            # 0052409a
L_0052409f:
    # block 0x0052409f: entered by je at 0x00524073, 6 instruction(s), ends with jne to 0x005240b5 (forward)
    cmp dword ptr [esi + field_8], edi           # 0052409f
    push 0x50                                    # 005240a2
    push dword ptr [ebp - field_minus_10]        # 005240a4
    lea eax, [esi + field_10]                    # 005240a7
    push eax                                     # 005240aa
    jne.d8 L_005240b5                            # 005240ab
    # block 0x005240ad: entered by fall-through of jne at 0x005240ab, 2 instruction(s), calls KERNEL32.dll!lstrcpynA, ends with forward jump to 0x005240bd
    call dword ptr [0x52a1d4]                    # 005240ad
    jmp.d8 L_005240bd                            # 005240b3
L_005240b5:
    # block 0x005240b5: entered by jne at 0x005240ab, 2 instruction(s), calls FUN_0051eb0c, falls into the block at 0x005240bd
    call FUN_0051eb0c                            # 005240b5
    add esp, 0xc                                 # 005240ba
L_005240bd:
    # block 0x005240bd: entered by jmp at 0x005240b3, 12 instruction(s), calls USER32.dll!SetWindowPos, falls into the block at 0x005240d7
    mov eax, dword ptr [ebp + field_10]          # 005240bd
    push 0x213                                   # 005240c0
    push ebx                                     # 005240c5
    push ebx                                     # 005240c6
    push ebx                                     # 005240c7
    push ebx                                     # 005240c8
    push ebx                                     # 005240c9
    mov dword ptr [eax], ebx                     # 005240ca
    push dword ptr [esi]                         # 005240cc
    call dword ptr [0x52a45c]                    # 005240ce
    push 0x1                                     # 005240d4
    pop ebx                                      # 005240d6
L_005240d7:
    # block 0x005240d7: entered by je at 0x00524089, 11 instruction(s), calls FUN_0051e7ba, ends with ret 0xc
    or dword ptr [ebp - field_minus_4], -0x1     # 005240d7
    lea ecx, [ebp - field_minus_10]              # 005240db
    call FUN_0051e7ba                            # 005240de
    mov ecx, dword ptr [ebp - field_minus_c]     # 005240e3
    pop edi                                      # 005240e6
    {load} mov eax, ebx                          # 005240e7
    pop esi                                      # 005240e9
    pop ebx                                      # 005240ea
    mov dword ptr fs:[0x0], ecx                  # 005240eb
    leave                                        # 005240f2
    ret 0xc                                      # 005240f3

