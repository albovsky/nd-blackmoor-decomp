# FUN_004c88c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c88c7
# extent:       0x004c88c7-0x004c8e3a (1395 code bytes)
# span:         0x004c88c7-0x004c924d (code 1395, tables 1043, padding 0)
# sha256:       9de0bd0ff5731acabfe9b1a1c1bb68db6a37818e8f3acd24e312ff4dd3b1306f
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c88c7
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 290 instruction(s), 19 conditional branch(es) and 8 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004c88c7 - 0x401000
.globl FUN_004c88c7
FUN_004c88c7:
    # block 0x004c88c7: entry, 8 instruction(s), ends with jg to 0x004c8a16 (forward)
    push ebp                                     # 004c88c7
    {load} mov ebp, esp                          # 004c88c8
    sub esp, 0x8                                 # 004c88ca
    mov dword ptr [ebp - local_4], ecx           # 004c88cd
    mov eax, dword ptr [ebp + arg_8]             # 004c88d0
    mov dword ptr [ebp - local_8], eax           # 004c88d3
    cmp dword ptr [ebp - local_8], 0x887601b8    # 004c88d6
    jg.d32 L_004c8a16                            # 004c88dd
    # block 0x004c88e3: entered by fall-through of jg at 0x004c88dd, 2 instruction(s), ends with je to 0x004c8c3f (forward)
    cmp dword ptr [ebp - local_8], 0x887601b8    # 004c88e3
    je.d32 L_004c8c3f                            # 004c88ea
    # block 0x004c88f0: entered by fall-through of je at 0x004c88ea, 2 instruction(s), ends with jg to 0x004c89eb (forward)
    cmp dword ptr [ebp - local_8], 0x887600de    # 004c88f0
    jg.d32 L_004c89eb                            # 004c88f7
    # block 0x004c88fd: entered by fall-through of jg at 0x004c88f7, 2 instruction(s), ends with je to 0x004c8b27 (forward)
    cmp dword ptr [ebp - local_8], 0x887600de    # 004c88fd
    je.d32 L_004c8b27                            # 004c8904
    # block 0x004c890a: entered by fall-through of je at 0x004c8904, 2 instruction(s), ends with jg to 0x004c89c3 (forward)
    cmp dword ptr [ebp - local_8], 0x8876006e    # 004c890a
    jg.d32 L_004c89c3                            # 004c8911
    # block 0x004c8917: entered by fall-through of jg at 0x004c8911, 2 instruction(s), ends with je to 0x004c8a9b (forward)
    cmp dword ptr [ebp - local_8], 0x8876006e    # 004c8917
    je.d32 L_004c8a9b                            # 004c891e
    # block 0x004c8924: entered by fall-through of je at 0x004c891e, 2 instruction(s), ends with jg to 0x004c899b (forward)
    cmp dword ptr [ebp - local_8], 0x8876000a    # 004c8924
    jg.d8 L_004c899b                             # 004c892b
    # block 0x004c892d: entered by fall-through of jg at 0x004c892b, 2 instruction(s), ends with je to 0x004c8a4b (forward)
    cmp dword ptr [ebp - local_8], 0x8876000a    # 004c892d
    je.d32 L_004c8a4b                            # 004c8934
    # block 0x004c893a: entered by fall-through of je at 0x004c8934, 2 instruction(s), ends with jg to 0x004c897c (forward)
    cmp dword ptr [ebp - local_8], 0x8007000e    # 004c893a
    jg.d8 L_004c897c                             # 004c8941
    # block 0x004c8943: entered by fall-through of jg at 0x004c8941, 2 instruction(s), ends with je to 0x004c8bdb (forward)
    cmp dword ptr [ebp - local_8], 0x8007000e    # 004c8943
    je.d32 L_004c8bdb                            # 004c894a
    # block 0x004c8950: entered by fall-through of je at 0x004c894a, 2 instruction(s), ends with je to 0x004c8c7b (forward)
    cmp dword ptr [ebp - local_8], 0x80004001    # 004c8950
    je.d32 L_004c8c7b                            # 004c8957
    # block 0x004c895d: entered by fall-through of je at 0x004c8957, 2 instruction(s), ends with je to 0x004c8a73 (forward)
    cmp dword ptr [ebp - local_8], 0x80004005    # 004c895d
    je.d32 L_004c8a73                            # 004c8964
    # block 0x004c896a: entered by fall-through of je at 0x004c8964, 2 instruction(s), ends with je to 0x004c8e28 (forward)
    cmp dword ptr [ebp - local_8], 0x800401f0    # 004c896a
    je.d32 L_004c8e28                            # 004c8971
    # block 0x004c8977: entered by fall-through of je at 0x004c8971, 1 instruction(s), ends with forward jump to 0x004c8e2f
    jmp.d32 L_004c8e2f                           # 004c8977
