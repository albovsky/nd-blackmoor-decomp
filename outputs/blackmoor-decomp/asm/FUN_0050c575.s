# FUN_0050c575
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c575
# extent:       0x0050c575-0x0050c5ee (121 code bytes)
# span:         0x0050c575-0x0050c5ee (code 121, tables 0, padding 0)
# sha256:       913a992e8770e183127132a7904ab191fd101cc076663ffe7696925a0a19f132
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c575
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10, field_minus_14; [edx + n] field_4; [esi + n] field_4, field_8, field_c, field_10
# callees:      calls FUN_0050f978, KERNEL32.dll!EnterCriticalSection, FUN_0051a3d4, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a3d4, .text + (0x0051a3d4 - 0x401000)

.org 0x0050c575 - 0x401000
.globl FUN_0050c575
FUN_0050c575:
    # block 0x0050c575: entry, 14 instruction(s), calls FUN_0050f978, KERNEL32.dll!EnterCriticalSection, ends with jne to 0x0050c5ce (forward)
    mov eax, 0x52913c                            # 0050c575
    call FUN_0050f978                            # 0050c57a
    sub esp, 0xc                                 # 0050c57f
    push ebx                                     # 0050c582
    push esi                                     # 0050c583
    {load} mov esi, ecx                          # 0050c584
    push edi                                     # 0050c586
    mov dword ptr [ebp - field_minus_10], esp    # 0050c587
    mov dword ptr [ebp - field_minus_14], esi    # 0050c58a
    lea ebx, [esi + field_10]                    # 0050c58d
    push ebx                                     # 0050c590
    call dword ptr [0x52a0d0]                    # 0050c591
    cmp dword ptr [esi + field_c], 0x0           # 0050c597
    jne.d8 L_0050c5ce                            # 0050c59b
    # block 0x0050c59d: entered by fall-through of jne at 0x0050c59b, 13 instruction(s), calls FUN_0051a3d4, ends with jl to 0x0050c5ce (forward)
    push dword ptr [esi]                         # 0050c59d
    and dword ptr [ebp - field_minus_4], 0x0     # 0050c59f
    lea eax, [esi + field_8]                     # 0050c5a3
    push dword ptr [esi + field_4]               # 0050c5a6
    push eax                                     # 0050c5a9
    call FUN_0051a3d4                            # 0050c5aa
    mov ecx, dword ptr [esi + field_4]           # 0050c5af
    dec ecx                                      # 0050c5b2
    {load} mov edx, ecx                          # 0050c5b3
    imul edx, dword ptr [esi]                    # 0050c5b5
    test ecx, ecx                                # 0050c5b8
    lea eax, [edx + eax + field_4]               # 0050c5ba
    jl.d8 L_0050c5ce                             # 0050c5be
    # block 0x0050c5c0: entered by fall-through of jl at 0x0050c5be, 1 instruction(s), falls into the block at 0x0050c5c1
    inc ecx                                      # 0050c5c0
L_0050c5c1:
    # block 0x0050c5c1: entered by jne at 0x0050c5cc, 6 instruction(s), ends with jne to 0x0050c5c1 (backward)
    mov edx, dword ptr [esi + field_c]           # 0050c5c1
    mov dword ptr [eax], edx                     # 0050c5c4
    mov dword ptr [esi + field_c], eax           # 0050c5c6
    sub eax, dword ptr [esi]                     # 0050c5c9
    dec ecx                                      # 0050c5cb
    jne.d8 L_0050c5c1                            # 0050c5cc
L_0050c5ce:
    # block 0x0050c5ce: entered by jne at 0x0050c59b; jl at 0x0050c5be; fall-through of jne at 0x0050c5cc, 13 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    mov edi, dword ptr [esi + field_c]           # 0050c5ce
    push ebx                                     # 0050c5d1
    mov eax, dword ptr [edi]                     # 0050c5d2
    mov dword ptr [esi + field_c], eax           # 0050c5d4
    call dword ptr [0x52a0c8]                    # 0050c5d7
    mov ecx, dword ptr [ebp - field_minus_c]     # 0050c5dd
    {load} mov eax, edi                          # 0050c5e0
    pop edi                                      # 0050c5e2
    pop esi                                      # 0050c5e3
    mov dword ptr fs:[0x0], ecx                  # 0050c5e4
    pop ebx                                      # 0050c5eb
    leave                                        # 0050c5ec
    ret                                          # 0050c5ed

