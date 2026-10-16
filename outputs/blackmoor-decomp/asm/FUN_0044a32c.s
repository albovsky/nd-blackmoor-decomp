# FUN_0044a32c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a32c
# extent:       0x0044a32c-0x0044a412 (230 code bytes)
# span:         0x0044a32c-0x0044a412 (code 230, tables 0, padding 0)
# sha256:       6f5b56221ff56daa270dc3fc6b012de0fefc109a2376dc204418ec68547485d0
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a32c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044a32c - 0x401000
.globl FUN_0044a32c
FUN_0044a32c:
    # block 0x0044a32c: entry, 8 instruction(s), ends with jne to 0x0044a35a (forward)
    push ebp                                     # 0044a32c
    {load} mov ebp, esp                          # 0044a32d
    sub esp, 0x18                                # 0044a32f
    {load} xor eax, eax                          # 0044a332
    mov al, byte ptr [0x63a848]                  # 0044a334
    and eax, 0x1                                 # 0044a339
    test eax, eax                                # 0044a33c
    jne.d8 L_0044a35a                            # 0044a33e
    # block 0x0044a340: entered by fall-through of jne at 0x0044a33e, 5 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0044a35a
    mov cl, byte ptr [0x63a848]                  # 0044a340
    or cl, 0x1                                   # 0044a346
    mov byte ptr [0x63a848], cl                  # 0044a349
    call dword ptr [0x52a23c]                    # 0044a34f
    mov dword ptr [0x63a844], eax                # 0044a355
L_0044a35a:
    # block 0x0044a35a: entered by jne at 0x0044a33e, 8 instruction(s), ends with jl to 0x0044a408 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 0044a35a
    mov edx, dword ptr [ebp + arg_8]             # 0044a361
    mov byte ptr [edx], 0x0                      # 0044a364
    mov eax, dword ptr [0x548aa8]                # 0044a367
    add eax, 0x1                                 # 0044a36c
    mov dword ptr [0x548aa8], eax                # 0044a36f
    cmp dword ptr [0x548aa8], 0x1e               # 0044a374
    jl.d32 L_0044a408                            # 0044a37b
    # block 0x0044a381: entered by fall-through of jl at 0x0044a37b, 7 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0044a3af (forward)
    call dword ptr [0x52a23c]                    # 0044a381
    mov dword ptr [0x63a850], eax                # 0044a387
    mov ecx, dword ptr [0x63a850]                # 0044a38c
    sub ecx, dword ptr [0x63a844]                # 0044a392
    mov dword ptr [ebp - local_8], ecx           # 0044a398
    cmp dword ptr [ebp - local_8], 0x0           # 0044a39b
    je.d8 L_0044a3af                             # 0044a39f
    # block 0x0044a3a1: entered by fall-through of je at 0x0044a39f, 3 instruction(s), ends with jbe to 0x0044a3b4 (forward)
    mov edx, dword ptr [0x63a844]                # 0044a3a1
    cmp edx, dword ptr [0x63a850]                # 0044a3a7
    jbe.d8 L_0044a3b4                            # 0044a3ad
L_0044a3af:
    # block 0x0044a3af: entered by je at 0x0044a39f; fall-through of jbe at 0x0044a3ad, 2 instruction(s), ends with forward jump to 0x0044a40e
    fld dword ptr [ebp - local_4]                # 0044a3af
    jmp.d8 L_0044a40e                            # 0044a3b2
L_0044a3b4:
    # block 0x0044a3b4: entered by jbe at 0x0044a3ad, 20 instruction(s), ends with forward jump to 0x0044a40e
    fild dword ptr [0x548aa8]                    # 0044a3b4
    fstp dword ptr [ebp - local_c]               # 0044a3ba
    mov eax, dword ptr [ebp - local_8]           # 0044a3bd
    mov dword ptr [ebp - local_14], eax          # 0044a3c0
    mov dword ptr [ebp - local_10], 0x0          # 0044a3c3
    fild qword ptr [ebp - local_14]              # 0044a3ca
    fstp dword ptr [ebp - local_18]              # 0044a3cd
    fld dword ptr [ebp - local_c]                # 0044a3d0
    fdiv dword ptr [ebp - local_18]              # 0044a3d3
    fmul qword ptr [0x52c590]                    # 0044a3d6
    fstp dword ptr [ebp - local_4]               # 0044a3dc
    mov ecx, dword ptr [0x63a850]                # 0044a3df
    mov dword ptr [0x63a844], ecx                # 0044a3e5
    mov dword ptr [0x548aa8], 0x0                # 0044a3eb
    mov edx, dword ptr [ebp + arg_8]             # 0044a3f5
    mov byte ptr [edx], 0x1                      # 0044a3f8
    mov eax, dword ptr [ebp - local_4]           # 0044a3fb
    mov dword ptr [0x63a854], eax                # 0044a3fe
    fld dword ptr [ebp - local_4]                # 0044a403
    jmp.d8 L_0044a40e                            # 0044a406
L_0044a408:
    # block 0x0044a408: entered by jl at 0x0044a37b, 1 instruction(s), falls into the block at 0x0044a40e
    fld dword ptr [0x63a854]                     # 0044a408
L_0044a40e:
    # block 0x0044a40e: entered by jmp at 0x0044a3b2; jmp at 0x0044a406, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044a40e
    pop ebp                                      # 0044a410
    ret                                          # 0044a411