L_004c897c:
    # block 0x004c897c: entered by jg at 0x004c8941, 2 instruction(s), ends with je to 0x004c8ab9 (forward)
    cmp dword ptr [ebp - local_8], 0x80070057    # 004c897c
    je.d32 L_004c8ab9                            # 004c8983
    # block 0x004c8989: entered by fall-through of je at 0x004c8983, 2 instruction(s), ends with je to 0x004c8a41 (forward)
    cmp dword ptr [ebp - local_8], 0x88760005    # 004c8989
    je.d32 L_004c8a41                            # 004c8990
    # block 0x004c8996: entered by fall-through of je at 0x004c8990, 1 instruction(s), ends with forward jump to 0x004c8e2f
    jmp.d32 L_004c8e2f                           # 004c8996
L_004c899b:
    # block 0x004c899b: entered by jg at 0x004c892b, 5 instruction(s), ends with ja to 0x004c8e2f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c899b
    add ecx, 0x7789ffec                          # 004c899e
    mov dword ptr [ebp - local_8], ecx           # 004c89a4
    cmp dword ptr [ebp - local_8], 0x50          # 004c89a7
    ja.d32 L_004c8e2f                            # 004c89ab
    # block 0x004c89b1: entered by fall-through of ja at 0x004c89ab, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4c8e3a]
    mov eax, dword ptr [ebp - local_8]           # 004c89b1
    {load} xor edx, edx                          # 004c89b4
    mov dl, byte ptr [eax + IDXTAB_004c8e56_VA]  # 004c89b6
    jmp dword ptr [4*edx + SWTAB_004c8e3a_VA]    # 004c89bc
L_004c89c3:
    # block 0x004c89c3: entered by jg at 0x004c8911, 5 instruction(s), ends with ja to 0x004c8e2f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c89c3
    add ecx, 0x7789ff88                          # 004c89c6
    mov dword ptr [ebp - local_8], ecx           # 004c89cc
    cmp dword ptr [ebp - local_8], 0x64          # 004c89cf
    ja.d32 L_004c8e2f                            # 004c89d3
    # block 0x004c89d9: entered by fall-through of ja at 0x004c89d3, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4c8ea7]
    mov eax, dword ptr [ebp - local_8]           # 004c89d9
    {load} xor edx, edx                          # 004c89dc
    mov dl, byte ptr [eax + IDXTAB_004c8edb_VA]  # 004c89de
    jmp dword ptr [4*edx + SWTAB_004c8ea7_VA]    # 004c89e4
L_004c89eb:
    # block 0x004c89eb: entered by jg at 0x004c88f7, 5 instruction(s), ends with ja to 0x004c8e2f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c89eb
    add ecx, 0x7789ff1f                          # 004c89ee
    mov dword ptr [ebp - local_8], ecx           # 004c89f4
    cmp dword ptr [ebp - local_8], 0xd2          # 004c89f7
    ja.d32 L_004c8e2f                            # 004c89fe
    # block 0x004c8a04: entered by fall-through of ja at 0x004c89fe, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4c8f40]
    mov eax, dword ptr [ebp - local_8]           # 004c8a04
    {load} xor edx, edx                          # 004c8a07
    mov dl, byte ptr [eax + IDXTAB_004c8fac_VA]  # 004c8a09
    jmp dword ptr [4*edx + SWTAB_004c8f40_VA]    # 004c8a0f
L_004c8a16:
    # block 0x004c8a16: entered by jg at 0x004c88dd, 5 instruction(s), ends with ja to 0x004c8e2f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c8a16
    add ecx, 0x7789fe3e                          # 004c8a19
    mov dword ptr [ebp - local_8], ecx           # 004c8a1f
    cmp dword ptr [ebp - local_8], 0xf9          # 004c8a22
    ja.d32 L_004c8e2f                            # 004c8a29
    # block 0x004c8a2f: entered by fall-through of ja at 0x004c8a29, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4c907f]
    mov eax, dword ptr [ebp - local_8]           # 004c8a2f
    {load} xor edx, edx                          # 004c8a32
    mov dl, byte ptr [eax + IDXTAB_004c9153_VA]  # 004c8a34
    jmp dword ptr [4*edx + SWTAB_004c907f_VA]    # 004c8a3a
L_004c8a41:
    # block 0x004c8a41: entered by je at 0x004c8990, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55544c                            # 004c8a41
    jmp.d32 L_004c8e34                           # 004c8a46
