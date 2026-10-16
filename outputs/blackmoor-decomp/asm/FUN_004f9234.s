# FUN_004f9234
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9234
# extent:       0x004f9234-0x004f9313 (223 code bytes)
# span:         0x004f9234-0x004f9313 (code 223, tables 0, padding 0)
# sha256:       d9c8b9cb72eb5aa891b2c76e833f5bfe7fc4df542a114265edf0f046aa975b97
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f9234
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_44, field_29b, field_3ca, field_3d2; [ecx + n] field_29b, field_2d3, field_3ca, field_3ce; [edx + n] field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_44, 0x44  # offset +0x44
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f9234 - 0x401000
.globl FUN_004f9234
FUN_004f9234:
    # block 0x004f9234: entry, 15 instruction(s), ends with je to 0x004f930b (forward)
    push ebp                                     # 004f9234
    {load} mov ebp, esp                          # 004f9235
    sub esp, 0x8                                 # 004f9237
    mov dword ptr [ebp - local_8], ecx           # 004f923a
    mov eax, dword ptr [ebp + arg_8]             # 004f923d
    imul eax, eax, 0x5bb                         # 004f9240
    mov ecx, dword ptr [ebp - local_8]           # 004f9246
    mov edx, dword ptr [ecx + field_3ce]         # 004f9249
    {load} add edx, eax                          # 004f924f
    mov dword ptr [ebp - local_4], edx           # 004f9251
    mov eax, dword ptr [ebp - local_8]           # 004f9254
    mov dword ptr [eax + field_3ca], 0x0         # 004f9257
    mov ecx, dword ptr [ebp - local_4]           # 004f9261
    cmp dword ptr [ecx + field_29b], 0x0         # 004f9264
    je.d32 L_004f930b                            # 004f926b
    # block 0x004f9271: entered by fall-through of je at 0x004f926b, 3 instruction(s), ends with je to 0x004f9284 (forward)
    {load} xor edx, edx                          # 004f9271
    test edx, edx                                # 004f9273
    je.d8 L_004f9284                             # 004f9275
    # block 0x004f9277: entered by fall-through of je at 0x004f9275, 2 instruction(s), falls into the block at 0x004f9284
    mov eax, dword ptr [ebp - local_8]           # 004f9277
    mov dword ptr [eax + field_3d2], 0x1         # 004f927a
L_004f9284:
    # block 0x004f9284: entered by je at 0x004f9275, 18 instruction(s), calls indirect dword ptr [eax + 0x44], ends with jne to 0x004f9307 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f9284
    mov edx, dword ptr [ebp + arg_c]             # 004f9287
    mov dword ptr [ecx + field_2d3], edx         # 004f928a
    push 0x0                                     # 004f9290
    mov eax, dword ptr [ebp + arg_c]             # 004f9292
    push eax                                     # 004f9295
    mov ecx, dword ptr [ebp - local_4]           # 004f9296
    mov edx, dword ptr [ecx + field_29b]         # 004f9299
    mov eax, dword ptr [ebp - local_4]           # 004f929f
    mov ecx, dword ptr [eax + field_29b]         # 004f92a2
    mov eax, dword ptr [ecx]                     # 004f92a8
    push edx                                     # 004f92aa
    call dword ptr [eax + field_44]              # 004f92ab
    mov ecx, dword ptr [ebp - local_8]           # 004f92ae
    mov dword ptr [ecx + field_3ca], eax         # 004f92b1
    mov edx, dword ptr [ebp - local_8]           # 004f92b7
    cmp dword ptr [edx + field_3ca], 0x0         # 004f92ba
    jne.d8 L_004f9307                            # 004f92c1
    # block 0x004f92c3: entered by fall-through of jne at 0x004f92c1, 3 instruction(s), ends with je to 0x004f9300 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f92c3
    test eax, eax                                # 004f92ca
    je.d8 L_004f9300                             # 004f92cc
    # block 0x004f92ce: entered by fall-through of je at 0x004f92cc, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9300
    mov ecx, dword ptr [ebp - local_4]           # 004f92ce
    fld dword ptr [ecx + field_2d3]              # 004f92d1
    sub esp, 0x8                                 # 004f92d7
    fstp qword ptr [esp]                         # 004f92da
    mov edx, dword ptr [ebp + arg_8]             # 004f92dd
    push edx                                     # 004f92e0
    push 0x55f124                                # 004f92e1
    push 0x63888b                                # 004f92e6
    call FUN_0050ca3e                            # 004f92eb
    add esp, 0x14                                # 004f92f0
    push 0x63888b                                # 004f92f3
    call FUN_0044a2b7                            # 004f92f8
    add esp, 0x4                                 # 004f92fd
L_004f9300:
    # block 0x004f9300: entered by je at 0x004f92cc, 2 instruction(s), ends with forward jump to 0x004f930d
    mov eax, 0x1                                 # 004f9300
    jmp.d8 L_004f930d                            # 004f9305
L_004f9307:
    # block 0x004f9307: entered by jne at 0x004f92c1, 2 instruction(s), ends with forward jump to 0x004f930d
    {load} xor eax, eax                          # 004f9307
    jmp.d8 L_004f930d                            # 004f9309
L_004f930b:
    # block 0x004f930b: entered by je at 0x004f926b, 1 instruction(s), falls into the block at 0x004f930d
    {load} xor eax, eax                          # 004f930b
L_004f930d:
    # block 0x004f930d: entered by jmp at 0x004f9305; jmp at 0x004f9309, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f930d
    pop ebp                                      # 004f930f
    ret 0x8                                      # 004f9310

