# FUN_00524a01
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524a01
# extent:       0x00524a01-0x00524ae1 (224 code bytes)
# span:         0x00524a01-0x00524ae1 (code 224, tables 0, padding 0)
# sha256:       cb02f4c8d9d9db00e5bd6feb5c457528d11c79cb32e35c3d4c77e77009b36d89
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524a01
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_90
# fields:       [ebx + n] field_f, field_minus_4; [edx + n] field_1
# callees:      calls USER32.dll!GetMenuCheckMarkDimensions, FUN_0050f920, GDI32.dll!CreateBitmap, USER32.dll!LoadBitmapA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 81 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524ae1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_90, 0x90  # offset -0x90
.equ field_1, 0x1  # offset +0x1
.equ field_f, 0xf  # offset +0xf

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)

.org 0x00524a01 - 0x401000
.globl FUN_00524a01
FUN_00524a01:
    # block 0x00524a01: entry, 13 instruction(s), calls USER32.dll!GetMenuCheckMarkDimensions, ends with jle to 0x00524a27 (forward)
    push ebp                                     # 00524a01
    {load} mov ebp, esp                          # 00524a02
    sub esp, 0x90                                # 00524a04
    push ebx                                     # 00524a0a
    push esi                                     # 00524a0b
    push edi                                     # 00524a0c
    call dword ptr [0x52a350]                    # 00524a0d
    movsx ebx, ax                                # 00524a13
    shr eax, 0x10                                # 00524a16
    movsx ecx, ax                                # 00524a19
    cmp ebx, 0x20                                # 00524a1c
    mov dword ptr [ebp - local_c], ecx           # 00524a1f
    jle.d8 L_00524a27                            # 00524a22
    # block 0x00524a24: entered by fall-through of jle at 0x00524a22, 2 instruction(s), falls into the block at 0x00524a27
    push 0x20                                    # 00524a24
    pop ebx                                      # 00524a26
L_00524a27:
    # block 0x00524a27: entered by jle at 0x00524a22, 13 instruction(s), ends with jle to 0x00524a48 (forward)
    lea eax, [ebx - field_minus_4]               # 00524a27
    lea esi, [ebx + field_f]                     # 00524a2a
    cdq                                          # 00524a2d
    {load} sub eax, edx                          # 00524a2e
    sar esi, 0x4                                 # 00524a30
    {load} mov edi, eax                          # 00524a33
    {load} mov eax, esi                          # 00524a35
    sar edi                                      # 00524a37
    shl eax, 0x4                                 # 00524a39
    {load} add edi, eax                          # 00524a3c
    {load} sub edi, ebx                          # 00524a3e
    cmp edi, 0xc                                 # 00524a40
    jle.d8 L_00524a48                            # 00524a43
    # block 0x00524a45: entered by fall-through of jle at 0x00524a43, 2 instruction(s), falls into the block at 0x00524a48
    push 0xc                                     # 00524a45
    pop edi                                      # 00524a47
L_00524a48:
    # block 0x00524a48: entered by jle at 0x00524a43, 4 instruction(s), ends with jle to 0x00524a52 (forward)
    push 0x20                                    # 00524a48
    pop eax                                      # 00524a4a
    {load} cmp ecx, eax                          # 00524a4b
    jle.d8 L_00524a52                            # 00524a4d
    # block 0x00524a4f: entered by fall-through of jle at 0x00524a4d, 1 instruction(s), falls into the block at 0x00524a52
    mov dword ptr [ebp - local_c], eax           # 00524a4f
L_00524a52:
    # block 0x00524a52: entered by jle at 0x00524a4d, 14 instruction(s), calls FUN_0050f920, falls into the block at 0x00524a8d
    push 0x80                                    # 00524a52
    lea eax, [ebp - local_90]                    # 00524a57
    push 0xff                                    # 00524a5d
    push eax                                     # 00524a62
    call FUN_0050f920                            # 00524a63
    mov eax, dword ptr [ebp - local_c]           # 00524a68
    add esp, 0xc                                 # 00524a6b
    add eax, -0x6                                # 00524a6e
    mov dword ptr [ebp - local_4], 0x52ec64      # 00524a71
    sar eax                                      # 00524a78
    imul eax, esi                                # 00524a7a
    {load} add esi, esi                          # 00524a7d
    mov dword ptr [ebp - local_8], 0x5           # 00524a7f
    lea edx, [ebp + 2*eax - local_90]            # 00524a86
L_00524a8d:
    # block 0x00524a8d: entered by jne at 0x00524aab, 13 instruction(s), ends with jne to 0x00524a8d (backward)
    mov eax, dword ptr [ebp - local_4]           # 00524a8d
    {load} mov ecx, edi                          # 00524a90
    movzx ax, byte ptr [eax]                     # 00524a92
    shl eax, cl                                  # 00524a96
    inc dword ptr [ebp - local_4]                # 00524a98
    {load} xor ecx, ecx                          # 00524a9b
    not eax                                      # 00524a9d
    {load} mov cl, ah                            # 00524a9f
    mov byte ptr [edx + field_1], al             # 00524aa1
    mov byte ptr [edx], cl                       # 00524aa4
    {load} add edx, esi                          # 00524aa6
    dec dword ptr [ebp - local_8]                # 00524aa8
    jne.d8 L_00524a8d                            # 00524aab
    # block 0x00524aad: entered by fall-through of jne at 0x00524aab, 13 instruction(s), calls GDI32.dll!CreateBitmap, ends with jne to 0x00524adf (forward)
    lea eax, [ebp - local_90]                    # 00524aad
    push eax                                     # 00524ab3
    push 0x1                                     # 00524ab4
    push 0x1                                     # 00524ab6
    push dword ptr [ebp - local_c]               # 00524ab8
    push ebx                                     # 00524abb
    call dword ptr [0x52a05c]                    # 00524abc
    pop edi                                      # 00524ac2
    pop esi                                      # 00524ac3
    test eax, eax                                # 00524ac4
    mov dword ptr [0x63c798], eax                # 00524ac6
    pop ebx                                      # 00524acb
    jne.d8 L_00524adf                            # 00524acc
    # block 0x00524ace: entered by fall-through of jne at 0x00524acc, 4 instruction(s), calls USER32.dll!LoadBitmapA, falls into the block at 0x00524adf
    push 0x7fe3                                  # 00524ace
    push eax                                     # 00524ad3
    call dword ptr [0x52a34c]                    # 00524ad4
    mov dword ptr [0x63c798], eax                # 00524ada
L_00524adf:
    # block 0x00524adf: entered by jne at 0x00524acc, 2 instruction(s), ends with ret
    leave                                        # 00524adf
    ret                                          # 00524ae0

