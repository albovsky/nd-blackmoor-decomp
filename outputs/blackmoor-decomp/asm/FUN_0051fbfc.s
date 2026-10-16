# FUN_0051fbfc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fbfc
# extent:       0x0051fbfc-0x0051fc5c (96 code bytes)
# span:         0x0051fbfc-0x0051fc5c (code 96, tables 0, padding 0)
# sha256:       ea71905281bbb3d75eb80abb1791e846afe5b941fe3943924cf8a1db2b21b0aa
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fbfc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_2, field_c; [esi + n] field_4, field_8; [esp + n] stk_8, stk_10
# callees:      calls KERNEL32.dll!GlobalAlloc, KERNEL32.dll!GlobalLock, FUN_0050fa90, KERNEL32.dll!GlobalUnlock
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)

.org 0x0051fbfc - 0x401000
.globl FUN_0051fbfc
FUN_0051fbfc:
    # block 0x0051fbfc: entry, 11 instruction(s), calls KERNEL32.dll!GlobalAlloc, ends with je to 0x0051fc58 (forward)
    mov eax, dword ptr [esp + stk_8]             # 0051fbfc
    push esi                                     # 0051fc00
    {load} mov esi, ecx                          # 0051fc01
    mov dword ptr [esi + field_4], eax           # 0051fc03
    add eax, 0x40                                # 0051fc06
    push eax                                     # 0051fc09
    push 0x40                                    # 0051fc0a
    call dword ptr [0x52a1dc]                    # 0051fc0c
    test eax, eax                                # 0051fc12
    mov dword ptr [esi], eax                     # 0051fc14
    je.d8 L_0051fc58                             # 0051fc16
    # block 0x0051fc18: entered by fall-through of je at 0x0051fc16, 11 instruction(s), calls KERNEL32.dll!GlobalLock, FUN_0050fa90, ends with jne to 0x0051fc3f (forward)
    push edi                                     # 0051fc18
    push eax                                     # 0051fc19
    call dword ptr [0x52a204]                    # 0051fc1a
    push dword ptr [esi + field_4]               # 0051fc20
    {load} mov edi, eax                          # 0051fc23
    push dword ptr [esp + stk_10]                # 0051fc25
    push edi                                     # 0051fc29
    call FUN_0050fa90                            # 0051fc2a
    add esp, 0xc                                 # 0051fc2f
    .insn 0x6681/7, dword ptr [edi + field_2], -1{:s16} # 0051fc32
    jne.d8 L_0051fc3f                            # 0051fc38
    # block 0x0051fc3a: entered by fall-through of jne at 0x0051fc38, 2 instruction(s), ends with forward jump to 0x0051fc41
    mov eax, dword ptr [edi + field_c]           # 0051fc3a
    jmp.d8 L_0051fc41                            # 0051fc3d
L_0051fc3f:
    # block 0x0051fc3f: entered by jne at 0x0051fc38, 1 instruction(s), falls into the block at 0x0051fc41
    mov eax, dword ptr [edi]                     # 0051fc3f
L_0051fc41:
    # block 0x0051fc41: entered by jmp at 0x0051fc3d, 9 instruction(s), calls KERNEL32.dll!GlobalUnlock, falls into the block at 0x0051fc58
    push dword ptr [esi]                         # 0051fc41
    not eax                                      # 0051fc43
    shr eax, 0x6                                 # 0051fc45
    and eax, 0x1                                 # 0051fc48
    mov dword ptr [esi + field_8], eax           # 0051fc4b
    call dword ptr [0x52a208]                    # 0051fc4e
    push 0x1                                     # 0051fc54
    pop eax                                      # 0051fc56
    pop edi                                      # 0051fc57
L_0051fc58:
    # block 0x0051fc58: entered by je at 0x0051fc16, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051fc58
    ret 0x8                                      # 0051fc59

