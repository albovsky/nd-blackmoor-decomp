# FUN_005269a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005269a5
# extent:       0x005269a5-0x00526a5a (181 code bytes)
# span:         0x005269a5-0x00526a60 (code 181, tables 0, padding 6)
# sha256:       d31f31aaa522f8778150d271981d7b90bce690efd4695aee602964effdbacbbe
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005269a5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_14, field_54, field_b8; [edi + n] field_1; [esi + n] field_2c, field_30, field_cc
# callees:      calls FUN_00525371, FUN_00525ffa, FUN_0050fde2, USER32.dll!UnregisterClassA, FUN_0052606a, FUN_0052513f; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_54, 0x54  # offset +0x54
.equ field_b8, 0xb8  # offset +0xb8
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------
.set FUN_0050fde2, .text + (0x0050fde2 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x005269a5 - 0x401000
.globl FUN_005269a5
FUN_005269a5:
    # block 0x005269a5: entry, 11 instruction(s), calls FUN_00525371, FUN_00525ffa, falls into the block at 0x005269be
    push ebx                                     # 005269a5
    push ebp                                     # 005269a6
    push esi                                     # 005269a7
    push edi                                     # 005269a8
    call FUN_00525371                            # 005269a9
    push 0x1                                     # 005269ae
    {load} mov ebp, eax                          # 005269b0
    call FUN_00525ffa                            # 005269b2
    add ebp, 0x34                                # 005269b7
    {load} xor ebx, ebx                          # 005269ba
    {load} mov esi, ebp                          # 005269bc
L_005269be:
    # block 0x005269be: entered by jmp at 0x005269e2, 2 instruction(s), ends with je to 0x005269e4 (forward)
    cmp byte ptr [esi], bl                       # 005269be
    je.d8 L_005269e4                             # 005269c0
    # block 0x005269c2: entered by fall-through of je at 0x005269c0, 13 instruction(s), calls FUN_0050fde2, FUN_00525371, USER32.dll!UnregisterClassA, ends with backward jump to 0x005269be
    push 0xa                                     # 005269c2
    push esi                                     # 005269c4
    call FUN_0050fde2                            # 005269c5
    pop ecx                                      # 005269ca
    {load} mov edi, eax                          # 005269cb
    pop ecx                                      # 005269cd
    mov byte ptr [edi], bl                       # 005269ce
    call FUN_00525371                            # 005269d0
    push dword ptr [eax + field_8]               # 005269d5
    push esi                                     # 005269d8
    call dword ptr [0x52a4dc]                    # 005269d9
    lea esi, [edi + field_1]                     # 005269df
    jmp.d8 L_005269be                            # 005269e2
L_005269e4:
    # block 0x005269e4: entered by je at 0x005269c0, 7 instruction(s), calls FUN_0052606a, FUN_00525371, ends with je to 0x00526a06 (forward)
    push 0x1                                     # 005269e4
    {disp8} mov byte ptr [ebp], bl               # 005269e6
    call FUN_0052606a                            # 005269e9
    call FUN_00525371                            # 005269ee
    mov eax, dword ptr [eax + field_4]           # 005269f3
    {load} cmp eax, ebx                          # 005269f6
    je.d8 L_00526a06                             # 005269f8
    # block 0x005269fa: entered by fall-through of je at 0x005269f8, 3 instruction(s), ends with je to 0x00526a06 (forward)
    mov eax, dword ptr [eax + field_54]          # 005269fa
    {load} cmp eax, ebx                          # 005269fd
    je.d8 L_00526a06                             # 005269ff
    # block 0x00526a01: entered by fall-through of je at 0x005269ff, 3 instruction(s), calls indirect eax, falls into the block at 0x00526a06
    push ebx                                     # 00526a01
    push 0x1                                     # 00526a02
    call eax                                     # 00526a04
L_00526a06:
    # block 0x00526a06: entered by je at 0x005269f8; je at 0x005269ff, 6 instruction(s), calls FUN_0052513f, ends with je to 0x00526a2b (forward)
    call FUN_0052513f                            # 00526a06
    {load} mov esi, eax                          # 00526a0b
    mov ecx, dword ptr [esi + field_cc]          # 00526a0d
    lea edi, [esi + field_cc]                    # 00526a13
    {load} cmp ecx, ebx                          # 00526a19
    je.d8 L_00526a2b                             # 00526a1b
    # block 0x00526a1d: entered by fall-through of je at 0x00526a1b, 4 instruction(s), calls indirect dword ptr [eax + 0xb8], ends with je to 0x00526a2b (forward)
    mov eax, dword ptr [ecx]                     # 00526a1d
    call dword ptr [eax + field_b8]              # 00526a1f
    test eax, eax                                # 00526a25
    je.d8 L_00526a2b                             # 00526a27
    # block 0x00526a29: entered by fall-through of je at 0x00526a27, 1 instruction(s), falls into the block at 0x00526a2b
    mov dword ptr [edi], ebx                     # 00526a29
L_00526a2b:
    # block 0x00526a2b: entered by je at 0x00526a1b; je at 0x00526a27, 3 instruction(s), calls FUN_00525371, ends with jne to 0x00526a55 (forward)
    call FUN_00525371                            # 00526a2b
    cmp byte ptr [eax + field_14], bl            # 00526a30
    jne.d8 L_00526a55                            # 00526a33
    # block 0x00526a35: entered by fall-through of jne at 0x00526a33, 4 instruction(s), ends with je to 0x00526a48 (forward)
    mov eax, dword ptr [esi + field_30]          # 00526a35
    mov edi, dword ptr [0x52a42c]                # 00526a38
    {load} cmp eax, ebx                          # 00526a3e
    je.d8 L_00526a48                             # 00526a40
    # block 0x00526a42: entered by fall-through of je at 0x00526a40, 3 instruction(s), calls indirect edi, falls into the block at 0x00526a48
    push eax                                     # 00526a42
    call edi                                     # 00526a43
    mov dword ptr [esi + field_30], ebx          # 00526a45
L_00526a48:
    # block 0x00526a48: entered by je at 0x00526a40, 3 instruction(s), ends with je to 0x00526a55 (forward)
    mov eax, dword ptr [esi + field_2c]          # 00526a48
    {load} cmp eax, ebx                          # 00526a4b
    je.d8 L_00526a55                             # 00526a4d
    # block 0x00526a4f: entered by fall-through of je at 0x00526a4d, 3 instruction(s), calls indirect edi, falls into the block at 0x00526a55
    push eax                                     # 00526a4f
    call edi                                     # 00526a50
    mov dword ptr [esi + field_2c], ebx          # 00526a52
L_00526a55:
    # block 0x00526a55: entered by jne at 0x00526a33; je at 0x00526a4d, 5 instruction(s), ends with ret
    pop edi                                      # 00526a55
    pop esi                                      # 00526a56
    pop ebp                                      # 00526a57
    pop ebx                                      # 00526a58
    ret                                          # 00526a59

# --- data items (not part of the function) -------------------------
.org 0x00526a5a - 0x401000
PAD_00526a5a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