L_004c8a4b:
    # block 0x004c8a4b: entered by je at 0x004c8934, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555490                            # 004c8a4b
    jmp.d32 L_004c8e34                           # 004c8a50
L_004c8a55:
    # block 0x004c8a55: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5554e8                            # 004c8a55
    jmp.d32 L_004c8e34                           # 004c8a5a
L_004c8a5f:
    # block 0x004c8a5f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555544                            # 004c8a5f
    jmp.d32 L_004c8e34                           # 004c8a64
L_004c8a69:
    # block 0x004c8a69: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555584                            # 004c8a69
    jmp.d32 L_004c8e34                           # 004c8a6e
L_004c8a73:
    # block 0x004c8a73: entered by je at 0x004c8964, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5555e0                            # 004c8a73
    jmp.d32 L_004c8e34                           # 004c8a78
L_004c8a7d:
    # block 0x004c8a7d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555604                            # 004c8a7d
    jmp.d32 L_004c8e34                           # 004c8a82
L_004c8a87:
    # block 0x004c8a87: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55565c                            # 004c8a87
    jmp.d32 L_004c8e34                           # 004c8a8c
L_004c8a91:
    # block 0x004c8a91: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5556c8                            # 004c8a91
    jmp.d32 L_004c8e34                           # 004c8a96
L_004c8a9b:
    # block 0x004c8a9b: entered by je at 0x004c891e, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555720                            # 004c8a9b
    jmp.d32 L_004c8e34                           # 004c8aa0
L_004c8aa5:
    # block 0x004c8aa5: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555768                            # 004c8aa5
    jmp.d32 L_004c8e34                           # 004c8aaa
L_004c8aaf:
    # block 0x004c8aaf: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5557ac                            # 004c8aaf
    jmp.d32 L_004c8e34                           # 004c8ab4
L_004c8ab9:
    # block 0x004c8ab9: entered by je at 0x004c8983, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555808                            # 004c8ab9
    jmp.d32 L_004c8e34                           # 004c8abe
L_004c8ac3:
    # block 0x004c8ac3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55586c                            # 004c8ac3
    jmp.d32 L_004c8e34                           # 004c8ac8
L_004c8acd:
    # block 0x004c8acd: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5558b0                            # 004c8acd
    jmp.d32 L_004c8e34                           # 004c8ad2
L_004c8ad7:
    # block 0x004c8ad7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5558e4                            # 004c8ad7
    jmp.d32 L_004c8e34                           # 004c8adc
L_004c8ae1:
    # block 0x004c8ae1: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555948                            # 004c8ae1
    jmp.d32 L_004c8e34                           # 004c8ae6
L_004c8aeb:
    # block 0x004c8aeb: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555970                            # 004c8aeb
    jmp.d32 L_004c8e34                           # 004c8af0
L_004c8af5:
    # block 0x004c8af5: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5559ec                            # 004c8af5
    jmp.d32 L_004c8e34                           # 004c8afa
L_004c8aff:
    # block 0x004c8aff: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555a18                            # 004c8aff
    jmp.d32 L_004c8e34                           # 004c8b04
L_004c8b09:
    # block 0x004c8b09: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555a98                            # 004c8b09
    jmp.d32 L_004c8e34                           # 004c8b0e
L_004c8b13:
    # block 0x004c8b13: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555af8                            # 004c8b13
    jmp.d32 L_004c8e34                           # 004c8b18
L_004c8b1d:
    # block 0x004c8b1d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555b38                            # 004c8b1d
    jmp.d32 L_004c8e34                           # 004c8b22
L_004c8b27:
    # block 0x004c8b27: entered by je at 0x004c8904, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555bac                            # 004c8b27
    jmp.d32 L_004c8e34                           # 004c8b2c
L_004c8b31:
    # block 0x004c8b31: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555c04                            # 004c8b31
    jmp.d32 L_004c8e34                           # 004c8b36
L_004c8b3b:
    # block 0x004c8b3b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555c4c                            # 004c8b3b
    jmp.d32 L_004c8e34                           # 004c8b40
L_004c8b45:
    # block 0x004c8b45: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555c8c                            # 004c8b45
    jmp.d32 L_004c8e34                           # 004c8b4a
L_004c8b4f:
    # block 0x004c8b4f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555cb4                            # 004c8b4f
    jmp.d32 L_004c8e34                           # 004c8b54
L_004c8b59:
    # block 0x004c8b59: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555d20                            # 004c8b59
    jmp.d32 L_004c8e34                           # 004c8b5e
