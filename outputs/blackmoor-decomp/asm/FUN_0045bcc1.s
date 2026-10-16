# FUN_0045bcc1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045bcc1
# extent:       0x0045bcc1-0x0045bda7 (230 code bytes)
# span:         0x0045bcc1-0x0045bda7 (code 230, tables 0, padding 0)
# sha256:       4fa61216e8097b07b065fcfd1ffb8c3414302db167e55d58916776a18fddc332
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045bcc1
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_b6, field_ec, field_178, field_40d, field_6e1; [ecx + n] field_4, field_8, field_c, field_17c; [edx + n] field_4, field_8, field_c, field_24, field_17a
# callees:      calls FUN_0045be7f, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ec, 0xec  # offset +0xec
.equ field_178, 0x178  # offset +0x178
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17c, 0x17c  # offset +0x17c
.equ field_40d, 0x40d  # offset +0x40d
.equ field_6e1, 0x6e1  # offset +0x6e1

# --- external targets -----------------------------------------------
.set FUN_0045be7f, .text + (0x0045be7f - 0x401000)

.org 0x0045bcc1 - 0x401000
.globl FUN_0045bcc1
FUN_0045bcc1:
    # block 0x0045bcc1: entry, 15 instruction(s), ends with jne to 0x0045bd9f (forward)
    push ebp                                     # 0045bcc1
    {load} mov ebp, esp                          # 0045bcc2
    sub esp, 0x8                                 # 0045bcc4
    mov dword ptr [ebp - local_8], ecx           # 0045bcc7
    mov eax, dword ptr [ebp - local_8]           # 0045bcca
    movsx ecx, word ptr [eax + field_1e]         # 0045bccd
    imul ecx, ecx, 0x8d                          # 0045bcd1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045bcd7
    mov dword ptr [ebp - local_4], edx           # 0045bcdd
    mov eax, dword ptr [ebp - local_8]           # 0045bce0
    movsx ecx, word ptr [eax + field_178]        # 0045bce3
    mov edx, dword ptr [ebp - local_8]           # 0045bcea
    movsx eax, word ptr [edx + field_17a]        # 0045bced
    {load} cmp ecx, eax                          # 0045bcf4
    jne.d32 L_0045bd9f                           # 0045bcf6
    # block 0x0045bcfc: entered by fall-through of jne at 0x0045bcf6, 41 instruction(s), calls FUN_0045be7f, KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045bda1
    mov cx, word ptr [ebp + arg_8]               # 0045bcfc
    push ecx                                     # 0045bd00
    push 0x4                                     # 0045bd01
    movsx edx, word ptr [ebp + arg_8]            # 0045bd03
    imul edx, edx, 0x2dc                         # 0045bd07
    mov eax, dword ptr [ebp - local_4]           # 0045bd0d
    lea ecx, [eax + edx + field_6e1]             # 0045bd10
    push ecx                                     # 0045bd17
    mov ecx, dword ptr [ebp - local_8]           # 0045bd18
    call FUN_0045be7f                            # 0045bd1b
    mov edx, dword ptr [ebp - local_8]           # 0045bd20
    mov dword ptr [edx + field_24], 0x6          # 0045bd23
    call dword ptr [0x52a23c]                    # 0045bd2a
    add eax, 0x4b0                               # 0045bd30
    mov ecx, dword ptr [ebp - local_8]           # 0045bd35
    mov dword ptr [ecx + field_17c], eax         # 0045bd38
    movsx edx, word ptr [ebp + arg_8]            # 0045bd3e
    shl edx, 0x4                                 # 0045bd42
    mov eax, dword ptr [ebp - local_4]           # 0045bd45
    lea ecx, [eax + edx + field_40d]             # 0045bd48
    movsx edx, word ptr [ebp + arg_8]            # 0045bd4f
    shl edx, 0x4                                 # 0045bd53
    mov eax, dword ptr [ebp - local_8]           # 0045bd56
    lea edx, [eax + edx + field_ec]              # 0045bd59
    mov eax, dword ptr [ecx]                     # 0045bd60
    mov dword ptr [edx], eax                     # 0045bd62
    mov eax, dword ptr [ecx + field_4]           # 0045bd64
    mov dword ptr [edx + field_4], eax           # 0045bd67
    mov eax, dword ptr [ecx + field_8]           # 0045bd6a
    mov dword ptr [edx + field_8], eax           # 0045bd6d
    mov ecx, dword ptr [ecx + field_c]           # 0045bd70
    mov dword ptr [edx + field_c], ecx           # 0045bd73
    movsx edx, word ptr [ebp + arg_8]            # 0045bd76
    mov eax, dword ptr [ebp - local_8]           # 0045bd7a
    mov cx, word ptr [eax + 2*edx + field_b6]    # 0045bd7d
    add cx, 0x1                                  # 0045bd85
    movsx edx, word ptr [ebp + arg_8]            # 0045bd89
    mov eax, dword ptr [ebp - local_8]           # 0045bd8d
    mov word ptr [eax + 2*edx + field_b6], cx    # 0045bd90
    mov eax, 0x1                                 # 0045bd98
    jmp.d8 L_0045bda1                            # 0045bd9d
L_0045bd9f:
    # block 0x0045bd9f: entered by jne at 0x0045bcf6, 1 instruction(s), falls into the block at 0x0045bda1
    {load} xor eax, eax                          # 0045bd9f
L_0045bda1:
    # block 0x0045bda1: entered by jmp at 0x0045bd9d, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0045bda1
    pop ebp                                      # 0045bda3
    ret 0x4                                      # 0045bda4

