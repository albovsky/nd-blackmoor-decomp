# FUN_00524655
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524655
# extent:       0x00524655-0x005246cf (122 code bytes)
# span:         0x00524655-0x005246cf (code 122, tables 0, padding 0)
# sha256:       30fc88ec6b4483bbd9ddbc14602045b80f0fa142dfa048d08d8a8ed2f70fc8a8
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524655
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_58
# callees:      calls USER32.dll!SetRectEmpty, USER32.dll!EqualRect, USER32.dll!CopyRect, FUN_0051c2ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_0051c2ab, .text + (0x0051c2ab - 0x401000)

.org 0x00524655 - 0x401000
.globl FUN_00524655
FUN_00524655:
    # block 0x00524655: entry, 6 instruction(s), ends with je to 0x005246ad (forward)
    push ebp                                     # 00524655
    {load} mov ebp, esp                          # 00524656
    mov eax, dword ptr [ebp + arg_8]             # 00524658
    push esi                                     # 0052465b
    dec eax                                      # 0052465c
    je.d8 L_005246ad                             # 0052465d
    # block 0x0052465f: entered by fall-through of je at 0x0052465d, 2 instruction(s), ends with je to 0x005246c7 (forward)
    dec eax                                      # 0052465f
    je.d8 L_005246c7                             # 00524660
    # block 0x00524662: entered by fall-through of je at 0x00524660, 2 instruction(s), ends with jne to 0x005246c7 (forward)
    dec eax                                      # 00524662
    jne.d8 L_005246c7                            # 00524663
    # block 0x00524665: entered by fall-through of jne at 0x00524663, 3 instruction(s), ends with jne to 0x0052468c (forward)
    {load} xor edx, edx                          # 00524665
    cmp dword ptr [ebp + arg_c], edx             # 00524667
    jne.d8 L_0052468c                            # 0052466a
    # block 0x0052466c: entered by fall-through of jne at 0x0052466a, 3 instruction(s), ends with jne to 0x00524683 (forward)
    cmp dword ptr [ecx + field_58], edx          # 0052466c
    lea eax, [ecx + field_58]                    # 0052466f
    jne.d8 L_00524683                            # 00524672
    # block 0x00524674: entered by fall-through of jne at 0x00524672, 2 instruction(s), ends with jne to 0x00524683 (forward)
    cmp dword ptr [eax + field_8], edx           # 00524674
    jne.d8 L_00524683                            # 00524677
    # block 0x00524679: entered by fall-through of jne at 0x00524677, 2 instruction(s), ends with jne to 0x00524683 (forward)
    cmp dword ptr [eax + field_4], edx           # 00524679
    jne.d8 L_00524683                            # 0052467c
    # block 0x0052467e: entered by fall-through of jne at 0x0052467c, 2 instruction(s), ends with je to 0x005246a9 (forward)
    cmp dword ptr [eax + field_c], edx           # 0052467e
    je.d8 L_005246a9                             # 00524681
L_00524683:
    # block 0x00524683: entered by jne at 0x00524672; jne at 0x00524677; jne at 0x0052467c; fall-through of je at 0x00524681, 3 instruction(s), calls USER32.dll!SetRectEmpty, ends with forward jump to 0x005246c7
    push eax                                     # 00524683
    call dword ptr [0x52a374]                    # 00524684
    jmp.d8 L_005246c7                            # 0052468a
L_0052468c:
    # block 0x0052468c: entered by jne at 0x0052466a, 6 instruction(s), calls USER32.dll!EqualRect, ends with jne to 0x005246a9 (forward)
    push dword ptr [ebp + arg_c]                 # 0052468c
    lea esi, [ecx + field_58]                    # 0052468f
    push esi                                     # 00524692
    call dword ptr [0x52a4b0]                    # 00524693
    test eax, eax                                # 00524699
    jne.d8 L_005246a9                            # 0052469b
    # block 0x0052469d: entered by fall-through of jne at 0x0052469b, 4 instruction(s), calls USER32.dll!CopyRect, ends with forward jump to 0x005246c7
    push dword ptr [ebp + arg_c]                 # 0052469d
    push esi                                     # 005246a0
    call dword ptr [0x52a4ac]                    # 005246a1
    jmp.d8 L_005246c7                            # 005246a7
L_005246a9:
    # block 0x005246a9: entered by je at 0x00524681; jne at 0x0052469b, 2 instruction(s), ends with forward jump to 0x005246ca
    {load} xor eax, eax                          # 005246a9
    jmp.d8 L_005246ca                            # 005246ab
L_005246ad:
    # block 0x005246ad: entered by je at 0x0052465d, 9 instruction(s), calls FUN_0051c2ab, falls into the block at 0x005246c7
    {load} xor edx, edx                          # 005246ad
    push 0x1                                     # 005246af
    push edx                                     # 005246b1
    push dword ptr [ebp + arg_c]                 # 005246b2
    push 0x1                                     # 005246b5
    push 0xe900                                  # 005246b7
    push 0xffff                                  # 005246bc
    push edx                                     # 005246c1
    call FUN_0051c2ab                            # 005246c2
L_005246c7:
    # block 0x005246c7: entered by je at 0x00524660; jne at 0x00524663; jmp at 0x0052468a; jmp at 0x005246a7, 2 instruction(s), falls into the block at 0x005246ca
    push 0x1                                     # 005246c7
    pop eax                                      # 005246c9
L_005246ca:
    # block 0x005246ca: entered by jmp at 0x005246ab, 3 instruction(s), ends with ret 0x8
    pop esi                                      # 005246ca
    pop ebp                                      # 005246cb
    ret 0x8                                      # 005246cc