L_004c8b63:
    # block 0x004c8b63: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555d50                            # 004c8b63
    jmp.d32 L_004c8e34                           # 004c8b68
L_004c8b6d:
    # block 0x004c8b6d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555dc4                            # 004c8b6d
    jmp.d32 L_004c8e34                           # 004c8b72
L_004c8b77:
    # block 0x004c8b77: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555e48                            # 004c8b77
    jmp.d32 L_004c8e34                           # 004c8b7c
L_004c8b81:
    # block 0x004c8b81: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555ebc                            # 004c8b81
    jmp.d32 L_004c8e34                           # 004c8b86
L_004c8b8b:
    # block 0x004c8b8b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555f28                            # 004c8b8b
    jmp.d32 L_004c8e34                           # 004c8b90
L_004c8b95:
    # block 0x004c8b95: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x555fa8                            # 004c8b95
    jmp.d32 L_004c8e34                           # 004c8b9a
L_004c8b9f:
    # block 0x004c8b9f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556038                            # 004c8b9f
    jmp.d32 L_004c8e34                           # 004c8ba4
L_004c8ba9:
    # block 0x004c8ba9: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5560b0                            # 004c8ba9
    jmp.d32 L_004c8e34                           # 004c8bae
L_004c8bb3:
    # block 0x004c8bb3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55612c                            # 004c8bb3
    jmp.d32 L_004c8e34                           # 004c8bb8
L_004c8bbd:
    # block 0x004c8bbd: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5561b4                            # 004c8bbd
    jmp.d32 L_004c8e34                           # 004c8bc2
L_004c8bc7:
    # block 0x004c8bc7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556224                            # 004c8bc7
    jmp.d32 L_004c8e34                           # 004c8bcc
L_004c8bd1:
    # block 0x004c8bd1: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5562b8                            # 004c8bd1
    jmp.d32 L_004c8e34                           # 004c8bd6
L_004c8bdb:
    # block 0x004c8bdb: entered by je at 0x004c894a, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556318                            # 004c8bdb
    jmp.d32 L_004c8e34                           # 004c8be0
L_004c8be5:
    # block 0x004c8be5: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556370                            # 004c8be5
    jmp.d32 L_004c8e34                           # 004c8bea
L_004c8bef:
    # block 0x004c8bef: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5563cc                            # 004c8bef
    jmp.d32 L_004c8e34                           # 004c8bf4
L_004c8bf9:
    # block 0x004c8bf9: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556410                            # 004c8bf9
    jmp.d32 L_004c8e34                           # 004c8bfe
L_004c8c03:
    # block 0x004c8c03: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556474                            # 004c8c03
    jmp.d32 L_004c8e34                           # 004c8c08
L_004c8c0d:
    # block 0x004c8c0d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5564ec                            # 004c8c0d
    jmp.d32 L_004c8e34                           # 004c8c12
L_004c8c17:
    # block 0x004c8c17: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556534                            # 004c8c17
    jmp.d32 L_004c8e34                           # 004c8c1c
L_004c8c21:
    # block 0x004c8c21: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55659c                            # 004c8c21
    jmp.d32 L_004c8e34                           # 004c8c26
L_004c8c2b:
    # block 0x004c8c2b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556614                            # 004c8c2b
    jmp.d32 L_004c8e34                           # 004c8c30
L_004c8c35:
    # block 0x004c8c35: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55668c                            # 004c8c35
    jmp.d32 L_004c8e34                           # 004c8c3a
L_004c8c3f:
    # block 0x004c8c3f: entered by je at 0x004c88ea, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556710                            # 004c8c3f
    jmp.d32 L_004c8e34                           # 004c8c44
L_004c8c49:
    # block 0x004c8c49: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556764                            # 004c8c49
    jmp.d32 L_004c8e34                           # 004c8c4e
L_004c8c53:
    # block 0x004c8c53: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5567c0                            # 004c8c53
    jmp.d32 L_004c8e34                           # 004c8c58
L_004c8c5d:
    # block 0x004c8c5d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556804                            # 004c8c5d
    jmp.d32 L_004c8e34                           # 004c8c62
L_004c8c67:
    # block 0x004c8c67: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556848                            # 004c8c67
    jmp.d32 L_004c8e34                           # 004c8c6c
L_004c8c71:
    # block 0x004c8c71: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5568b4                            # 004c8c71
    jmp.d32 L_004c8e34                           # 004c8c76
L_004c8c7b:
    # block 0x004c8c7b: entered by je at 0x004c8957, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5568f4                            # 004c8c7b
    jmp.d32 L_004c8e34                           # 004c8c80
