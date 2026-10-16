# FUN_004e1b79
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1b79
# extent:       0x004e1b79-0x004e1c18 (159 code bytes)
# span:         0x004e1b79-0x004e1c20 (code 159, tables 0, padding 8)
# sha256:       c66cc31c786374c4b84216f48dfd3c0669f070918572131835c5e1601a8d8f6a
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e1b79
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004e1b79 - 0x401000
.globl FUN_004e1b79
FUN_004e1b79:
    # block 0x004e1b79: entry, 8 instruction(s), ends with jne to 0x004e1b9b (forward)
    push ebp                                     # 004e1b79
    {load} mov ebp, esp                          # 004e1b7a
    sub esp, 0x8                                 # 004e1b7c
    mov dword ptr [ebp - local_8], ecx           # 004e1b7f
    movsx eax, word ptr [ebp + arg_8]            # 004e1b82
    imul eax, eax, 0x1a4                         # 004e1b86
    cmp dword ptr [eax + 0x5a1620], 0x1          # 004e1b8c
    jne.d8 L_004e1b9b                            # 004e1b93
    # block 0x004e1b95: entered by fall-through of jne at 0x004e1b93, 2 instruction(s), ends with forward jump to 0x004e1c12
    mov ax, 0xe                                  # 004e1b95
    jmp.d8 L_004e1c12                            # 004e1b99
L_004e1b9b:
    # block 0x004e1b9b: entered by jne at 0x004e1b93, 2 instruction(s), ends with forward jump to 0x004e1baf
    mov word ptr [ebp - local_4], 0x0            # 004e1b9b
    jmp.d8 L_004e1baf                            # 004e1ba1
L_004e1ba3:
    # block 0x004e1ba3: entered by jmp at 0x004e1c0c, 3 instruction(s), falls into the block at 0x004e1baf
    mov cx, word ptr [ebp - local_4]             # 004e1ba3
    add cx, 0x1                                  # 004e1ba7
    mov word ptr [ebp - local_4], cx             # 004e1bab
L_004e1baf:
    # block 0x004e1baf: entered by jmp at 0x004e1ba1, 3 instruction(s), ends with jge to 0x004e1c0e (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e1baf
    cmp edx, 0x32                                # 004e1bb3
    jge.d8 L_004e1c0e                            # 004e1bb6
    # block 0x004e1bb8: entered by fall-through of jge at 0x004e1bb6, 7 instruction(s), ends with jl to 0x004e1c0c (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004e1bb8
    movsx ecx, word ptr [ebp + arg_8]            # 004e1bbc
    imul ecx, ecx, 0x1a4                         # 004e1bc0
    movsx edx, word ptr [ebp - local_4]          # 004e1bc6
    movsx ecx, word ptr [ecx + 2*edx + 0x5a1624] # 004e1bca
    {load} cmp eax, ecx                          # 004e1bd2
    jl.d8 L_004e1c0c                             # 004e1bd4
    # block 0x004e1bd6: entered by fall-through of jl at 0x004e1bd4, 7 instruction(s), ends with jg to 0x004e1c0c (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004e1bd6
    movsx eax, word ptr [ebp + arg_8]            # 004e1bda
    imul eax, eax, 0x1a4                         # 004e1bde
    movsx ecx, word ptr [ebp - local_4]          # 004e1be4
    movsx eax, word ptr [eax + 2*ecx + 0x5a1688] # 004e1be8
    {load} cmp edx, eax                          # 004e1bf0
    jg.d8 L_004e1c0c                             # 004e1bf2
    # block 0x004e1bf4: entered by fall-through of jg at 0x004e1bf2, 5 instruction(s), ends with forward jump to 0x004e1c12
    movsx ecx, word ptr [ebp + arg_8]            # 004e1bf4
    imul ecx, ecx, 0x1a4                         # 004e1bf8
    movsx edx, word ptr [ebp - local_4]          # 004e1bfe
    mov ax, word ptr [ecx + 4*edx + 0x5a16ec]    # 004e1c02
    jmp.d8 L_004e1c12                            # 004e1c0a
L_004e1c0c:
    # block 0x004e1c0c: entered by jl at 0x004e1bd4; jg at 0x004e1bf2, 1 instruction(s), ends with backward jump to 0x004e1ba3
    jmp.d8 L_004e1ba3                            # 004e1c0c
L_004e1c0e:
    # block 0x004e1c0e: entered by jge at 0x004e1bb6, 1 instruction(s), falls into the block at 0x004e1c12
    mov ax, 0xd                                  # 004e1c0e
L_004e1c12:
    # block 0x004e1c12: entered by jmp at 0x004e1b99; jmp at 0x004e1c0a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004e1c12
    pop ebp                                      # 004e1c14
    ret 0x8                                      # 004e1c15

# --- data items (not part of the function) -------------------------
.org 0x004e1c18 - 0x401000
PAD_004e1c18:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

