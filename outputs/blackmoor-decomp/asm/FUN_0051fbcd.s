# FUN_0051fbcd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fbcd
# extent:       0x0051fbcd-0x0051fbfc (47 code bytes)
# span:         0x0051fbcd-0x0051fbfc (code 47, tables 0, padding 0)
# sha256:       f11033a1e8cb48df082584cd50a4e774f52532f6c71849a136188eb127887205
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fbcd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_c
# callees:      calls FUN_0051fcc6, FUN_0051fbfc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051fbfc, .text + (0x0051fbfc - 0x401000)
.set FUN_0051fcc6, .text + (0x0051fcc6 - 0x401000)

.org 0x0051fbcd - 0x401000
.globl FUN_0051fbcd
FUN_0051fbcd:
    # block 0x0051fbcd: entry, 7 instruction(s), ends with jne to 0x0051fbe5 (forward)
    push esi                                     # 0051fbcd
    push edi                                     # 0051fbce
    mov edi, dword ptr [esp + stk_c]             # 0051fbcf
    {load} xor eax, eax                          # 0051fbd3
    {load} cmp edi, eax                          # 0051fbd5
    {load} mov esi, ecx                          # 0051fbd7
    jne.d8 L_0051fbe5                            # 0051fbd9
    # block 0x0051fbdb: entered by fall-through of jne at 0x0051fbd9, 4 instruction(s), ends with forward jump to 0x0051fbf5
    mov dword ptr [esi], eax                     # 0051fbdb
    mov dword ptr [esi + field_4], eax           # 0051fbdd
    mov dword ptr [esi + field_8], eax           # 0051fbe0
    jmp.d8 L_0051fbf5                            # 0051fbe3
L_0051fbe5:
    # block 0x0051fbe5: entered by jne at 0x0051fbd9, 7 instruction(s), calls FUN_0051fcc6, FUN_0051fbfc, falls into the block at 0x0051fbf5
    push edi                                     # 0051fbe5
    call FUN_0051fcc6                            # 0051fbe6
    pop ecx                                      # 0051fbeb
    push eax                                     # 0051fbec
    push edi                                     # 0051fbed
    {load} mov ecx, esi                          # 0051fbee
    call FUN_0051fbfc                            # 0051fbf0
L_0051fbf5:
    # block 0x0051fbf5: entered by jmp at 0x0051fbe3, 4 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051fbf5
    pop edi                                      # 0051fbf7
    pop esi                                      # 0051fbf8
    ret 0x4                                      # 0051fbf9