L_004c8c85:
    # block 0x004c8c85: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556920                            # 004c8c85
    jmp.d32 L_004c8e34                           # 004c8c8a
L_004c8c8f:
    # block 0x004c8c8f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556970                            # 004c8c8f
    jmp.d32 L_004c8e34                           # 004c8c94
L_004c8c99:
    # block 0x004c8c99: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5569cc                            # 004c8c99
    jmp.d32 L_004c8e34                           # 004c8c9e
L_004c8ca3:
    # block 0x004c8ca3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556a0c                            # 004c8ca3
    jmp.d32 L_004c8e34                           # 004c8ca8
L_004c8cad:
    # block 0x004c8cad: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556a80                            # 004c8cad
    jmp.d32 L_004c8e34                           # 004c8cb2
L_004c8cb7:
    # block 0x004c8cb7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556ad4                            # 004c8cb7
    jmp.d32 L_004c8e34                           # 004c8cbc
L_004c8cc1:
    # block 0x004c8cc1: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556b44                            # 004c8cc1
    jmp.d32 L_004c8e34                           # 004c8cc6
L_004c8ccb:
    # block 0x004c8ccb: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556bc0                            # 004c8ccb
    jmp.d32 L_004c8e34                           # 004c8cd0
L_004c8cd5:
    # block 0x004c8cd5: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556c40                            # 004c8cd5
    jmp.d32 L_004c8e34                           # 004c8cda
L_004c8cdf:
    # block 0x004c8cdf: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556c98                            # 004c8cdf
    jmp.d32 L_004c8e34                           # 004c8ce4
L_004c8ce9:
    # block 0x004c8ce9: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556cd0                            # 004c8ce9
    jmp.d32 L_004c8e34                           # 004c8cee
L_004c8cf3:
    # block 0x004c8cf3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556d1c                            # 004c8cf3
    jmp.d32 L_004c8e34                           # 004c8cf8
L_004c8cfd:
    # block 0x004c8cfd: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556d98                            # 004c8cfd
    jmp.d32 L_004c8e34                           # 004c8d02
L_004c8d07:
    # block 0x004c8d07: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556de0                            # 004c8d07
    jmp.d32 L_004c8e34                           # 004c8d0c
L_004c8d11:
    # block 0x004c8d11: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556e58                            # 004c8d11
    jmp.d32 L_004c8e34                           # 004c8d16
L_004c8d1b:
    # block 0x004c8d1b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556edc                            # 004c8d1b
    jmp.d32 L_004c8e34                           # 004c8d20
L_004c8d25:
    # block 0x004c8d25: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556f24                            # 004c8d25
    jmp.d32 L_004c8e34                           # 004c8d2a
L_004c8d2f:
    # block 0x004c8d2f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556f6c                            # 004c8d2f
    jmp.d32 L_004c8e34                           # 004c8d34
L_004c8d39:
    # block 0x004c8d39: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x556fb4                            # 004c8d39
    jmp.d32 L_004c8e34                           # 004c8d3e
L_004c8d43:
    # block 0x004c8d43: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557020                            # 004c8d43
    jmp.d32 L_004c8e34                           # 004c8d48
L_004c8d4d:
    # block 0x004c8d4d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55703c                            # 004c8d4d
    jmp.d32 L_004c8e34                           # 004c8d52
L_004c8d57:
    # block 0x004c8d57: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55706c                            # 004c8d57
    jmp.d32 L_004c8e34                           # 004c8d5c
L_004c8d61:
    # block 0x004c8d61: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5570b8                            # 004c8d61
    jmp.d32 L_004c8e34                           # 004c8d66
L_004c8d6b:
    # block 0x004c8d6b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557144                            # 004c8d6b
    jmp.d32 L_004c8e34                           # 004c8d70
L_004c8d75:
    # block 0x004c8d75: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5571b4                            # 004c8d75
    jmp.d32 L_004c8e34                           # 004c8d7a
L_004c8d7f:
    # block 0x004c8d7f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557208                            # 004c8d7f
    jmp.d32 L_004c8e34                           # 004c8d84
L_004c8d89:
    # block 0x004c8d89: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557280                            # 004c8d89
    jmp.d32 L_004c8e34                           # 004c8d8e
L_004c8d93:
    # block 0x004c8d93: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5572d8                            # 004c8d93
    jmp.d32 L_004c8e34                           # 004c8d98
L_004c8d9d:
    # block 0x004c8d9d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557340                            # 004c8d9d
    jmp.d32 L_004c8e34                           # 004c8da2
L_004c8da7:
    # block 0x004c8da7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55736c                            # 004c8da7
    jmp.d32 L_004c8e34                           # 004c8dac
