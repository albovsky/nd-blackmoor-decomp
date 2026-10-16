# FUN_0041a140
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a140
# extent:       0x0041a140-0x0041a19c (92 code bytes)
# span:         0x0041a140-0x0041a19c (code 92, tables 0, padding 0)
# sha256:       7cd759718e6760d8e3c8a33444a9ed6caa71693e40bb9118c75d6c3a68b1c0cf
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041a140
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0a9, FUN_0050ce2b, FUN_0050d337, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d337, .text + (0x0050d337 - 0x401000)

.org 0x0041a140 - 0x401000
.globl FUN_0041a140
FUN_0041a140:
    # block 0x0041a140: entry, 12 instruction(s), calls FUN_0050d0a9, ends with jne to 0x0041a168 (forward)
    push ebp                                     # 0041a140
    {load} mov ebp, esp                          # 0041a141
    sub esp, 0xc                                 # 0041a143
    mov dword ptr [ebp - local_c], ecx           # 0041a146
    push 0x54314c                                # 0041a149
    mov eax, dword ptr [ebp + arg_8]             # 0041a14e
    push eax                                     # 0041a151
    call FUN_0050d0a9                            # 0041a152
    add esp, 0x8                                 # 0041a157
    mov dword ptr [ebp - local_8], eax           # 0041a15a
    cmp dword ptr [ebp - local_8], 0x0           # 0041a15d
    jne.d8 L_0041a168                            # 0041a161
    # block 0x0041a163: entered by fall-through of jne at 0x0041a161, 2 instruction(s), ends with forward jump to 0x0041a196
    or eax, -0x1                                 # 0041a163
    jmp.d8 L_0041a196                            # 0041a166
L_0041a168:
    # block 0x0041a168: entered by jne at 0x0041a161, 16 instruction(s), calls FUN_0050ce2b, FUN_0050d337, FUN_0050cee4, falls into the block at 0x0041a196
    push 0x2                                     # 0041a168
    push 0x0                                     # 0041a16a
    mov ecx, dword ptr [ebp - local_8]           # 0041a16c
    push ecx                                     # 0041a16f
    call FUN_0050ce2b                            # 0041a170
    add esp, 0xc                                 # 0041a175
    mov edx, dword ptr [ebp - local_8]           # 0041a178
    push edx                                     # 0041a17b
    call FUN_0050d337                            # 0041a17c
    add esp, 0x4                                 # 0041a181
    mov dword ptr [ebp - local_4], eax           # 0041a184
    mov eax, dword ptr [ebp - local_8]           # 0041a187
    push eax                                     # 0041a18a
    call FUN_0050cee4                            # 0041a18b
    add esp, 0x4                                 # 0041a190
    mov eax, dword ptr [ebp - local_4]           # 0041a193
L_0041a196:
    # block 0x0041a196: entered by jmp at 0x0041a166, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041a196
    pop ebp                                      # 0041a198
    ret 0x4                                      # 0041a199

