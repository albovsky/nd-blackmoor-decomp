# FUN_0051fd7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fd7e
# extent:       0x0051fd7e-0x0051fded (111 code bytes)
# span:         0x0051fd7e-0x0051fded (code 111, tables 0, padding 0)
# sha256:       80b32a505fd32c4b4b46dba74e78981181fc12e45cde4339aef14a4a84c343d5
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fd7e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_2, field_c; [esp + n] stk_8, stk_c, stk_14, stk_1c
# callees:      calls FUN_0051fc70, FUN_0051eaec, KERNEL32.dll!WideCharToMultiByte, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_0051eaec, .text + (0x0051eaec - 0x401000)
.set FUN_0051fc70, .text + (0x0051fc70 - 0x401000)

.org 0x0051fd7e - 0x401000
.globl FUN_0051fd7e
FUN_0051fd7e:
    # block 0x0051fd7e: entry, 4 instruction(s), ends with jne to 0x0051fd90 (forward)
    push esi                                     # 0051fd7e
    mov esi, dword ptr [esp + stk_8]             # 0051fd7f
    .insn 0x6681/7, dword ptr [esi + field_2], -1{:s16} # 0051fd83
    jne.d8 L_0051fd90                            # 0051fd89
    # block 0x0051fd8b: entered by fall-through of jne at 0x0051fd89, 2 instruction(s), ends with forward jump to 0x0051fd92
    mov eax, dword ptr [esi + field_c]           # 0051fd8b
    jmp.d8 L_0051fd92                            # 0051fd8e
L_0051fd90:
    # block 0x0051fd90: entered by jne at 0x0051fd89, 1 instruction(s), falls into the block at 0x0051fd92
    mov eax, dword ptr [esi]                     # 0051fd90
L_0051fd92:
    # block 0x0051fd92: entered by jmp at 0x0051fd8e, 2 instruction(s), ends with jne to 0x0051fd9a (forward)
    test al, 0x40                                # 0051fd92
    jne.d8 L_0051fd9a                            # 0051fd94
    # block 0x0051fd96: entered by fall-through of jne at 0x0051fd94, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051fd96
    pop esi                                      # 0051fd98
    ret                                          # 0051fd99
L_0051fd9a:
    # block 0x0051fd9a: entered by jne at 0x0051fd94, 32 instruction(s), calls FUN_0051fc70, FUN_0051eaec, KERNEL32.dll!WideCharToMultiByte, FUN_0051eac4, ends with ret
    push esi                                     # 0051fd9a
    call FUN_0051fc70                            # 0051fd9b
    mov edx, dword ptr [esp + stk_14]            # 0051fda0
    pop ecx                                      # 0051fda4
    mov cx, word ptr [eax]                       # 0051fda5
    push 0x0                                     # 0051fda8
    mov word ptr [edx], cx                       # 0051fdaa
    {load} xor ecx, ecx                          # 0051fdad
    .insn 0x6681/7, dword ptr [esi + field_2], -1{:s16} # 0051fdaf
    push 0x0                                     # 0051fdb5
    push 0x20                                    # 0051fdb7
    push 0x20                                    # 0051fdb9
    setne cl                                     # 0051fdbb
    dec ecx                                      # 0051fdbe
    and ecx, 0x2                                 # 0051fdbf
    inc ecx                                      # 0051fdc2
    lea esi, [eax + 2*ecx]                       # 0051fdc3
    mov ecx, dword ptr [esp + stk_1c]            # 0051fdc6
    call FUN_0051eaec                            # 0051fdca
    push eax                                     # 0051fdcf
    push -0x1                                    # 0051fdd0
    push esi                                     # 0051fdd2
    push 0x0                                     # 0051fdd3
    push 0x0                                     # 0051fdd5
    call dword ptr [0x52a1f4]                    # 0051fdd7
    mov ecx, dword ptr [esp + stk_c]             # 0051fddd
    push -0x1                                    # 0051fde1
    call FUN_0051eac4                            # 0051fde3
    push 0x1                                     # 0051fde8
    pop eax                                      # 0051fdea
    pop esi                                      # 0051fdeb
    ret                                          # 0051fdec