L_004c8db1:
    # block 0x004c8db1: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5573a8                            # 004c8db1
    jmp.d8 L_004c8e34                            # 004c8db6
L_004c8db8:
    # block 0x004c8db8: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5573e0                            # 004c8db8
    jmp.d8 L_004c8e34                            # 004c8dbd
L_004c8dbf:
    # block 0x004c8dbf: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557440                            # 004c8dbf
    jmp.d8 L_004c8e34                            # 004c8dc4
L_004c8dc6:
    # block 0x004c8dc6: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5574a8                            # 004c8dc6
    jmp.d8 L_004c8e34                            # 004c8dcb
L_004c8dcd:
    # block 0x004c8dcd: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5574f8                            # 004c8dcd
    jmp.d8 L_004c8e34                            # 004c8dd2
L_004c8dd4:
    # block 0x004c8dd4: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557544                            # 004c8dd4
    jmp.d8 L_004c8e34                            # 004c8dd9
L_004c8ddb:
    # block 0x004c8ddb: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5575c8                            # 004c8ddb
    jmp.d8 L_004c8e34                            # 004c8de0
L_004c8de2:
    # block 0x004c8de2: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55763c                            # 004c8de2
    jmp.d8 L_004c8e34                            # 004c8de7
L_004c8de9:
    # block 0x004c8de9: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5576ac                            # 004c8de9
    jmp.d8 L_004c8e34                            # 004c8dee
L_004c8df0:
    # block 0x004c8df0: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55770c                            # 004c8df0
    jmp.d8 L_004c8e34                            # 004c8df5
L_004c8df7:
    # block 0x004c8df7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557780                            # 004c8df7
    jmp.d8 L_004c8e34                            # 004c8dfc
L_004c8dfe:
    # block 0x004c8dfe: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55780c                            # 004c8dfe
    jmp.d8 L_004c8e34                            # 004c8e03
L_004c8e05:
    # block 0x004c8e05: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x55784c                            # 004c8e05
    jmp.d8 L_004c8e34                            # 004c8e0a
L_004c8e0c:
    # block 0x004c8e0c: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557890                            # 004c8e0c
    jmp.d8 L_004c8e34                            # 004c8e11
L_004c8e13:
    # block 0x004c8e13: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x5578f4                            # 004c8e13
    jmp.d8 L_004c8e34                            # 004c8e18
L_004c8e1a:
    # block 0x004c8e1a: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557950                            # 004c8e1a
    jmp.d8 L_004c8e34                            # 004c8e1f
L_004c8e21:
    # block 0x004c8e21: entered by switch case, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557988                            # 004c8e21
    jmp.d8 L_004c8e34                            # 004c8e26
L_004c8e28:
    # block 0x004c8e28: entered by je at 0x004c8971, 2 instruction(s), ends with forward jump to 0x004c8e34
    mov eax, 0x557a0c                            # 004c8e28
    jmp.d8 L_004c8e34                            # 004c8e2d
L_004c8e2f:
    # block 0x004c8e2f: entered by jmp at 0x004c8977; jmp at 0x004c8996; ja at 0x004c89ab; ja at 0x004c89d3; more, 1 instruction(s), falls into the block at 0x004c8e34
    mov eax, 0x557aa8                            # 004c8e2f
L_004c8e34:
    # block 0x004c8e34: entered by jmp at 0x004c8a46; jmp at 0x004c8a50; jmp at 0x004c8a5a; jmp at 0x004c8a64; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c8e34
    pop ebp                                      # 004c8e36
    ret 0x4                                      # 004c8e37

# --- data items (not part of the function) -------------------------
.org 0x004c8e3a - 0x401000
SWTAB_004c8e3a:  # 7 case address(es)
    .long L_004c8a55 - .text + 0x401000
    .long L_004c8a5f - .text + 0x401000
    .long L_004c8a69 - .text + 0x401000
    .long L_004c8a7d - .text + 0x401000
    .long L_004c8a87 - .text + 0x401000
    .long L_004c8a91 - .text + 0x401000
    .long L_004c8e2f - .text + 0x401000
.org 0x004c8e56 - 0x401000
IDXTAB_004c8e56:  # index table of FUN_004c88c7 for the switch jump at 0x004c89bc (81 byte(s))
    .byte 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 2, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 3, 6, 6, 6, 6, 4, 6, 6, 6, 6
    .byte 5
