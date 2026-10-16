# FUN_004f861c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f861c
# extent:       0x004f861c-0x004f872e (274 code bytes)
# span:         0x004f861c-0x004f872e (code 274, tables 0, padding 0)
# sha256:       37bfb3ae88145ce1883ca9f0459cb775d4aaeb23896c1b7bb6662b1869a4c6d8
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f861c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_38, field_19c, field_240, field_244, field_3ca, field_3d2; [ecx + n] field_19c, field_240, field_248, field_3ca; [edx + n] field_240, field_244, field_248, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_38, 0x38  # offset +0x38
.equ field_19c, 0x19c  # offset +0x19c
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f861c - 0x401000
.globl FUN_004f861c
FUN_004f861c:
    # block 0x004f861c: entry, 9 instruction(s), ends with je to 0x004f8726 (forward)
    push ebp                                     # 004f861c
    {load} mov ebp, esp                          # 004f861d
    push ecx                                     # 004f861f
    mov dword ptr [ebp - local_4], ecx           # 004f8620
    mov eax, dword ptr [ebp - local_4]           # 004f8623
    mov dword ptr [eax + field_3ca], 0x0         # 004f8626
    mov ecx, dword ptr [ebp - local_4]           # 004f8630
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8633
    je.d32 L_004f8726                            # 004f863a
    # block 0x004f8640: entered by fall-through of je at 0x004f863a, 3 instruction(s), ends with je to 0x004f8653 (forward)
    {load} xor edx, edx                          # 004f8640
    test edx, edx                                # 004f8642
    je.d8 L_004f8653                             # 004f8644
    # block 0x004f8646: entered by fall-through of je at 0x004f8644, 2 instruction(s), falls into the block at 0x004f8653
    mov eax, dword ptr [ebp - local_4]           # 004f8646
    mov dword ptr [eax + field_3d2], 0x1         # 004f8649
L_004f8653:
    # block 0x004f8653: entered by je at 0x004f8644, 31 instruction(s), calls indirect dword ptr [eax + 0x38], ends with jne to 0x004f8722 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8653
    mov edx, dword ptr [ebp + arg_8]             # 004f8656
    mov dword ptr [ecx + field_240], edx         # 004f8659
    mov eax, dword ptr [ebp - local_4]           # 004f865f
    mov ecx, dword ptr [ebp + arg_c]             # 004f8662
    mov dword ptr [eax + field_244], ecx         # 004f8665
    mov edx, dword ptr [ebp - local_4]           # 004f866b
    mov eax, dword ptr [ebp + arg_10]            # 004f866e
    mov dword ptr [edx + field_248], eax         # 004f8671
    push 0x0                                     # 004f8677
    mov ecx, dword ptr [ebp - local_4]           # 004f8679
    mov edx, dword ptr [ecx + field_248]         # 004f867c
    push edx                                     # 004f8682
    mov eax, dword ptr [ebp - local_4]           # 004f8683
    mov ecx, dword ptr [eax + field_244]         # 004f8686
    push ecx                                     # 004f868c
    mov edx, dword ptr [ebp - local_4]           # 004f868d
    mov eax, dword ptr [edx + field_240]         # 004f8690
    push eax                                     # 004f8696
    mov ecx, dword ptr [ebp - local_4]           # 004f8697
    mov edx, dword ptr [ecx + field_19c]         # 004f869a
    mov eax, dword ptr [ebp - local_4]           # 004f86a0
    mov ecx, dword ptr [eax + field_19c]         # 004f86a3
    mov eax, dword ptr [ecx]                     # 004f86a9
    push edx                                     # 004f86ab
    call dword ptr [eax + field_38]              # 004f86ac
    mov ecx, dword ptr [ebp - local_4]           # 004f86af
    mov dword ptr [ecx + field_3ca], eax         # 004f86b2
    mov edx, dword ptr [ebp - local_4]           # 004f86b8
    cmp dword ptr [edx + field_3ca], 0x0         # 004f86bb
    jne.d8 L_004f8722                            # 004f86c2
    # block 0x004f86c4: entered by fall-through of jne at 0x004f86c2, 3 instruction(s), ends with je to 0x004f871b (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f86c4
    test eax, eax                                # 004f86cb
    je.d8 L_004f871b                             # 004f86cd
    # block 0x004f86cf: entered by fall-through of je at 0x004f86cd, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f871b
    mov ecx, dword ptr [ebp - local_4]           # 004f86cf
    fld dword ptr [ecx + field_248]              # 004f86d2
    sub esp, 0x8                                 # 004f86d8
    fstp qword ptr [esp]                         # 004f86db
    mov edx, dword ptr [ebp - local_4]           # 004f86de
    fld dword ptr [edx + field_244]              # 004f86e1
    sub esp, 0x8                                 # 004f86e7
    fstp qword ptr [esp]                         # 004f86ea
    mov eax, dword ptr [ebp - local_4]           # 004f86ed
    fld dword ptr [eax + field_240]              # 004f86f0
    sub esp, 0x8                                 # 004f86f6
    fstp qword ptr [esp]                         # 004f86f9
    push 0x55eebc                                # 004f86fc
    push 0x63888b                                # 004f8701
    call FUN_0050ca3e                            # 004f8706
    add esp, 0x20                                # 004f870b
    push 0x63888b                                # 004f870e
    call FUN_0044a2b7                            # 004f8713
    add esp, 0x4                                 # 004f8718
L_004f871b:
    # block 0x004f871b: entered by je at 0x004f86cd, 2 instruction(s), ends with forward jump to 0x004f8728
    mov eax, 0x1                                 # 004f871b
    jmp.d8 L_004f8728                            # 004f8720
L_004f8722:
    # block 0x004f8722: entered by jne at 0x004f86c2, 2 instruction(s), ends with forward jump to 0x004f8728
    {load} xor eax, eax                          # 004f8722
    jmp.d8 L_004f8728                            # 004f8724
L_004f8726:
    # block 0x004f8726: entered by je at 0x004f863a, 1 instruction(s), falls into the block at 0x004f8728
    {load} xor eax, eax                          # 004f8726
L_004f8728:
    # block 0x004f8728: entered by jmp at 0x004f8720; jmp at 0x004f8724, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004f8728
    pop ebp                                      # 004f872a
    ret 0xc                                      # 004f872b

