# FUN_005149de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005149de
# extent:       0x005149de-0x00514a77 (153 code bytes)
# span:         0x005149de-0x00514a77 (code 153, tables 0, padding 0)
# sha256:       02193847a777ac14c5b35ff9e271427cebdf5455039f1442e7dc7bfb8fbe1fa2
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005149de
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005104fa, KERNEL32.dll!GetModuleFileNameA, FUN_00514a77, FUN_0050ea90, FUN_0050e8ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_005104fa, .text + (0x005104fa - 0x401000)
.set FUN_00514a77, .text + (0x00514a77 - 0x401000)

.org 0x005149de - 0x401000
.globl FUN_005149de
FUN_005149de:
    # block 0x005149de: entry, 10 instruction(s), ends with jne to 0x005149f5 (forward)
    push ebp                                     # 005149de
    {load} mov ebp, esp                          # 005149df
    push ecx                                     # 005149e1
    push ecx                                     # 005149e2
    push ebx                                     # 005149e3
    {load} xor ebx, ebx                          # 005149e4
    cmp dword ptr [0x63e130], ebx                # 005149e6
    push esi                                     # 005149ec
    push edi                                     # 005149ed
    jne.d8 L_005149f5                            # 005149ee
    # block 0x005149f0: entered by fall-through of jne at 0x005149ee, 1 instruction(s), calls FUN_005104fa, falls into the block at 0x005149f5
    call FUN_005104fa                            # 005149f0
L_005149f5:
    # block 0x005149f5: entered by jne at 0x005149ee, 10 instruction(s), calls KERNEL32.dll!GetModuleFileNameA, ends with je to 0x00514a1a (forward)
    mov esi, 0x63cb3c                            # 005149f5
    push 0x104                                   # 005149fa
    push esi                                     # 005149ff
    push ebx                                     # 00514a00
    call dword ptr [0x52a28c]                    # 00514a01
    mov eax, dword ptr [0x63e128]                # 00514a07
    mov dword ptr [0x63ca3c], esi                # 00514a0c
    {load} mov edi, esi                          # 00514a12
    cmp byte ptr [eax], bl                       # 00514a14
    je.d8 L_00514a1a                             # 00514a16
    # block 0x00514a18: entered by fall-through of je at 0x00514a16, 1 instruction(s), falls into the block at 0x00514a1a
    {load} mov edi, eax                          # 00514a18
L_00514a1a:
    # block 0x00514a1a: entered by je at 0x00514a16, 17 instruction(s), calls FUN_00514a77, FUN_0050ea90, ends with jne to 0x00514a4a (forward)
    lea eax, [ebp - local_8]                     # 00514a1a
    push eax                                     # 00514a1d
    lea eax, [ebp - local_4]                     # 00514a1e
    push eax                                     # 00514a21
    push ebx                                     # 00514a22
    push ebx                                     # 00514a23
    push edi                                     # 00514a24
    call FUN_00514a77                            # 00514a25
    mov eax, dword ptr [ebp - local_8]           # 00514a2a
    mov ecx, dword ptr [ebp - local_4]           # 00514a2d
    lea eax, [eax + 4*ecx]                       # 00514a30
    push eax                                     # 00514a33
    call FUN_0050ea90                            # 00514a34
    {load} mov esi, eax                          # 00514a39
    add esp, 0x18                                # 00514a3b
    {load} cmp esi, ebx                          # 00514a3e
    jne.d8 L_00514a4a                            # 00514a40
    # block 0x00514a42: entered by fall-through of jne at 0x00514a40, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x00514a4a
    push 0x8                                     # 00514a42
    call FUN_0050e8ed                            # 00514a44
    pop ecx                                      # 00514a49
L_00514a4a:
    # block 0x00514a4a: entered by jne at 0x00514a40, 20 instruction(s), calls FUN_00514a77, ends with ret
    lea eax, [ebp - local_8]                     # 00514a4a
    push eax                                     # 00514a4d
    lea eax, [ebp - local_4]                     # 00514a4e
    push eax                                     # 00514a51
    mov eax, dword ptr [ebp - local_4]           # 00514a52
    lea eax, [esi + 4*eax]                       # 00514a55
    push eax                                     # 00514a58
    push esi                                     # 00514a59
    push edi                                     # 00514a5a
    call FUN_00514a77                            # 00514a5b
    mov eax, dword ptr [ebp - local_4]           # 00514a60
    add esp, 0x14                                # 00514a63
    dec eax                                      # 00514a66
    mov dword ptr [0x63ca24], esi                # 00514a67
    pop edi                                      # 00514a6d
    pop esi                                      # 00514a6e
    mov dword ptr [0x63ca20], eax                # 00514a6f
    pop ebx                                      # 00514a74
    leave                                        # 00514a75
    ret                                          # 00514a76