.org 0x004c8ea7 - 0x401000
SWTAB_004c8ea7:  # 13 case address(es)
    .long L_004c8aa5 - .text + 0x401000
    .long L_004c8aaf - .text + 0x401000
    .long L_004c8ac3 - .text + 0x401000
    .long L_004c8acd - .text + 0x401000
    .long L_004c8ad7 - .text + 0x401000
    .long L_004c8ae1 - .text + 0x401000
    .long L_004c8aeb - .text + 0x401000
    .long L_004c8af5 - .text + 0x401000
    .long L_004c8aff - .text + 0x401000
    .long L_004c8b09 - .text + 0x401000
    .long L_004c8b13 - .text + 0x401000
    .long L_004c8b1d - .text + 0x401000
    .long L_004c8e2f - .text + 0x401000
.org 0x004c8edb - 0x401000
IDXTAB_004c8edb:  # index table of FUN_004c88c7 for the switch jump at 0x004c89e4 (101 byte(s))
    .byte 0, 12, 12, 12, 12, 12, 12, 12, 12, 12, 1, 12, 12, 12, 12, 12
    .byte 12, 12, 12, 12, 12, 12, 12, 12, 12, 2, 12, 12, 12, 12, 3, 12
    .byte 12, 12, 12, 12, 12, 12, 12, 12, 4, 12, 12, 12, 12, 12, 12, 12
    .byte 12, 12, 5, 12, 12, 12, 12, 12, 12, 12, 12, 12, 6, 12, 12, 12
    .byte 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12
    .byte 12, 12, 12, 12, 12, 7, 12, 12, 12, 12, 8, 12, 9, 12, 12, 10
    .byte 12, 12, 12, 12, 11
.org 0x004c8f40 - 0x401000
SWTAB_004c8f40:  # 27 case address(es)
    .long L_004c8b31 - .text + 0x401000
    .long L_004c8b3b - .text + 0x401000
    .long L_004c8b45 - .text + 0x401000
    .long L_004c8b4f - .text + 0x401000
    .long L_004c8b59 - .text + 0x401000
    .long L_004c8b63 - .text + 0x401000
    .long L_004c8b6d - .text + 0x401000
    .long L_004c8b77 - .text + 0x401000
    .long L_004c8b81 - .text + 0x401000
    .long L_004c8b8b - .text + 0x401000
    .long L_004c8b95 - .text + 0x401000
    .long L_004c8b9f - .text + 0x401000
    .long L_004c8ba9 - .text + 0x401000
    .long L_004c8bb3 - .text + 0x401000
    .long L_004c8bbd - .text + 0x401000
    .long L_004c8bc7 - .text + 0x401000
    .long L_004c8bd1 - .text + 0x401000
    .long L_004c8be5 - .text + 0x401000
    .long L_004c8bef - .text + 0x401000
    .long L_004c8bf9 - .text + 0x401000
    .long L_004c8c03 - .text + 0x401000
    .long L_004c8c0d - .text + 0x401000
    .long L_004c8c17 - .text + 0x401000
    .long L_004c8c21 - .text + 0x401000
    .long L_004c8c2b - .text + 0x401000
    .long L_004c8c35 - .text + 0x401000
    .long L_004c8e2f - .text + 0x401000
.org 0x004c8fac - 0x401000
IDXTAB_004c8fac:  # index table of FUN_004c88c7 for the switch jump at 0x004c8a0f (211 byte(s))
    .byte 0, 26, 26, 26, 26, 1, 26, 26, 26, 26, 26, 26, 26, 26, 26, 2
    .byte 26, 26, 26, 26, 26, 26, 26, 26, 26, 3, 26, 26, 26, 26, 4, 26
    .byte 26, 26, 26, 5, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26
    .byte 26, 26, 26, 26, 26, 26, 26, 6, 26, 26, 26, 26, 26, 26, 26, 26
    .byte 26, 7, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26
    .byte 26, 26, 26, 26, 26, 8, 26, 26, 26, 26, 26, 9, 10, 26, 26, 11
    .byte 26, 26, 26, 26, 26, 26, 26, 26, 26, 12, 26, 26, 26, 26, 13, 26
    .byte 26, 26, 26, 14, 26, 26, 26, 26, 26, 26, 26, 26, 26, 15, 26, 26
    .byte 26, 26, 26, 26, 26, 26, 26, 16, 26, 26, 26, 26, 26, 26, 26, 26
    .byte 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 26, 18, 26, 19
    .byte 26, 26, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 21
    .byte 26, 26, 26, 26, 26, 26, 26, 26, 26, 22, 26, 26, 26, 26, 26, 26
    .byte 26, 26, 26, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 26, 26
    .byte 26, 26, 25
