# FUN_00520069
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520069
# extent:       0x00520069-0x00520121 (184 code bytes)
# span:         0x00520069-0x00520121 (code 184, tables 0, padding 0)
# sha256:       46c44ef49b6f79446fcb21d3b887f73b8e4ca4c28d6e934ff46cd6553ae18b36
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520069
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x14 (callee pops 20 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_18, field_minus_4, field_minus_c, field_minus_10, field_minus_14; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c; [scaled index + n] field_4
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_0050cb26, FUN_0051e8f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)

.org 0x00520069 - 0x401000
.globl FUN_00520069
FUN_00520069:
    # block 0x00520069: entry, 28 instruction(s), calls FUN_0050f978, FUN_0051dc43, ends with je to 0x005200e1 (forward)
    mov eax, 0x5291c3                            # 00520069
    call FUN_0050f978                            # 0052006e
    push ecx                                     # 00520073
    push ecx                                     # 00520074
    mov eax, dword ptr [0x5679b0]                # 00520075
    push ebx                                     # 0052007a
    push esi                                     # 0052007b
    {load} mov esi, ecx                          # 0052007c
    push edi                                     # 0052007e
    mov dword ptr [ebp - field_minus_10], esi    # 0052007f
    lea ebx, [esi + field_c]                     # 00520082
    mov dword ptr [ebx], eax                     # 00520085
    mov eax, dword ptr [0x5679b0]                # 00520087
    and dword ptr [ebp - field_minus_4], 0x0     # 0052008c
    mov dword ptr [esi + field_10], eax          # 00520090
    mov eax, dword ptr [0x5679b0]                # 00520093
    mov dword ptr [esi + field_1c], eax          # 00520098
    mov edi, dword ptr [ebp + field_14]          # 0052009b
    mov byte ptr [ebp - field_minus_4], 0x2      # 0052009e
    mov dword ptr [esi], 0x5300dc                # 005200a2
    lea eax, [4*edi + field_4]                   # 005200a8
    push eax                                     # 005200af
    call FUN_0051dc43                            # 005200b0
    pop ecx                                      # 005200b5
    mov dword ptr [ebp - field_minus_14], eax    # 005200b6
    test eax, eax                                # 005200b9
    mov byte ptr [ebp - field_minus_4], 0x3      # 005200bb
    je.d8 L_005200e1                             # 005200bf
    # block 0x005200c1: entered by fall-through of je at 0x005200bf, 11 instruction(s), calls FUN_0050cb26, ends with forward jump to 0x005200e3
    push 0x51e7ba                                # 005200c1
    mov dword ptr [eax], edi                     # 005200c6
    push 0x422fe0                                # 005200c8
    add eax, 0x4                                 # 005200cd
    push edi                                     # 005200d0
    push 0x4                                     # 005200d1
    push eax                                     # 005200d3
    mov dword ptr [ebp + field_14], eax          # 005200d4
    call FUN_0050cb26                            # 005200d7
    mov eax, dword ptr [ebp + field_14]          # 005200dc
    jmp.d8 L_005200e3                            # 005200df
L_005200e1:
    # block 0x005200e1: entered by je at 0x005200bf, 1 instruction(s), falls into the block at 0x005200e3
    {load} xor eax, eax                          # 005200e1
L_005200e3:
    # block 0x005200e3: entered by jmp at 0x005200df, 21 instruction(s), calls FUN_0051e8f7, ends with ret 0x14
    push dword ptr [ebp + field_c]               # 005200e3
    mov dword ptr [esi + field_8], eax           # 005200e6
    mov eax, dword ptr [ebp + field_8]           # 005200e9
    {load} mov ecx, ebx                          # 005200ec
    mov byte ptr [ebp - field_minus_4], 0x2      # 005200ee
    mov dword ptr [esi + field_4], edi           # 005200f2
    mov dword ptr [esi + field_14], eax          # 005200f5
    call FUN_0051e8f7                            # 005200f8
    push dword ptr [ebp + field_10]              # 005200fd
    lea ecx, [esi + field_10]                    # 00520100
    call FUN_0051e8f7                            # 00520103
    mov eax, dword ptr [ebp + field_18]          # 00520108
    mov ecx, dword ptr [ebp - field_minus_c]     # 0052010b
    mov dword ptr [esi + field_18], eax          # 0052010e
    {load} mov eax, esi                          # 00520111
    pop edi                                      # 00520113
    pop esi                                      # 00520114
    pop ebx                                      # 00520115
    mov dword ptr fs:[0x0], ecx                  # 00520116
    leave                                        # 0052011d
    ret 0x14                                     # 0052011e

