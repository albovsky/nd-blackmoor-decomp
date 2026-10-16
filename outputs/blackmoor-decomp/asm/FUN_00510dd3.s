# FUN_00510dd3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510dd3
# extent:       0x00510dd3-0x00510e3a (103 code bytes)
# span:         0x00510dd3-0x00510e3a (code 103, tables 0, padding 0)
# sha256:       20cf859c5de096b4df74fcb2a62bf3fe20adc24e692782e53d071c8e8fea0893
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510dd3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4
# callees:      calls KERNEL32.dll!GetLastError, KERNEL32.dll!TlsGetValue, FUN_0050e97e, KERNEL32.dll!TlsSetValue, FUN_00510dc0, KERNEL32.dll!GetCurrentThreadId, FUN_0050e8ed, KERNEL32.dll!SetLastError
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_00510dc0, .text + (0x00510dc0 - 0x401000)

.org 0x00510dd3 - 0x401000
.globl FUN_00510dd3
FUN_00510dd3:
    # block 0x00510dd3: entry, 9 instruction(s), calls KERNEL32.dll!GetLastError, KERNEL32.dll!TlsGetValue, ends with jne to 0x00510e2e (forward)
    push esi                                     # 00510dd3
    push edi                                     # 00510dd4
    call dword ptr [0x52a2a4]                    # 00510dd5
    push dword ptr [0x5681f0]                    # 00510ddb
    {load} mov edi, eax                          # 00510de1
    call dword ptr [0x52a0dc]                    # 00510de3
    {load} mov esi, eax                          # 00510de9
    test esi, esi                                # 00510deb
    jne.d8 L_00510e2e                            # 00510ded
    # block 0x00510def: entered by fall-through of jne at 0x00510ded, 8 instruction(s), calls FUN_0050e97e, ends with je to 0x00510e26 (forward)
    push 0x74                                    # 00510def
    push 0x1                                     # 00510df1
    call FUN_0050e97e                            # 00510df3
    {load} mov esi, eax                          # 00510df8
    pop ecx                                      # 00510dfa
    test esi, esi                                # 00510dfb
    pop ecx                                      # 00510dfd
    je.d8 L_00510e26                             # 00510dfe
    # block 0x00510e00: entered by fall-through of je at 0x00510dfe, 5 instruction(s), calls KERNEL32.dll!TlsSetValue, ends with je to 0x00510e26 (forward)
    push esi                                     # 00510e00
    push dword ptr [0x5681f0]                    # 00510e01
    call dword ptr [0x52a0d4]                    # 00510e07
    test eax, eax                                # 00510e0d
    je.d8 L_00510e26                             # 00510e0f
    # block 0x00510e11: entered by fall-through of je at 0x00510e0f, 7 instruction(s), calls FUN_00510dc0, KERNEL32.dll!GetCurrentThreadId, ends with forward jump to 0x00510e2e
    push esi                                     # 00510e11
    call FUN_00510dc0                            # 00510e12
    pop ecx                                      # 00510e17
    call dword ptr [0x52a2a0]                    # 00510e18
    or dword ptr [esi + field_4], -0x1           # 00510e1e
    mov dword ptr [esi], eax                     # 00510e22
    jmp.d8 L_00510e2e                            # 00510e24
L_00510e26:
    # block 0x00510e26: entered by je at 0x00510dfe; je at 0x00510e0f, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x00510e2e
    push 0x10                                    # 00510e26
    call FUN_0050e8ed                            # 00510e28
    pop ecx                                      # 00510e2d
L_00510e2e:
    # block 0x00510e2e: entered by jne at 0x00510ded; jmp at 0x00510e24, 6 instruction(s), calls KERNEL32.dll!SetLastError, ends with ret
    push edi                                     # 00510e2e
    call dword ptr [0x52a1d0]                    # 00510e2f
    {load} mov eax, esi                          # 00510e35
    pop edi                                      # 00510e37
    pop esi                                      # 00510e38
    ret                                          # 00510e39

