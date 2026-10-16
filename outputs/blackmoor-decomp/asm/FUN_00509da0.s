# FUN_00509da0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509da0
# extent:       0x00509da0-0x00509e45 (165 code bytes)
# span:         0x00509da0-0x00509e50 (code 165, tables 0, padding 11)
# sha256:       b436fe95a7b00a0f284263f5b692fa6bc7733a63f0c5256a3536dd18655f2160
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509da0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_504; [edx + n] field_8000; [esp + n] stk_8, stk_14, stk_18, stk_20, stk_24
# callees:      calls FUN_004fee30
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 61 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_504, 0x504  # offset +0x504
.equ field_8000, 0x8000  # offset +0x8000

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)

.org 0x00509da0 - 0x401000
.globl FUN_00509da0
FUN_00509da0:
    # block 0x00509da0: entry, 10 instruction(s), ends with je to 0x00509e40 (forward)
    mov eax, dword ptr [esp + stk_8]             # 00509da0
    push ebx                                     # 00509da4
    push ebp                                     # 00509da5
    push esi                                     # 00509da6
    mov ebp, dword ptr [eax + field_504]         # 00509da7
    mov esi, dword ptr [esp + stk_18]            # 00509dad
    {load} xor eax, eax                          # 00509db1
    push edi                                     # 00509db3
    test esi, esi                                # 00509db4
    je.d32 L_00509e40                            # 00509db6
    # block 0x00509dbc: entered by fall-through of je at 0x00509db6, 3 instruction(s), ends with je to 0x00509e40 (forward)
    mov ebx, dword ptr [esp + stk_20]            # 00509dbc
    test ebx, ebx                                # 00509dc0
    je.d8 L_00509e40                             # 00509dc2
    # block 0x00509dc4: entered by fall-through of je at 0x00509dc2, 10 instruction(s), calls FUN_004fee30, ends with jle to 0x00509e3e (forward)
    mov edx, dword ptr [esp + stk_14]            # 00509dc4
    lea ecx, [4*ebp]                             # 00509dc8
    push ecx                                     # 00509dcf
    push edx                                     # 00509dd0
    call FUN_004fee30                            # 00509dd1
    add esp, 0x8                                 # 00509dd6
    {load} mov edi, eax                          # 00509dd9
    test ebp, ebp                                # 00509ddb
    mov dword ptr [esp + stk_18], edi            # 00509ddd
    jle.d8 L_00509e3e                            # 00509de1
    # block 0x00509de3: entered by fall-through of jle at 0x00509de1, 6 instruction(s), falls into the block at 0x00509df4
    mov ecx, dword ptr [esp + stk_24]            # 00509de3
    mov eax, 0x10000                             # 00509de7
    {load} sub eax, ecx                          # 00509dec
    {load} sub esi, ebx                          # 00509dee
    {load} mov ecx, ebx                          # 00509df0
    {load} sub edi, ebx                          # 00509df2
L_00509df4:
    # block 0x00509df4: entered by jne at 0x00509e33, 12 instruction(s), ends with je to 0x00509e2f (forward)
    mov edx, dword ptr [esi + ecx]               # 00509df4
    mov ebx, dword ptr [ecx]                     # 00509df7
    and edx, 0x7fff                              # 00509df9
    and ebx, 0x7fff                              # 00509dff
    imul ebx, dword ptr [esp + stk_24]           # 00509e05
    imul edx, eax                                # 00509e0a
    lea edx, [edx + ebx + field_8000]            # 00509e0d
    sar edx, 0x10                                # 00509e14
    mov dword ptr [edi + ecx], edx               # 00509e17
    mov ebx, dword ptr [esi + ecx]               # 00509e1a
    test bh, -0x80                               # 00509e1d
    je.d8 L_00509e2f                             # 00509e20
    # block 0x00509e22: entered by fall-through of je at 0x00509e20, 3 instruction(s), ends with je to 0x00509e2f (forward)
    mov ebx, dword ptr [ecx]                     # 00509e22
    test bh, -0x80                               # 00509e24
    je.d8 L_00509e2f                             # 00509e27
    # block 0x00509e29: entered by fall-through of je at 0x00509e27, 2 instruction(s), falls into the block at 0x00509e2f
    or dh, -0x80                                 # 00509e29
    mov dword ptr [edi + ecx], edx               # 00509e2c
L_00509e2f:
    # block 0x00509e2f: entered by je at 0x00509e20; je at 0x00509e27, 3 instruction(s), ends with jne to 0x00509df4 (backward)
    add ecx, 0x4                                 # 00509e2f
    dec ebp                                      # 00509e32
    jne.d8 L_00509df4                            # 00509e33
    # block 0x00509e35: entered by fall-through of jne at 0x00509e33, 6 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_18]            # 00509e35
    pop edi                                      # 00509e39
    pop esi                                      # 00509e3a
    pop ebp                                      # 00509e3b
    pop ebx                                      # 00509e3c
    ret                                          # 00509e3d
L_00509e3e:
    # block 0x00509e3e: entered by jle at 0x00509de1, 1 instruction(s), falls into the block at 0x00509e40
    {load} mov eax, edi                          # 00509e3e
L_00509e40:
    # block 0x00509e40: entered by je at 0x00509db6; je at 0x00509dc2, 5 instruction(s), ends with ret
    pop edi                                      # 00509e40
    pop esi                                      # 00509e41
    pop ebp                                      # 00509e42
    pop ebx                                      # 00509e43
    ret                                          # 00509e44

# --- data items (not part of the function) -------------------------
.org 0x00509e45 - 0x401000
PAD_00509e45:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

