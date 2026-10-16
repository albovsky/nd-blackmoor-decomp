# FUN_0051b257
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b257
# extent:       0x0051b257-0x0051b2d3 (124 code bytes)
# span:         0x0051b257-0x0051b2d3 (code 124, tables 0, padding 0)
# sha256:       0a3ce616fb29295f41844870ab7c63f62bfe1b5077640817bdf78ac8e85070af
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b257
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_24; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_1c, field_34, field_38
# callees:      calls FUN_0050f978, FUN_0051b414, FUN_0051d730; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051b414, .text + (0x0051b414 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0051b257 - 0x401000
.globl FUN_0051b257
FUN_0051b257:
    # block 0x0051b257: entry, 10 instruction(s), calls FUN_0050f978, ends with je to 0x0051b29d (forward)
    mov eax, 0x528b74                            # 0051b257
    call FUN_0050f978                            # 0051b25c
    push ecx                                     # 0051b261
    push esi                                     # 0051b262
    {load} mov esi, ecx                          # 0051b263
    mov dword ptr [ebp - field_minus_10], esi    # 0051b265
    mov dword ptr [esi], 0x52ea60                # 0051b268
    and dword ptr [ebp - field_minus_4], 0x0     # 0051b26e
    cmp dword ptr [esi + field_1c], 0x0          # 0051b272
    je.d8 L_0051b29d                             # 0051b276
    # block 0x0051b278: entered by fall-through of je at 0x0051b276, 2 instruction(s), ends with je to 0x0051b29d (forward)
    cmp esi, 0x63c318                            # 0051b278
    je.d8 L_0051b29d                             # 0051b27e
    # block 0x0051b280: entered by fall-through of je at 0x0051b27e, 2 instruction(s), ends with je to 0x0051b29d (forward)
    cmp esi, 0x63c2d8                            # 0051b280
    je.d8 L_0051b29d                             # 0051b286
    # block 0x0051b288: entered by fall-through of je at 0x0051b286, 2 instruction(s), ends with je to 0x0051b29d (forward)
    cmp esi, 0x63c298                            # 0051b288
    je.d8 L_0051b29d                             # 0051b28e
    # block 0x0051b290: entered by fall-through of je at 0x0051b28e, 2 instruction(s), ends with je to 0x0051b29d (forward)
    cmp esi, 0x63c258                            # 0051b290
    je.d8 L_0051b29d                             # 0051b296
    # block 0x0051b298: entered by fall-through of je at 0x0051b296, 1 instruction(s), calls FUN_0051b414, falls into the block at 0x0051b29d
    call FUN_0051b414                            # 0051b298
L_0051b29d:
    # block 0x0051b29d: entered by je at 0x0051b276; je at 0x0051b27e; je at 0x0051b286; je at 0x0051b28e; je at 0x0051b296, 3 instruction(s), ends with je to 0x0051b2ab (forward)
    mov ecx, dword ptr [esi + field_34]          # 0051b29d
    test ecx, ecx                                # 0051b2a0
    je.d8 L_0051b2ab                             # 0051b2a2
    # block 0x0051b2a4: entered by fall-through of je at 0x0051b2a2, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051b2ab
    mov eax, dword ptr [ecx]                     # 0051b2a4
    push 0x1                                     # 0051b2a6
    call dword ptr [eax + field_4]               # 0051b2a8
L_0051b2ab:
    # block 0x0051b2ab: entered by je at 0x0051b2a2, 3 instruction(s), ends with je to 0x0051b2bb (forward)
    mov eax, dword ptr [esi + field_38]          # 0051b2ab
    test eax, eax                                # 0051b2ae
    je.d8 L_0051b2bb                             # 0051b2b0
    # block 0x0051b2b2: entered by fall-through of je at 0x0051b2b0, 2 instruction(s), ends with jne to 0x0051b2bb (forward)
    cmp dword ptr [eax + field_24], esi          # 0051b2b2
    jne.d8 L_0051b2bb                            # 0051b2b5
    # block 0x0051b2b7: entered by fall-through of jne at 0x0051b2b5, 1 instruction(s), falls into the block at 0x0051b2bb
    and dword ptr [eax + field_24], 0x0          # 0051b2b7
L_0051b2bb:
    # block 0x0051b2bb: entered by je at 0x0051b2b0; jne at 0x0051b2b5, 8 instruction(s), calls FUN_0051d730, ends with ret
    or dword ptr [ebp - field_minus_4], -0x1     # 0051b2bb
    {load} mov ecx, esi                          # 0051b2bf
    call FUN_0051d730                            # 0051b2c1
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051b2c6
    pop esi                                      # 0051b2c9
    mov dword ptr fs:[0x0], ecx                  # 0051b2ca
    leave                                        # 0051b2d1
    ret                                          # 0051b2d2

