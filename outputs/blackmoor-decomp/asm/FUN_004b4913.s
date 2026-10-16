# FUN_004b4913
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b4913
# extent:       0x004b4913-0x004b49d4 (193 code bytes)
# span:         0x004b4913-0x004b49d4 (code 193, tables 0, padding 0)
# sha256:       21ceac7aa266dc9c94afb7386a88de9f52c333d1d566e02f47b0af8b6b3fb6c0
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b4913
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_750, field_82b; [ecx + n] field_728; [edx + n] field_74e
# callees:      calls FUN_004fb2e3, FUN_004b49d4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_728, 0x728  # offset +0x728
.equ field_74e, 0x74e  # offset +0x74e
.equ field_750, 0x750  # offset +0x750
.equ field_82b, 0x82b  # offset +0x82b

# --- external targets -----------------------------------------------
.set FUN_004b49d4, .text + (0x004b49d4 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004b4913 - 0x401000
.globl FUN_004b4913
FUN_004b4913:
    # block 0x004b4913: entry, 6 instruction(s), ends with forward jump to 0x004b4930
    push ebp                                     # 004b4913
    {load} mov ebp, esp                          # 004b4914
    sub esp, 0xc                                 # 004b4916
    mov dword ptr [ebp - local_c], ecx           # 004b4919
    mov word ptr [ebp - local_4], 0x0            # 004b491c
    jmp.d8 L_004b4930                            # 004b4922
L_004b4924:
    # block 0x004b4924: entered by jmp at 0x004b49c9, 3 instruction(s), falls into the block at 0x004b4930
    mov ax, word ptr [ebp - local_4]             # 004b4924
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b4928
    mov word ptr [ebp - local_4], ax             # 004b492c
L_004b4930:
    # block 0x004b4930: entered by jmp at 0x004b4922, 4 instruction(s), ends with jge to 0x004b49ce (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b4930
    movsx edx, word ptr [0x591a22]               # 004b4934
    {load} cmp ecx, edx                          # 004b493b
    jge.d32 L_004b49ce                           # 004b493d
    # block 0x004b4943: entered by fall-through of jge at 0x004b493d, 8 instruction(s), ends with jne to 0x004b49c9 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b4943
    imul eax, eax, 0xc                           # 004b4947
    movsx ecx, word ptr [ebp - local_4]          # 004b494a
    mov dx, word ptr [eax + 2*ecx + 0x5919fe]    # 004b494e
    mov word ptr [ebp - local_8], dx             # 004b4956
    movsx eax, word ptr [ebp - local_8]          # 004b495a
    cmp eax, -0x1                                # 004b495e
    jne.d8 L_004b49c9                            # 004b4961
    # block 0x004b4963: entered by fall-through of jne at 0x004b4961, 22 instruction(s), calls FUN_004fb2e3, FUN_004b49d4, ends with forward jump to 0x004b49ce
    mov ecx, dword ptr [ebp - local_c]           # 004b4963
    movsx edx, word ptr [ecx + field_728]        # 004b4966
    imul edx, edx, 0x8d                          # 004b496d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b4973
    mov cx, word ptr [eax + field_82b]           # 004b4979
    push ecx                                     # 004b4980
    mov ecx, 0x5c3a67                            # 004b4981
    call FUN_004fb2e3                            # 004b4986
    movsx edx, word ptr [ebp + arg_c]            # 004b498b
    imul edx, edx, 0xc                           # 004b498f
    movsx eax, word ptr [ebp - local_4]          # 004b4992
    mov cx, word ptr [ebp + arg_8]               # 004b4996
    mov word ptr [edx + 2*eax + 0x5919fe], cx    # 004b499a
    mov edx, dword ptr [ebp - local_c]           # 004b49a2
    mov word ptr [edx + field_74e], 0x1          # 004b49a5
    mov eax, dword ptr [ebp - local_c]           # 004b49ae
    mov word ptr [eax + field_750], 0x0          # 004b49b1
    mov cx, word ptr [ebp + arg_c]               # 004b49ba
    push ecx                                     # 004b49be
    mov ecx, dword ptr [ebp - local_c]           # 004b49bf
    call FUN_004b49d4                            # 004b49c2
    jmp.d8 L_004b49ce                            # 004b49c7
L_004b49c9:
    # block 0x004b49c9: entered by jne at 0x004b4961, 1 instruction(s), ends with backward jump to 0x004b4924
    jmp.d32 L_004b4924                           # 004b49c9
L_004b49ce:
    # block 0x004b49ce: entered by jge at 0x004b493d; jmp at 0x004b49c7, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004b49ce
    pop ebp                                      # 004b49d0
    ret 0x8                                      # 004b49d1

