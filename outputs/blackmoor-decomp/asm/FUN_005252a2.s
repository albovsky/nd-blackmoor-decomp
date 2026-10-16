# FUN_005252a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005252a2
# extent:       0x005252a2-0x00525350 (174 code bytes)
# span:         0x005252a2-0x00525350 (code 174, tables 0, padding 0)
# sha256:       cbe9e5989355493cc73def2c2f51576b911e767888cef16eadb4f6fb33e4a37b
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005252a2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_c; [esi + n] field_14, field_18, field_1c, field_20, field_24, field_30, field_34, field_38
# callees:      calls FUN_0050f978, FUN_0051a3b0, FUN_0051dc6c; plus 8 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 76 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00525350
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a3b0, .text + (0x0051a3b0 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x005252a2 - 0x401000
.globl FUN_005252a2
FUN_005252a2:
    # block 0x005252a2: entry, 14 instruction(s), calls FUN_0050f978, ends with je to 0x005252cd (forward)
    mov eax, 0x528ffc                            # 005252a2
    call FUN_0050f978                            # 005252a7
    push ecx                                     # 005252ac
    push ebx                                     # 005252ad
    push esi                                     # 005252ae
    {load} mov esi, ecx                          # 005252af
    mov dword ptr [ebp - field_minus_10], esi    # 005252b1
    mov dword ptr [esi], 0x52fb8c                # 005252b4
    mov ecx, dword ptr [esi + field_14]          # 005252ba
    and dword ptr [ebp - field_minus_4], 0x0     # 005252bd
    push 0x1                                     # 005252c1
    test ecx, ecx                                # 005252c3
    pop ebx                                      # 005252c5
    je.d8 L_005252cd                             # 005252c6
    # block 0x005252c8: entered by fall-through of je at 0x005252c6, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005252cd
    mov eax, dword ptr [ecx]                     # 005252c8
    push ebx                                     # 005252ca
    call dword ptr [eax]                         # 005252cb
L_005252cd:
    # block 0x005252cd: entered by je at 0x005252c6, 3 instruction(s), ends with je to 0x005252d9 (forward)
    mov ecx, dword ptr [esi + field_18]          # 005252cd
    test ecx, ecx                                # 005252d0
    je.d8 L_005252d9                             # 005252d2
    # block 0x005252d4: entered by fall-through of je at 0x005252d2, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005252d9
    mov eax, dword ptr [ecx]                     # 005252d4
    push ebx                                     # 005252d6
    call dword ptr [eax]                         # 005252d7
L_005252d9:
    # block 0x005252d9: entered by je at 0x005252d2, 3 instruction(s), ends with je to 0x005252e5 (forward)
    mov ecx, dword ptr [esi + field_1c]          # 005252d9
    test ecx, ecx                                # 005252dc
    je.d8 L_005252e5                             # 005252de
    # block 0x005252e0: entered by fall-through of je at 0x005252de, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005252e5
    mov eax, dword ptr [ecx]                     # 005252e0
    push ebx                                     # 005252e2
    call dword ptr [eax]                         # 005252e3
L_005252e5:
    # block 0x005252e5: entered by je at 0x005252de, 3 instruction(s), ends with je to 0x005252f1 (forward)
    mov ecx, dword ptr [esi + field_20]          # 005252e5
    test ecx, ecx                                # 005252e8
    je.d8 L_005252f1                             # 005252ea
    # block 0x005252ec: entered by fall-through of je at 0x005252ea, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005252f1
    mov eax, dword ptr [ecx]                     # 005252ec
    push ebx                                     # 005252ee
    call dword ptr [eax]                         # 005252ef
L_005252f1:
    # block 0x005252f1: entered by je at 0x005252ea, 3 instruction(s), ends with je to 0x005252fd (forward)
    mov ecx, dword ptr [esi + field_24]          # 005252f1
    test ecx, ecx                                # 005252f4
    je.d8 L_005252fd                             # 005252f6
    # block 0x005252f8: entered by fall-through of je at 0x005252f6, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005252fd
    mov eax, dword ptr [ecx]                     # 005252f8
    push ebx                                     # 005252fa
    call dword ptr [eax]                         # 005252fb
L_005252fd:
    # block 0x005252fd: entered by je at 0x005252f6, 3 instruction(s), ends with je to 0x0052531b (forward)
    mov ecx, dword ptr [esi + field_38]          # 005252fd
    test ecx, ecx                                # 00525300
    je.d8 L_0052531b                             # 00525302
L_00525304:
    # block 0x00525304: entered by jmp at 0x00525319; fall-through of je at 0x00525302, 2 instruction(s), ends with je to 0x0052531b (forward)
    cmp dword ptr [ecx + field_c], 0x0           # 00525304
    je.d8 L_0052531b                             # 00525308
    # block 0x0052530a: entered by fall-through of je at 0x00525308, 6 instruction(s), calls FUN_0051a3b0, FUN_0051dc6c, ends with backward jump to 0x00525304
    call FUN_0051a3b0                            # 0052530a
    push eax                                     # 0052530f
    call FUN_0051dc6c                            # 00525310
    pop ecx                                      # 00525315
    mov ecx, dword ptr [esi + field_38]          # 00525316
    jmp.d8 L_00525304                            # 00525319
L_0052531b:
    # block 0x0052531b: entered by je at 0x00525302; je at 0x00525308, 3 instruction(s), ends with je to 0x00525328 (forward)
    mov ecx, dword ptr [esi + field_30]          # 0052531b
    test ecx, ecx                                # 0052531e
    je.d8 L_00525328                             # 00525320
    # block 0x00525322: entered by fall-through of je at 0x00525320, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00525328
    mov eax, dword ptr [ecx]                     # 00525322
    push ebx                                     # 00525324
    call dword ptr [eax + field_4]               # 00525325
L_00525328:
    # block 0x00525328: entered by je at 0x00525320, 3 instruction(s), ends with je to 0x00525335 (forward)
    mov ecx, dword ptr [esi + field_34]          # 00525328
    test ecx, ecx                                # 0052532b
    je.d8 L_00525335                             # 0052532d
    # block 0x0052532f: entered by fall-through of je at 0x0052532d, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00525335
    mov eax, dword ptr [ecx]                     # 0052532f
    push ebx                                     # 00525331
    call dword ptr [eax + field_4]               # 00525332
L_00525335:
    # block 0x00525335: entered by je at 0x0052532d, 3 instruction(s), ends with je to 0x00525342 (forward)
    mov ecx, dword ptr [esi + field_38]          # 00525335
    test ecx, ecx                                # 00525338
    je.d8 L_00525342                             # 0052533a
    # block 0x0052533c: entered by fall-through of je at 0x0052533a, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00525342
    mov eax, dword ptr [ecx]                     # 0052533c
    push ebx                                     # 0052533e
    call dword ptr [eax + field_4]               # 0052533f
L_00525342:
    # block 0x00525342: entered by je at 0x0052533a, 6 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525342
    pop esi                                      # 00525345
    pop ebx                                      # 00525346
    mov dword ptr fs:[0x0], ecx                  # 00525347
    leave                                        # 0052534e
    ret                                          # 0052534f