.org 0x004c907f - 0x401000
SWTAB_004c907f:  # 53 case address(es)
    .long L_004c8c49 - .text + 0x401000
    .long L_004c8c53 - .text + 0x401000
    .long L_004c8c5d - .text + 0x401000
    .long L_004c8c67 - .text + 0x401000
    .long L_004c8c71 - .text + 0x401000
    .long L_004c8c85 - .text + 0x401000
    .long L_004c8c8f - .text + 0x401000
    .long L_004c8c99 - .text + 0x401000
    .long L_004c8ca3 - .text + 0x401000
    .long L_004c8cad - .text + 0x401000
    .long L_004c8cb7 - .text + 0x401000
    .long L_004c8cc1 - .text + 0x401000
    .long L_004c8ccb - .text + 0x401000
    .long L_004c8cd5 - .text + 0x401000
    .long L_004c8cdf - .text + 0x401000
    .long L_004c8ce9 - .text + 0x401000
    .long L_004c8cf3 - .text + 0x401000
    .long L_004c8cfd - .text + 0x401000
    .long L_004c8d07 - .text + 0x401000
    .long L_004c8d11 - .text + 0x401000
    .long L_004c8d1b - .text + 0x401000
    .long L_004c8d25 - .text + 0x401000
    .long L_004c8d2f - .text + 0x401000
    .long L_004c8d39 - .text + 0x401000
    .long L_004c8d43 - .text + 0x401000
    .long L_004c8d4d - .text + 0x401000
    .long L_004c8d57 - .text + 0x401000
    .long L_004c8d61 - .text + 0x401000
    .long L_004c8d6b - .text + 0x401000
    .long L_004c8d75 - .text + 0x401000
    .long L_004c8d7f - .text + 0x401000
    .long L_004c8d89 - .text + 0x401000
    .long L_004c8d93 - .text + 0x401000
    .long L_004c8d9d - .text + 0x401000
    .long L_004c8da7 - .text + 0x401000
    .long L_004c8db1 - .text + 0x401000
    .long L_004c8db8 - .text + 0x401000
    .long L_004c8dbf - .text + 0x401000
    .long L_004c8dc6 - .text + 0x401000
    .long L_004c8dcd - .text + 0x401000
    .long L_004c8dd4 - .text + 0x401000
    .long L_004c8ddb - .text + 0x401000
    .long L_004c8de2 - .text + 0x401000
    .long L_004c8de9 - .text + 0x401000
    .long L_004c8df0 - .text + 0x401000
    .long L_004c8df7 - .text + 0x401000
    .long L_004c8dfe - .text + 0x401000
    .long L_004c8e05 - .text + 0x401000
    .long L_004c8e0c - .text + 0x401000
    .long L_004c8e13 - .text + 0x401000
    .long L_004c8e1a - .text + 0x401000
    .long L_004c8e21 - .text + 0x401000
    .long L_004c8e2f - .text + 0x401000
.org 0x004c9153 - 0x401000
IDXTAB_004c9153:  # index table of FUN_004c88c7 for the switch jump at 0x004c8a3a (250 byte(s))
    .byte 0, 52, 52, 52, 52, 52, 52, 52, 52, 52, 1, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 2, 52, 52, 52, 52, 52, 52, 52, 52, 52, 3, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 52, 4, 52, 52, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 5, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 6, 52, 52, 52, 52, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 7, 52, 52, 8, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 9, 10
    .byte 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26
    .byte 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 52
    .byte 52, 52, 52, 52, 52, 52, 42, 43, 52, 52, 52, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 44, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 45, 52, 52, 52, 52, 52, 52, 52, 52, 52, 46, 52
    .byte 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52
    .byte 52, 52, 47, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52
    .byte 52, 52, 52, 52, 52, 52, 48, 52, 52, 52, 52, 52, 52, 52, 52, 52
    .byte 49, 52, 52, 52, 52, 50, 52, 52, 52, 51
.set SWTAB_004c8e3a_VA, SWTAB_004c8e3a - .text + 0x401000
.set IDXTAB_004c8e56_VA, IDXTAB_004c8e56 - .text + 0x401000
.set SWTAB_004c8ea7_VA, SWTAB_004c8ea7 - .text + 0x401000
.set IDXTAB_004c8edb_VA, IDXTAB_004c8edb - .text + 0x401000
.set SWTAB_004c8f40_VA, SWTAB_004c8f40 - .text + 0x401000
.set IDXTAB_004c8fac_VA, IDXTAB_004c8fac - .text + 0x401000
.set SWTAB_004c907f_VA, SWTAB_004c907f - .text + 0x401000
.set IDXTAB_004c9153_VA, IDXTAB_004c9153 - .text + 0x401000

