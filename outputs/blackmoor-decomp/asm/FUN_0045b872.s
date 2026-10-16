# FUN_0045b872
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b872
# extent:       0x0045b872-0x0045ba0b (409 code bytes)
# span:         0x0045b872-0x0045ba0b (code 409, tables 0, padding 0)
# sha256:       526611362736b2e3f2b9a84981ef4d5e6c9b5b8b020575a2a3b84fdacf204071
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b872
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_32, field_166, field_172, field_1b5, field_4fe; [ecx + n] field_28, field_16a, field_16e, field_172, field_51f; [edx + n] field_1e, field_24, field_2c, field_2e, field_172, field_51f
# callees:      calls FUN_0045be7f, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 99 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_1b5, 0x1b5  # offset +0x1b5
.equ field_4fe, 0x4fe  # offset +0x4fe
.equ field_51f, 0x51f  # offset +0x51f

# --- external targets -----------------------------------------------
.set FUN_0045be7f, .text + (0x0045be7f - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0045b872 - 0x401000
.globl FUN_0045b872
FUN_0045b872:
    # block 0x0045b872: entry, 14 instruction(s), ends with je to 0x0045ba05 (forward)
    push ebp                                     # 0045b872
    {load} mov ebp, esp                          # 0045b873
    sub esp, 0xc                                 # 0045b875
    push esi                                     # 0045b878
    push edi                                     # 0045b879
    mov dword ptr [ebp - local_c], ecx           # 0045b87a
    mov eax, dword ptr [ebp - local_c]           # 0045b87d
    movsx ecx, word ptr [eax + field_1e]         # 0045b880
    imul ecx, ecx, 0x8d                          # 0045b884
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045b88a
    mov dword ptr [ebp - local_4], edx           # 0045b890
    mov eax, dword ptr [ebp - local_c]           # 0045b893
    cmp dword ptr [eax + field_166], 0x0         # 0045b896
    je.d32 L_0045ba05                            # 0045b89d
    # block 0x0045b8a3: entered by fall-through of je at 0x0045b89d, 3 instruction(s), ends with jne to 0x0045ba05 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0045b8a3
    cmp dword ptr [ecx + field_16a], 0x0         # 0045b8a6
    jne.d32 L_0045ba05                           # 0045b8ad
    # block 0x0045b8b3: entered by fall-through of jne at 0x0045b8ad, 3 instruction(s), ends with jne to 0x0045ba05 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0045b8b3
    cmp dword ptr [edx + field_24], 0x0          # 0045b8b6
    jne.d32 L_0045ba05                           # 0045b8ba
    # block 0x0045b8c0: entered by fall-through of jne at 0x0045b8ba, 5 instruction(s), ends with jne to 0x0045ba05 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0045b8c0
    movsx ecx, word ptr [eax + field_1e]         # 0045b8c3
    imul ecx, ecx, 0x8d                          # 0045b8c7
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 0045b8cd
    jne.d32 L_0045ba05                           # 0045b8d4
    # block 0x0045b8da: entered by fall-through of jne at 0x0045b8d4, 2 instruction(s), ends with jne to 0x0045b93f (forward)
    cmp dword ptr [0x5c39e5], 0x27bb             # 0045b8da
    jne.d8 L_0045b93f                            # 0045b8e4
    # block 0x0045b8e6: entered by fall-through of jne at 0x0045b8e4, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045b923 (forward)
    push 0x0                                     # 0045b8e6
    push 0x4                                     # 0045b8e8
    mov edx, dword ptr [ebp - local_4]           # 0045b8ea
    add edx, 0x7e9                               # 0045b8ed
    push edx                                     # 0045b8f3
    mov ecx, dword ptr [ebp - local_c]           # 0045b8f4
    call FUN_0045be7f                            # 0045b8f7
    test eax, eax                                # 0045b8fc
    je.d8 L_0045b923                             # 0045b8fe
    # block 0x0045b900: entered by fall-through of je at 0x0045b8fe, 7 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045b93a
    mov eax, dword ptr [ebp - local_c]           # 0045b900
    mov dword ptr [eax + field_1b5], 0xb         # 0045b903
    call dword ptr [0x52a23c]                    # 0045b90d
    add eax, 0x320                               # 0045b913
    mov ecx, dword ptr [ebp - local_c]           # 0045b918
    mov dword ptr [ecx + field_16e], eax         # 0045b91b
    jmp.d8 L_0045b93a                            # 0045b921
L_0045b923:
    # block 0x0045b923: entered by je at 0x0045b8fe, 4 instruction(s), falls into the block at 0x0045b93a
    mov edx, dword ptr [ebp - local_c]           # 0045b923
    movsx eax, word ptr [edx + field_1e]         # 0045b926
    imul eax, eax, 0x8d                          # 0045b92a
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045b930
L_0045b93a:
    # block 0x0045b93a: entered by jmp at 0x0045b921, 1 instruction(s), ends with forward jump to 0x0045ba05
    jmp.d32 L_0045ba05                           # 0045b93a
L_0045b93f:
    # block 0x0045b93f: entered by jne at 0x0045b8e4, 2 instruction(s), ends with jne to 0x0045ba05 (forward)
    cmp dword ptr [0x5c39e5], 0x27ba             # 0045b93f
    jne.d32 L_0045ba05                           # 0045b949
    # block 0x0045b94f: entered by fall-through of jne at 0x0045b949, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0045ba05 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0045b94f
    mov dword ptr [ecx + field_28], 0x1          # 0045b952
    mov edx, dword ptr [ebp - local_c]           # 0045b959
    mov eax, dword ptr [ebp - local_c]           # 0045b95c
    mov cx, word ptr [eax + field_172]           # 0045b95f
    mov word ptr [edx + field_2c], cx            # 0045b966
    call dword ptr [0x52a23c]                    # 0045b96a
    add eax, 0xfa                                # 0045b970
    mov edx, dword ptr [ebp - local_c]           # 0045b975
    mov dword ptr [edx + field_2e], eax          # 0045b978
    mov eax, dword ptr [ebp - local_c]           # 0045b97b
    mov dword ptr [eax + field_32], 0x1          # 0045b97e
    cmp dword ptr [0x5bb1ca], 0x0                # 0045b985
    je.d8 L_0045ba05                             # 0045b98c
    # block 0x0045b98e: entered by fall-through of je at 0x0045b98c, 10 instruction(s), ends with je to 0x0045ba05 (forward)
    mov edi, 0x54ab5c                            # 0045b98e
    mov ecx, dword ptr [ebp - local_c]           # 0045b993
    movsx edx, word ptr [ecx + field_172]        # 0045b996
    imul edx, edx, 0x31                          # 0045b99d
    mov eax, dword ptr [ebp - local_4]           # 0045b9a0
    lea esi, [eax + edx + field_4fe]             # 0045b9a3
    mov ecx, 0x9                                 # 0045b9aa
    {load} xor edx, edx                          # 0045b9af
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045b9b1
    je.d8 L_0045ba05                             # 0045b9b3
    # block 0x0045b9b5: entered by fall-through of je at 0x0045b9b3, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x0045ba05 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0045b9b5
    movsx ecx, word ptr [eax + field_172]        # 0045b9b8
    imul ecx, ecx, 0x31                          # 0045b9bf
    mov edx, dword ptr [ebp - local_4]           # 0045b9c2
    movsx eax, word ptr [edx + ecx + field_51f]  # 0045b9c5
    mov dword ptr [ebp - local_8], eax           # 0045b9cd
    mov ecx, dword ptr [ebp - local_8]           # 0045b9d0
    push ecx                                     # 0045b9d3
    mov ecx, 0x5cf1eb                            # 0045b9d4
    call FUN_004f6334                            # 0045b9d9
    test eax, eax                                # 0045b9de
    jne.d8 L_0045ba05                            # 0045b9e0
    # block 0x0045b9e2: entered by fall-through of jne at 0x0045b9e0, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0045ba05
    mov edx, dword ptr [ebp - local_c]           # 0045b9e2
    movsx eax, word ptr [edx + field_172]        # 0045b9e5
    imul eax, eax, 0x31                          # 0045b9ec
    mov ecx, dword ptr [ebp - local_4]           # 0045b9ef
    mov dx, word ptr [ecx + eax + field_51f]     # 0045b9f2
    push edx                                     # 0045b9fa
    mov ecx, 0x5c3a67                            # 0045b9fb
    call FUN_004fb2e3                            # 0045ba00
L_0045ba05:
    # block 0x0045ba05: entered by je at 0x0045b89d; jne at 0x0045b8ad; jne at 0x0045b8ba; jne at 0x0045b8d4; more, 5 instruction(s), ends with ret
    pop edi                                      # 0045ba05
    pop esi                                      # 0045ba06
    {load} mov esp, ebp                          # 0045ba07
    pop ebp                                      # 0045ba09
    ret                                          # 0045ba0a

