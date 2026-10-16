# FUN_005257a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005257a8
# extent:       0x005257a8-0x005258ba (274 code bytes)
# span:         0x005257a8-0x005258ba (code 274, tables 0, padding 0)
# sha256:       979bf57a6984be9ecaf5a34b3318f57c76375c63b43a46ae0ac017dd984e9e44
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005257a8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_1; [esi + n] field_4, field_8, field_c, field_10, field_1c; [esp + n] stk_10, stk_14
# callees:      calls KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!GlobalAlloc, KERNEL32.dll!GlobalHandle, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalReAlloc, KERNEL32.dll!LeaveCriticalSection, FUN_00519cc0, FUN_0050f920; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 99 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)

.org 0x005257a8 - 0x401000
.globl FUN_005257a8
FUN_005257a8:
    # block 0x005257a8: entry, 14 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with jge to 0x005257d4 (forward)
    push ecx                                     # 005257a8
    push ecx                                     # 005257a9
    push ebp                                     # 005257aa
    push esi                                     # 005257ab
    {load} mov esi, ecx                          # 005257ac
    push edi                                     # 005257ae
    lea eax, [esi + field_1c]                    # 005257af
    push eax                                     # 005257b2
    mov dword ptr [esp + stk_14], eax            # 005257b3
    call dword ptr [0x52a0d0]                    # 005257b7
    mov ebp, dword ptr [esi + field_4]           # 005257bd
    mov edi, dword ptr [esi + field_8]           # 005257c0
    {load} cmp edi, ebp                          # 005257c3
    jge.d8 L_005257d4                            # 005257c5
    # block 0x005257c7: entered by fall-through of jge at 0x005257c5, 3 instruction(s), ends with je to 0x0052588d (forward)
    mov eax, dword ptr [esi + field_10]          # 005257c7
    test byte ptr [eax + 8*edi], 0x1             # 005257ca
    je.d32 L_0052588d                            # 005257ce
L_005257d4:
    # block 0x005257d4: entered by jge at 0x005257c5; fall-through of je at 0x005257ce, 4 instruction(s), ends with jle to 0x005257f6 (forward)
    push 0x1                                     # 005257d4
    pop edi                                      # 005257d6
    {load} cmp ebp, edi                          # 005257d7
    jle.d8 L_005257f6                            # 005257d9
    # block 0x005257db: entered by fall-through of jle at 0x005257d9, 2 instruction(s), falls into the block at 0x005257e1
    mov eax, dword ptr [esi + field_10]          # 005257db
    add eax, 0x8                                 # 005257de
L_005257e1:
    # block 0x005257e1: entered by jl at 0x005257ec, 2 instruction(s), ends with je to 0x005257ee (forward)
    test byte ptr [eax], 0x1                     # 005257e1
    je.d8 L_005257ee                             # 005257e4
    # block 0x005257e6: entered by fall-through of je at 0x005257e4, 4 instruction(s), ends with jl to 0x005257e1 (backward)
    inc edi                                      # 005257e6
    add eax, 0x8                                 # 005257e7
    {load} cmp edi, ebp                          # 005257ea
    jl.d8 L_005257e1                             # 005257ec
L_005257ee:
    # block 0x005257ee: entered by je at 0x005257e4; fall-through of jl at 0x005257ec, 2 instruction(s), ends with jl to 0x0052588d (forward)
    {load} cmp edi, ebp                          # 005257ee
    jl.d32 L_0052588d                            # 005257f0
L_005257f6:
    # block 0x005257f6: entered by jle at 0x005257d9; fall-through of jl at 0x005257f0, 5 instruction(s), ends with jne to 0x00525814 (forward)
    mov eax, dword ptr [esi + field_10]          # 005257f6
    add ebp, 0x20                                # 005257f9
    test eax, eax                                # 005257fc
    push ebx                                     # 005257fe
    jne.d8 L_00525814                            # 005257ff
    # block 0x00525801: entered by fall-through of jne at 0x005257ff, 6 instruction(s), calls KERNEL32.dll!GlobalAlloc, ends with forward jump to 0x00525836
    {load} mov eax, ebp                          # 00525801
    shl eax, 0x3                                 # 00525803
    push eax                                     # 00525806
    push 0x2002                                  # 00525807
    call dword ptr [0x52a1dc]                    # 0052580c
    jmp.d8 L_00525836                            # 00525812
