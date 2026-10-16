# FUN_005118b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005118b3
# extent:       0x005118b3-0x00511928 (117 code bytes)
# span:         0x005118b3-0x00511928 (code 117, tables 0, padding 0)
# sha256:       a6e43ea119f9bed5d835577a8af3cbf2bd0c67692bb3dc4b9a7cde8030719b06
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005118b3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_a, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_2, local_3, local_4
# fields:       [eax + n] field_1; [esi + n] field_1
# callees:      calls FUN_00515e1e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 46 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00511928
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2
.equ local_3, 0x3  # offset -0x3
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00515e1e, .text + (0x00515e1e - 0x401000)

.org 0x005118b3 - 0x401000
.globl FUN_005118b3
FUN_005118b3:
    # block 0x005118b3: entry, 7 instruction(s), ends with ja to 0x005118d1 (forward)
    push ebp                                     # 005118b3
    {load} mov ebp, esp                          # 005118b4
    push ecx                                     # 005118b6
    mov eax, dword ptr [ebp + arg_8]             # 005118b7
    lea ecx, [eax + field_1]                     # 005118ba
    cmp ecx, 0x100                               # 005118bd
    ja.d8 L_005118d1                             # 005118c3
    # block 0x005118c5: entered by fall-through of ja at 0x005118c3, 3 instruction(s), ends with forward jump to 0x00511923
    mov ecx, dword ptr [0x568200]                # 005118c5
    movzx eax, word ptr [ecx + 2*eax]            # 005118cb
    jmp.d8 L_00511923                            # 005118cf
L_005118d1:
    # block 0x005118d1: entered by ja at 0x005118c3, 8 instruction(s), ends with je to 0x005118f6 (forward)
    {load} mov ecx, eax                          # 005118d1
    push esi                                     # 005118d3
    mov esi, dword ptr [0x568200]                # 005118d4
    sar ecx, 0x8                                 # 005118da
    movzx edx, cl                                # 005118dd
    test byte ptr [esi + 2*edx + field_1], -0x80 # 005118e0
    pop esi                                      # 005118e5
    je.d8 L_005118f6                             # 005118e6
    # block 0x005118e8: entered by fall-through of je at 0x005118e6, 5 instruction(s), ends with forward jump to 0x005118ff
    and byte ptr [ebp - local_2], 0x0            # 005118e8
    mov byte ptr [ebp - local_4], cl             # 005118ec
    mov byte ptr [ebp - local_3], al             # 005118ef
    push 0x2                                     # 005118f2
    jmp.d8 L_005118ff                            # 005118f4
L_005118f6:
    # block 0x005118f6: entered by je at 0x005118e6, 3 instruction(s), falls into the block at 0x005118ff
    and byte ptr [ebp - local_3], 0x0            # 005118f6
    mov byte ptr [ebp - local_4], al             # 005118fa
    push 0x1                                     # 005118fd
L_005118ff:
    # block 0x005118ff: entered by jmp at 0x005118f4, 14 instruction(s), calls FUN_00515e1e, ends with jne to 0x0051191f (forward)
    pop eax                                      # 005118ff
    lea ecx, [ebp + arg_a]                       # 00511900
    push 0x1                                     # 00511903
    push 0x0                                     # 00511905
    push 0x0                                     # 00511907
    push ecx                                     # 00511909
    push eax                                     # 0051190a
    lea eax, [ebp - local_4]                     # 0051190b
    push eax                                     # 0051190e
    push 0x1                                     # 0051190f
    call FUN_00515e1e                            # 00511911
    add esp, 0x1c                                # 00511916
    test eax, eax                                # 00511919
    jne.d8 L_0051191f                            # 0051191b
    # block 0x0051191d: entered by fall-through of jne at 0x0051191b, 2 instruction(s), ends with ret
    leave                                        # 0051191d
    ret                                          # 0051191e
L_0051191f:
    # block 0x0051191f: entered by jne at 0x0051191b, 1 instruction(s), falls into the block at 0x00511923
    movzx eax, word ptr [ebp + arg_a]            # 0051191f
L_00511923:
    # block 0x00511923: entered by jmp at 0x005118cf, 3 instruction(s), ends with ret
    and eax, dword ptr [ebp + arg_c]             # 00511923
    leave                                        # 00511926
    ret                                          # 00511927

