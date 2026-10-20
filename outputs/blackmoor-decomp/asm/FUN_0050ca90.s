# FUN_0050ca90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ca90
# extent:       0x0050ca90-0x0050cb1b (139 code bytes)
# span:         0x0050ca90-0x0050cb1b (code 139, tables 0, padding 0)
# sha256:       17e48db1ba16bebfd13d82208bc0e6278361248123cde90844002c26c0204e9a
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ca90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_minus_30; [esp + n] stk_14
# callees:      calls FUN_005118b3
# track-n:      outputs/blackmoor-decomp/src/autotext.c:parse_decimal_prefix (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 59 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_30, 0x30  # offset -0x30
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)

.org 0x0050ca90 - 0x401000
.globl FUN_0050ca90
FUN_0050ca90:
    # block 0x0050ca90: entry, 5 instruction(s), falls into the block at 0x0050ca98
    push ebx                                     # 0050ca90
    push ebp                                     # 0050ca91
    push esi                                     # 0050ca92
    push edi                                     # 0050ca93
    mov edi, dword ptr [esp + stk_14]            # 0050ca94
L_0050ca98:
    # block 0x0050ca98: entered by jmp at 0x0050cac4, 2 instruction(s), ends with jle to 0x0050cab0 (forward)
    cmp dword ptr [0x56840c], 0x1                # 0050ca98
    jle.d8 L_0050cab0                            # 0050ca9f
    # block 0x0050caa1: entered by fall-through of jle at 0x0050ca9f, 7 instruction(s), calls FUN_005118b3, ends with forward jump to 0x0050cabf
    movzx eax, byte ptr [edi]                    # 0050caa1
    push 0x8                                     # 0050caa4
    push eax                                     # 0050caa6
    call FUN_005118b3                            # 0050caa7
    pop ecx                                      # 0050caac
    pop ecx                                      # 0050caad
    jmp.d8 L_0050cabf                            # 0050caae
L_0050cab0:
    # block 0x0050cab0: entered by jle at 0x0050ca9f, 4 instruction(s), falls into the block at 0x0050cabf
    movzx eax, byte ptr [edi]                    # 0050cab0
    mov ecx, dword ptr [0x568200]                # 0050cab3
    mov al, byte ptr [ecx + 2*eax]               # 0050cab9
    and eax, 0x8                                 # 0050cabc
L_0050cabf:
    # block 0x0050cabf: entered by jmp at 0x0050caae, 2 instruction(s), ends with je to 0x0050cac6 (forward)
    test eax, eax                                # 0050cabf
    je.d8 L_0050cac6                             # 0050cac1
    # block 0x0050cac3: entered by fall-through of je at 0x0050cac1, 2 instruction(s), ends with backward jump to 0x0050ca98
    inc edi                                      # 0050cac3
    jmp.d8 L_0050ca98                            # 0050cac4
L_0050cac6:
    # block 0x0050cac6: entered by je at 0x0050cac1, 5 instruction(s), ends with je to 0x0050cad6 (forward)
    movzx esi, byte ptr [edi]                    # 0050cac6
    inc edi                                      # 0050cac9
    cmp esi, 0x2d                                # 0050caca
    {load} mov ebp, esi                          # 0050cacd
    je.d8 L_0050cad6                             # 0050cacf
    # block 0x0050cad1: entered by fall-through of je at 0x0050cacf, 2 instruction(s), ends with jne to 0x0050cada (forward)
    cmp esi, 0x2b                                # 0050cad1
    jne.d8 L_0050cada                            # 0050cad4
L_0050cad6:
    # block 0x0050cad6: entered by je at 0x0050cacf; fall-through of jne at 0x0050cad4, 2 instruction(s), falls into the block at 0x0050cada
    movzx esi, byte ptr [edi]                    # 0050cad6
    inc edi                                      # 0050cad9
L_0050cada:
    # block 0x0050cada: entered by jne at 0x0050cad4, 1 instruction(s), falls into the block at 0x0050cadc
    {load} xor ebx, ebx                          # 0050cada
L_0050cadc:
    # block 0x0050cadc: entered by jmp at 0x0050cb0b, 2 instruction(s), ends with jle to 0x0050caf1 (forward)
    cmp dword ptr [0x56840c], 0x1                # 0050cadc
    jle.d8 L_0050caf1                            # 0050cae3
    # block 0x0050cae5: entered by fall-through of jle at 0x0050cae3, 6 instruction(s), calls FUN_005118b3, ends with forward jump to 0x0050cafc
    push 0x4                                     # 0050cae5
    push esi                                     # 0050cae7
    call FUN_005118b3                            # 0050cae8
    pop ecx                                      # 0050caed
    pop ecx                                      # 0050caee
    jmp.d8 L_0050cafc                            # 0050caef
L_0050caf1:
    # block 0x0050caf1: entered by jle at 0x0050cae3, 3 instruction(s), falls into the block at 0x0050cafc
    mov eax, dword ptr [0x568200]                # 0050caf1
    mov al, byte ptr [eax + 2*esi]               # 0050caf6
    and eax, 0x4                                 # 0050caf9
L_0050cafc:
    # block 0x0050cafc: entered by jmp at 0x0050caef, 2 instruction(s), ends with je to 0x0050cb0d (forward)
    test eax, eax                                # 0050cafc
    je.d8 L_0050cb0d                             # 0050cafe
    # block 0x0050cb00: entered by fall-through of je at 0x0050cafe, 5 instruction(s), ends with backward jump to 0x0050cadc
    lea eax, [ebx + 4*ebx]                       # 0050cb00
    lea ebx, [esi + 2*eax - field_minus_30]      # 0050cb03
    movzx esi, byte ptr [edi]                    # 0050cb07
    inc edi                                      # 0050cb0a
    jmp.d8 L_0050cadc                            # 0050cb0b
L_0050cb0d:
    # block 0x0050cb0d: entered by je at 0x0050cafe, 3 instruction(s), ends with jne to 0x0050cb16 (forward)
    cmp ebp, 0x2d                                # 0050cb0d
    {load} mov eax, ebx                          # 0050cb10
    jne.d8 L_0050cb16                            # 0050cb12
    # block 0x0050cb14: entered by fall-through of jne at 0x0050cb12, 1 instruction(s), falls into the block at 0x0050cb16
    neg eax                                      # 0050cb14
L_0050cb16:
    # block 0x0050cb16: entered by jne at 0x0050cb12, 5 instruction(s), ends with ret
    pop edi                                      # 0050cb16
    pop esi                                      # 0050cb17
    pop ebp                                      # 0050cb18
    pop ebx                                      # 0050cb19
    ret                                          # 0050cb1a