L_00525814:
    # block 0x00525814: entered by jne at 0x005257ff, 11 instruction(s), calls KERNEL32.dll!GlobalHandle, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalReAlloc, falls into the block at 0x00525836
    push eax                                     # 00525814
    call dword ptr [0x52a0c0]                    # 00525815
    {load} mov ebx, eax                          # 0052581b
    push ebx                                     # 0052581d
    call dword ptr [0x52a208]                    # 0052581e
    {load} mov eax, ebp                          # 00525824
    push 0x2002                                  # 00525826
    shl eax, 0x3                                 # 0052582b
    push eax                                     # 0052582e
    push ebx                                     # 0052582f
    call dword ptr [0x52a0cc]                    # 00525830
L_00525836:
    # block 0x00525836: entered by jmp at 0x00525812, 4 instruction(s), ends with jne to 0x0052585f (forward)
    mov ebx, dword ptr [0x52a204]                # 00525836
    mov dword ptr [esp + stk_10], eax            # 0052583c
    test eax, eax                                # 00525840
    jne.d8 L_0052585f                            # 00525842
    # block 0x00525844: entered by fall-through of jne at 0x00525842, 7 instruction(s), calls KERNEL32.dll!GlobalHandle, indirect ebx, KERNEL32.dll!LeaveCriticalSection, FUN_00519cc0, falls into the block at 0x0052585f
    push dword ptr [esi + field_10]              # 00525844
    call dword ptr [0x52a0c0]                    # 00525847
    push eax                                     # 0052584d
    call ebx                                     # 0052584e
    push dword ptr [esp + stk_14]                # 00525850
    call dword ptr [0x52a0c8]                    # 00525854
    call FUN_00519cc0                            # 0052585a
L_0052585f:
    # block 0x0052585f: entered by jne at 0x00525842, 17 instruction(s), calls indirect ebx, FUN_0050f920, falls into the block at 0x0052588d
    push dword ptr [esp + stk_10]                # 0052585f
    call ebx                                     # 00525863
    {load} mov ebx, eax                          # 00525865
    mov eax, dword ptr [esi + field_4]           # 00525867
    {load} mov ecx, eax                          # 0052586a
    imul ecx, ecx, 0x1fffffff                    # 0052586c
    {load} add ecx, ebp                          # 00525872
    lea eax, [ebx + 8*eax]                       # 00525874
    shl ecx, 0x3                                 # 00525877
    push ecx                                     # 0052587a
    push 0x0                                     # 0052587b
    push eax                                     # 0052587d
    call FUN_0050f920                            # 0052587e
    add esp, 0xc                                 # 00525883
    mov dword ptr [esi + field_10], ebx          # 00525886
    mov dword ptr [esi + field_4], ebp           # 00525889
    pop ebx                                      # 0052588c
L_0052588d:
    # block 0x0052588d: entered by je at 0x005257ce; jl at 0x005257f0, 2 instruction(s), ends with jl to 0x00525898 (forward)
    cmp edi, dword ptr [esi + field_c]           # 0052588d
    jl.d8 L_00525898                             # 00525890
    # block 0x00525892: entered by fall-through of jl at 0x00525890, 2 instruction(s), falls into the block at 0x00525898
    lea eax, [edi + field_1]                     # 00525892
    mov dword ptr [esi + field_c], eax           # 00525895
L_00525898:
    # block 0x00525898: entered by jl at 0x00525890, 14 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    mov eax, dword ptr [esi + field_10]          # 00525898
    or dword ptr [eax + 8*edi], 0x1              # 0052589b
    push dword ptr [esp + stk_10]                # 0052589f
    lea eax, [eax + 8*edi]                       # 005258a3
    lea eax, [edi + field_1]                     # 005258a6
    mov dword ptr [esi + field_8], eax           # 005258a9
    call dword ptr [0x52a0c8]                    # 005258ac
    {load} mov eax, edi                          # 005258b2
    pop edi                                      # 005258b4
    pop esi                                      # 005258b5
    pop ebp                                      # 005258b6
    pop ecx                                      # 005258b7
    pop ecx                                      # 005258b8
    ret                                          # 005258b9

