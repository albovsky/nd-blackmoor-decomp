# FUN_00520a5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520a5c
# extent:       0x00520a5c-0x00520ace (114 code bytes)
# span:         0x00520a5c-0x00520ace (code 114, tables 0, padding 0)
# sha256:       a61943ba4824dce4e91e5262c0fb52637909c63d71ed7ac8903b69ade3006aaa
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520a5c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c; [esi + n] field_1c
# callees:      calls FUN_0050f978, FUN_00525397, FUN_0051dc31, FUN_0051dc43, FUN_0051f7a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051f7a0, .text + (0x0051f7a0 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x00520a5c - 0x401000
.globl FUN_00520a5c
FUN_00520a5c:
    # block 0x00520a5c: entry, 7 instruction(s), calls FUN_0050f978, FUN_00525397, ends with jne to 0x00520abc (forward)
    mov eax, 0x529012                            # 00520a5c
    call FUN_0050f978                            # 00520a61
    push esi                                     # 00520a66
    call FUN_00525397                            # 00520a67
    {load} mov esi, eax                          # 00520a6c
    cmp dword ptr [esi + field_1c], 0x0          # 00520a6e
    jne.d8 L_00520abc                            # 00520a72
    # block 0x00520a74: entered by fall-through of jne at 0x00520a72, 2 instruction(s), ends with je to 0x00520abc (forward)
    cmp dword ptr [ebp + field_8], 0x0           # 00520a74
    je.d8 L_00520abc                             # 00520a78
    # block 0x00520a7a: entered by fall-through of je at 0x00520a78, 12 instruction(s), calls FUN_0051dc31, FUN_0051dc43, ends with je to 0x00520aac (forward)
    push ebx                                     # 00520a7a
    push 0x521235                                # 00520a7b
    call FUN_0051dc31                            # 00520a80
    push 0x48                                    # 00520a85
    {load} mov ebx, eax                          # 00520a87
    call FUN_0051dc43                            # 00520a89
    pop ecx                                      # 00520a8e
    {load} mov ecx, eax                          # 00520a8f
    mov dword ptr [ebp + field_8], ecx           # 00520a91
    and dword ptr [ebp - field_minus_4], 0x0     # 00520a94
    test ecx, ecx                                # 00520a98
    je.d8 L_00520aac                             # 00520a9a
    # block 0x00520a9c: entered by fall-through of je at 0x00520a9a, 5 instruction(s), calls FUN_0051f7a0, ends with forward jump to 0x00520aae
    push 0x2                                     # 00520a9c
    push 0x4                                     # 00520a9e
    push 0x52fbc0                                # 00520aa0
    call FUN_0051f7a0                            # 00520aa5
    jmp.d8 L_00520aae                            # 00520aaa
L_00520aac:
    # block 0x00520aac: entered by je at 0x00520a9a, 1 instruction(s), falls into the block at 0x00520aae
    {load} xor eax, eax                          # 00520aac
L_00520aae:
    # block 0x00520aae: entered by jmp at 0x00520aaa, 5 instruction(s), calls FUN_0051dc31, falls into the block at 0x00520abc
    or dword ptr [ebp - field_minus_4], -0x1     # 00520aae
    push ebx                                     # 00520ab2
    mov dword ptr [esi + field_1c], eax          # 00520ab3
    call FUN_0051dc31                            # 00520ab6
    pop ebx                                      # 00520abb
L_00520abc:
    # block 0x00520abc: entered by jne at 0x00520a72; je at 0x00520a78, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 00520abc
    mov eax, dword ptr [esi + field_1c]          # 00520abf
    pop esi                                      # 00520ac2
    mov dword ptr fs:[0x0], ecx                  # 00520ac3
    leave                                        # 00520aca
    ret 0x4                                      # 00520acb

