# FUN_0051e08b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e08b
# extent:       0x0051e08b-0x0051e0c4 (57 code bytes)
# span:         0x0051e08b-0x0051e0c4 (code 57, tables 0, padding 0)
# sha256:       83c7264f46ded4fe4871966d46850a10d9625620dae54b0af6b005803ad0f75f
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e08b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_3c, field_40, field_50; [esp + n] stk_c, stk_1c
# callees:      calls FUN_0051a7c3, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)

.org 0x0051e08b - 0x401000
.globl FUN_0051e08b
FUN_0051e08b:
    # block 0x0051e08b: entry, 21 instruction(s), calls FUN_0051a7c3, FUN_0050f920, ends with ret 0x8
    push esi                                     # 0051e08b
    push edi                                     # 0051e08c
    {load} mov esi, ecx                          # 0051e08d
    call FUN_0051a7c3                            # 0051e08f
    lea edi, [esi + field_3c]                    # 0051e094
    push 0x20                                    # 0051e097
    push 0x0                                     # 0051e099
    push edi                                     # 0051e09b
    mov dword ptr [esi], 0x52f29c                # 0051e09c
    call FUN_0050f920                            # 0051e0a2
    mov eax, dword ptr [esp + stk_1c]            # 0051e0a7
    add esp, 0xc                                 # 0051e0ab
    mov dword ptr [esi + field_50], eax          # 0051e0ae
    mov eax, dword ptr [esp + stk_c]             # 0051e0b1
    movzx ecx, ax                                # 0051e0b5
    mov dword ptr [edi], eax                     # 0051e0b8
    mov dword ptr [esi + field_40], ecx          # 0051e0ba
    {load} mov eax, esi                          # 0051e0bd
    pop edi                                      # 0051e0bf
    pop esi                                      # 0051e0c0
    ret 0x8                                      # 0051e0c1

