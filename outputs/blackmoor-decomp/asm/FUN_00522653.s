# FUN_00522653
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522653
# extent:       0x00522653-0x005226c4 (113 code bytes)
# span:         0x00522653-0x005226c4 (code 113, tables 0, padding 0)
# sha256:       6d4686e99faa19ac75a702e6d8bc84dcb995cec2b917ddede51c521c08f14ad6
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522653
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c
# callees:      calls FUN_0051bfc3, USER32.dll!SendMessageA, USER32.dll!GetWindowLongA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005226c4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0051bfc3, .text + (0x0051bfc3 - 0x401000)

.org 0x00522653 - 0x401000
.globl FUN_00522653
FUN_00522653:
    # block 0x00522653: entry, 13 instruction(s), calls FUN_0051bfc3, ends with je to 0x00522672 (forward)
    push ebp                                     # 00522653
    {load} mov ebp, esp                          # 00522654
    push ecx                                     # 00522656
    push ebx                                     # 00522657
    mov ebx, dword ptr [ebp + arg_c]             # 00522658
    push esi                                     # 0052265b
    mov esi, dword ptr [ebp + arg_8]             # 0052265c
    push ebx                                     # 0052265f
    push esi                                     # 00522660
    mov dword ptr [ebp - local_4], ecx           # 00522661
    call FUN_0051bfc3                            # 00522664
    test eax, eax                                # 00522669
    je.d8 L_00522672                             # 0052266b
    # block 0x0052266d: entered by fall-through of je at 0x0052266b, 3 instruction(s), ends with forward jump to 0x005226be
    push 0x1                                     # 0052266d
    pop eax                                      # 0052266f
    jmp.d8 L_005226be                            # 00522670
L_00522672:
    # block 0x00522672: entered by je at 0x0052266b, 4 instruction(s), ends with je to 0x005226bb (forward)
    push edi                                     # 00522672
    test ebx, ebx                                # 00522673
    movzx edi, si                                # 00522675
    je.d8 L_005226bb                             # 00522678
    # block 0x0052267a: entered by fall-through of je at 0x00522678, 3 instruction(s), ends with jne to 0x005226bb (forward)
    shr esi, 0x10                                # 0052267a
    test si, si                                  # 0052267d
    jne.d8 L_005226bb                            # 00522680
    # block 0x00522682: entered by fall-through of jne at 0x00522680, 7 instruction(s), calls USER32.dll!SendMessageA, ends with je to 0x005226bb (forward)
    push 0x0                                     # 00522682
    push 0x0                                     # 00522684
    push 0x87                                    # 00522686
    push ebx                                     # 0052268b
    call dword ptr [0x52a4c8]                    # 0052268c
    test ax, 0x2010                              # 00522692
    je.d8 L_005226bb                             # 00522696
    # block 0x00522698: entered by fall-through of je at 0x00522696, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x005226b5 (forward)
    push -0x10                                   # 00522698
    push ebx                                     # 0052269a
    call dword ptr [0x52a454]                    # 0052269b
    and eax, 0xf                                 # 005226a1
    je.d8 L_005226b5                             # 005226a4
    # block 0x005226a6: entered by fall-through of je at 0x005226a4, 2 instruction(s), ends with je to 0x005226b5 (forward)
    cmp eax, 0x1                                 # 005226a6
    je.d8 L_005226b5                             # 005226a9
    # block 0x005226ab: entered by fall-through of je at 0x005226a9, 2 instruction(s), ends with je to 0x005226b5 (forward)
    cmp eax, 0x8                                 # 005226ab
    je.d8 L_005226b5                             # 005226ae
    # block 0x005226b0: entered by fall-through of je at 0x005226ae, 2 instruction(s), ends with jne to 0x005226bb (forward)
    cmp eax, 0xb                                 # 005226b0
    jne.d8 L_005226bb                            # 005226b3
L_005226b5:
    # block 0x005226b5: entered by je at 0x005226a4; je at 0x005226a9; je at 0x005226ae; fall-through of jne at 0x005226b3, 2 instruction(s), falls into the block at 0x005226bb
    mov eax, dword ptr [ebp - local_4]           # 005226b5
    mov dword ptr [eax + field_2c], edi          # 005226b8
L_005226bb:
    # block 0x005226bb: entered by je at 0x00522678; jne at 0x00522680; je at 0x00522696; jne at 0x005226b3, 2 instruction(s), falls into the block at 0x005226be
    {load} xor eax, eax                          # 005226bb
    pop edi                                      # 005226bd
L_005226be:
    # block 0x005226be: entered by jmp at 0x00522670, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 005226be
    pop ebx                                      # 005226bf
    leave                                        # 005226c0
    ret 0x8                                      # 005226c1

