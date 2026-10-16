# FUN_0050a8e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a8e0
# extent:       0x0050a8e0-0x0050a99c (188 code bytes)
# span:         0x0050a8e0-0x0050a9a0 (code 188, tables 0, padding 4)
# sha256:       cd63e365b3dd45aace9442e944273efe233be88e10e33b4eac2f1462ba47e86a
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a8e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_1, field_minus_1; [ebx + n] field_1; [esi + n] field_minus_4; [esp + n] stk_c, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0050a8e0 - 0x401000
.globl FUN_0050a8e0
FUN_0050a8e0:
    # block 0x0050a8e0: entry, 22 instruction(s), ends with jge to 0x0050a919 (forward)
    mov ecx, dword ptr [esp + stk_c]             # 0050a8e0
    push ebx                                     # 0050a8e4
    push ebp                                     # 0050a8e5
    push esi                                     # 0050a8e6
    mov esi, dword ptr [esp + stk_1c]            # 0050a8e7
    mov ebx, dword ptr [esp + stk_10]            # 0050a8eb
    {load} sub esi, ecx                          # 0050a8ef
    mov ecx, dword ptr [esp + stk_14]            # 0050a8f1
    {load} mov eax, esi                          # 0050a8f5
    push edi                                     # 0050a8f7
    cdq                                          # 0050a8f8
    {load} xor eax, edx                          # 0050a8f9
    {load} mov edi, ecx                          # 0050a8fb
    {load} sub eax, edx                          # 0050a8fd
    {load} sub edi, ebx                          # 0050a8ff
    mov dword ptr [esp + stk_20], eax            # 0050a901
    {load} mov eax, esi                          # 0050a905
    cdq                                          # 0050a907
    idiv edi                                     # 0050a908
    test esi, esi                                # 0050a90a
    {load} mov ebp, eax                          # 0050a90c
    jge.d8 L_0050a919                            # 0050a90e
    # block 0x0050a910: entered by fall-through of jge at 0x0050a90e, 3 instruction(s), ends with forward jump to 0x0050a920
    lea eax, [ebp - field_minus_1]               # 0050a910
    mov dword ptr [esp + stk_14], eax            # 0050a913
    jmp.d8 L_0050a920                            # 0050a917
L_0050a919:
    # block 0x0050a919: entered by jge at 0x0050a90e, 2 instruction(s), falls into the block at 0x0050a920
    lea edx, [ebp + field_1]                     # 0050a919
    mov dword ptr [esp + stk_14], edx            # 0050a91c
L_0050a920:
    # block 0x0050a920: entered by jmp at 0x0050a917, 18 instruction(s), ends with jge to 0x0050a997 (forward)
    {load} mov eax, ebp                          # 0050a920
    mov esi, dword ptr [esp + stk_24]            # 0050a922
    imul eax, edi                                # 0050a926
    cdq                                          # 0050a929
    {load} xor eax, edx                          # 0050a92a
    mov dword ptr [esp + stk_18], 0x0            # 0050a92c
    {load} sub eax, edx                          # 0050a934
    mov edx, dword ptr [esp + stk_20]            # 0050a936
    {load} sub edx, eax                          # 0050a93a
    mov eax, dword ptr [esp + stk_1c]            # 0050a93c
    mov dword ptr [esp + stk_20], edx            # 0050a940
    fld dword ptr [4*eax + 0x566aa0]             # 0050a944
    fmul dword ptr [esi + 4*ebx]                 # 0050a94b
    lea edx, [4*eax + 0x566aa0]                  # 0050a94e
    lea eax, [ebx + field_1]                     # 0050a955
    {load} cmp eax, ecx                          # 0050a958
    fstp dword ptr [esi + 4*ebx]                 # 0050a95a
    jge.d8 L_0050a997                            # 0050a95d
    # block 0x0050a95f: entered by fall-through of jge at 0x0050a95d, 5 instruction(s), falls into the block at 0x0050a96e
    mov ebx, dword ptr [esp + stk_14]            # 0050a95f
    lea esi, [esi + 4*eax]                       # 0050a963
    shl ebp, 0x2                                 # 0050a966
    shl ebx, 0x2                                 # 0050a969
    {load} sub ecx, eax                          # 0050a96c
L_0050a96e:
    # block 0x0050a96e: entered by jne at 0x0050a995, 5 instruction(s), ends with jl to 0x0050a988 (forward)
    mov eax, dword ptr [esp + stk_18]            # 0050a96e
    add eax, dword ptr [esp + stk_20]            # 0050a972
    {load} cmp eax, edi                          # 0050a976
    mov dword ptr [esp + stk_18], eax            # 0050a978
    jl.d8 L_0050a988                             # 0050a97c
    # block 0x0050a97e: entered by fall-through of jl at 0x0050a97c, 4 instruction(s), ends with forward jump to 0x0050a98a
    {load} sub eax, edi                          # 0050a97e
    {load} add edx, ebx                          # 0050a980
    mov dword ptr [esp + stk_18], eax            # 0050a982
    jmp.d8 L_0050a98a                            # 0050a986
L_0050a988:
    # block 0x0050a988: entered by jl at 0x0050a97c, 1 instruction(s), falls into the block at 0x0050a98a
    {load} add edx, ebp                          # 0050a988
L_0050a98a:
    # block 0x0050a98a: entered by jmp at 0x0050a986, 6 instruction(s), ends with jne to 0x0050a96e (backward)
    fld dword ptr [edx]                          # 0050a98a
    fmul dword ptr [esi]                         # 0050a98c
    add esi, 0x4                                 # 0050a98e
    dec ecx                                      # 0050a991
    fstp dword ptr [esi - field_minus_4]         # 0050a992
    jne.d8 L_0050a96e                            # 0050a995
L_0050a997:
    # block 0x0050a997: entered by jge at 0x0050a95d; fall-through of jne at 0x0050a995, 5 instruction(s), ends with ret
    pop edi                                      # 0050a997
    pop esi                                      # 0050a998
    pop ebp                                      # 0050a999
    pop ebx                                      # 0050a99a
    ret                                          # 0050a99b

# --- data items (not part of the function) -------------------------
.org 0x0050a99c - 0x401000
PAD_0050a99c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

