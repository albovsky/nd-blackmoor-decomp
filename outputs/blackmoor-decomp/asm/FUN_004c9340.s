# FUN_004c9340
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9340
# extent:       0x004c9340-0x004c9428 (232 code bytes)
# span:         0x004c9340-0x004c9428 (code 232, tables 0, padding 0)
# sha256:       4a4721e5c84c8300e2effe161ea07978119bedc7e39853988e7a15fe171c7b97
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sheet_color_key_scan
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_layout_internal.h:37 says "0x4c9340: first sheet word in the inclusive rectangle that is not the"; src/caption_layout.c:398 says "0x4c9340: first non-key word in a sheet rectangle, else 0."
# name-note:    Returns the first sheet word in an inclusive rectangle that is not the colour key, else 0.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_4, field_2f; [ecx + n] field_38d0; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_2f, 0x2f  # offset +0x2f
.equ field_38d0, 0x38d0  # offset +0x38d0

# --- external targets -----------------------------------------------

.org 0x004c9340 - 0x401000
.globl FUN_004c9340
FUN_004c9340:
    # block 0x004c9340: entry, 6 instruction(s), ends with jne to 0x004c9357 (forward)
    push ebp                                     # 004c9340
    {load} mov ebp, esp                          # 004c9341
    sub esp, 0x20                                # 004c9343
    mov dword ptr [ebp - local_20], ecx          # 004c9346
    cmp dword ptr [ebp + arg_8], 0x0             # 004c9349
    jne.d8 L_004c9357                            # 004c934d
    # block 0x004c934f: entered by fall-through of jne at 0x004c934d, 2 instruction(s), ends with forward jump to 0x004c9422
    {load} xor ax, ax                            # 004c934f
    jmp.d32 L_004c9422                           # 004c9352
L_004c9357:
    # block 0x004c9357: entered by jne at 0x004c934d, 31 instruction(s), ends with forward jump to 0x004c93c5
    mov eax, dword ptr [ebp + arg_8]             # 004c9357
    movsx ecx, word ptr [eax + field_2f]         # 004c935a
    mov dword ptr [ebp - local_10], ecx          # 004c935e
    mov edx, dword ptr [ebp + arg_c]             # 004c9361
    mov eax, dword ptr [edx + field_4]           # 004c9364
    imul eax, dword ptr [ebp - local_10]         # 004c9367
    mov ecx, dword ptr [ebp + arg_8]             # 004c936b
    mov edx, dword ptr [ecx]                     # 004c936e
    {load} add edx, eax                          # 004c9370
    movsx eax, word ptr [0x639895]               # 004c9372
    mov ecx, dword ptr [ebp + arg_c]             # 004c9379
    mov ecx, dword ptr [ecx]                     # 004c937c
    imul ecx, eax                                # 004c937e
    {load} add edx, ecx                          # 004c9381
    mov dword ptr [ebp - local_4], edx           # 004c9383
    mov edx, dword ptr [ebp + arg_c]             # 004c9386
    mov eax, dword ptr [ebp + arg_c]             # 004c9389
    mov ecx, dword ptr [edx + field_c]           # 004c938c
    sub ecx, dword ptr [eax + field_4]           # 004c938f
    add ecx, 0x1                                 # 004c9392
    mov dword ptr [ebp - local_14], ecx          # 004c9395
    mov edx, dword ptr [ebp + arg_c]             # 004c9398
    mov eax, dword ptr [ebp + arg_c]             # 004c939b
    mov ecx, dword ptr [edx + field_8]           # 004c939e
    sub ecx, dword ptr [eax]                     # 004c93a1
    add ecx, 0x1                                 # 004c93a3
    movsx edx, word ptr [0x639895]               # 004c93a6
    imul ecx, edx                                # 004c93ad
    mov dword ptr [ebp - local_8], ecx           # 004c93b0
    mov dword ptr [ebp - local_18], 0x0          # 004c93b3
    jmp.d8 L_004c93c5                            # 004c93ba
L_004c93bc:
    # block 0x004c93bc: entered by jmp at 0x004c941d, 3 instruction(s), falls into the block at 0x004c93c5
    mov eax, dword ptr [ebp - local_18]          # 004c93bc
    add eax, 0x1                                 # 004c93bf
    mov dword ptr [ebp - local_18], eax          # 004c93c2
L_004c93c5:
    # block 0x004c93c5: entered by jmp at 0x004c93ba, 3 instruction(s), ends with jge to 0x004c941f (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004c93c5
    cmp ecx, dword ptr [ebp - local_14]          # 004c93c8
    jge.d8 L_004c941f                            # 004c93cb
    # block 0x004c93cd: entered by fall-through of jge at 0x004c93cb, 2 instruction(s), ends with forward jump to 0x004c93df
    mov dword ptr [ebp - local_c], 0x0           # 004c93cd
    jmp.d8 L_004c93df                            # 004c93d4
L_004c93d6:
    # block 0x004c93d6: entered by jmp at 0x004c9412, 3 instruction(s), falls into the block at 0x004c93df
    mov edx, dword ptr [ebp - local_c]           # 004c93d6
    add edx, 0x2                                 # 004c93d9
    mov dword ptr [ebp - local_c], edx           # 004c93dc
L_004c93df:
    # block 0x004c93df: entered by jmp at 0x004c93d4, 3 instruction(s), ends with jge to 0x004c9414 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c93df
    cmp eax, dword ptr [ebp - local_8]           # 004c93e2
    jge.d8 L_004c9414                            # 004c93e5
    # block 0x004c93e7: entered by fall-through of jge at 0x004c93e5, 11 instruction(s), ends with je to 0x004c9412 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c93e7
    add ecx, dword ptr [ebp - local_c]           # 004c93ea
    mov dx, word ptr [ecx]                       # 004c93ed
    mov word ptr [ebp - local_1c], dx            # 004c93f0
    mov eax, dword ptr [ebp - local_1c]          # 004c93f4
    and eax, 0xffff                              # 004c93f7
    mov ecx, dword ptr [ebp - local_20]          # 004c93fc
    {load} xor edx, edx                          # 004c93ff
    mov dx, word ptr [ecx + field_38d0]          # 004c9401
    {load} cmp eax, edx                          # 004c9408
    je.d8 L_004c9412                             # 004c940a
    # block 0x004c940c: entered by fall-through of je at 0x004c940a, 2 instruction(s), ends with forward jump to 0x004c9422
    mov ax, word ptr [ebp - local_1c]            # 004c940c
    jmp.d8 L_004c9422                            # 004c9410
L_004c9412:
    # block 0x004c9412: entered by je at 0x004c940a, 1 instruction(s), ends with backward jump to 0x004c93d6
    jmp.d8 L_004c93d6                            # 004c9412
L_004c9414:
    # block 0x004c9414: entered by jge at 0x004c93e5, 4 instruction(s), ends with backward jump to 0x004c93bc
    mov eax, dword ptr [ebp - local_4]           # 004c9414
    add eax, dword ptr [ebp - local_10]          # 004c9417
    mov dword ptr [ebp - local_4], eax           # 004c941a
    jmp.d8 L_004c93bc                            # 004c941d
L_004c941f:
    # block 0x004c941f: entered by jge at 0x004c93cb, 1 instruction(s), falls into the block at 0x004c9422
    {load} xor ax, ax                            # 004c941f
L_004c9422:
    # block 0x004c9422: entered by jmp at 0x004c9352; jmp at 0x004c9410, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004c9422
    pop ebp                                      # 004c9424
    ret 0x8                                      # 004c9425

