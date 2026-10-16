# FUN_0044d946
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d946
# extent:       0x0044d946-0x0044d9b5 (111 code bytes)
# span:         0x0044d946-0x0044d9b5 (code 111, tables 0, padding 0)
# sha256:       20ce27beea49c61c6d93cea1d7e5b42ab173823a26a7f653d0078d23f6dc6f5f
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d946
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_3d, field_41; [ecx + n] field_3d; [edx + n] field_3d
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41

# --- external targets -----------------------------------------------

.org 0x0044d946 - 0x401000
.globl FUN_0044d946
FUN_0044d946:
    # block 0x0044d946: entry, 7 instruction(s), ends with jne to 0x0044d980 (forward)
    push ebp                                     # 0044d946
    {load} mov ebp, esp                          # 0044d947
    push ecx                                     # 0044d949
    mov dword ptr [ebp - local_4], ecx           # 0044d94a
    mov eax, dword ptr [ebp - local_4]           # 0044d94d
    cmp dword ptr [eax + field_41], 0x0          # 0044d950
    jne.d8 L_0044d980                            # 0044d954
    # block 0x0044d956: entered by fall-through of jne at 0x0044d954, 4 instruction(s), ends with jne to 0x0044d96d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044d956
    movsx edx, word ptr [ecx + field_3d]         # 0044d959
    cmp edx, 0xb                                 # 0044d95d
    jne.d8 L_0044d96d                            # 0044d960
    # block 0x0044d962: entered by fall-through of jne at 0x0044d960, 2 instruction(s), ends with forward jump to 0x0044d97e
    mov word ptr [0x585d51], 0xc                 # 0044d962
    jmp.d8 L_0044d97e                            # 0044d96b
L_0044d96d:
    # block 0x0044d96d: entered by jne at 0x0044d960, 4 instruction(s), falls into the block at 0x0044d97e
    mov eax, dword ptr [ebp - local_4]           # 0044d96d
    movsx ecx, word ptr [eax + field_3d]         # 0044d970
    add ecx, 0xd                                 # 0044d974
    mov word ptr [0x585d51], cx                  # 0044d977
L_0044d97e:
    # block 0x0044d97e: entered by jmp at 0x0044d96b, 1 instruction(s), ends with forward jump to 0x0044d9a8
    jmp.d8 L_0044d9a8                            # 0044d97e
L_0044d980:
    # block 0x0044d980: entered by jne at 0x0044d954, 4 instruction(s), ends with jne to 0x0044d997 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044d980
    movsx eax, word ptr [edx + field_3d]         # 0044d983
    cmp eax, 0xb                                 # 0044d987
    jne.d8 L_0044d997                            # 0044d98a
    # block 0x0044d98c: entered by fall-through of jne at 0x0044d98a, 2 instruction(s), ends with forward jump to 0x0044d9a8
    mov word ptr [0x585d51], 0x0                 # 0044d98c
    jmp.d8 L_0044d9a8                            # 0044d995
L_0044d997:
    # block 0x0044d997: entered by jne at 0x0044d98a, 4 instruction(s), falls into the block at 0x0044d9a8
    mov ecx, dword ptr [ebp - local_4]           # 0044d997
    movsx edx, word ptr [ecx + field_3d]         # 0044d99a
    add edx, 0x1                                 # 0044d99e
    mov word ptr [0x585d51], dx                  # 0044d9a1
L_0044d9a8:
    # block 0x0044d9a8: entered by jmp at 0x0044d97e; jmp at 0x0044d995, 4 instruction(s), ends with ret
    mov word ptr [0x585d4f], 0x0                 # 0044d9a8
    {load} mov esp, ebp                          # 0044d9b1
    pop ebp                                      # 0044d9b3
    ret                                          # 0044d9b4

