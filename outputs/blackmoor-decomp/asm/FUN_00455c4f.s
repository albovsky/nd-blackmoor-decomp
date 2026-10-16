# FUN_00455c4f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455c4f
# extent:       0x00455c4f-0x00455cc3 (116 code bytes)
# span:         0x00455c4f-0x00455cc3 (code 116, tables 0, padding 0)
# sha256:       5798119c7d82b16c13b7eb66ebee059599a449687418288e5c712136d3f446b9
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00455c4f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_155; [ecx + n] field_21, field_d9, field_159
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_d9, 0xd9  # offset +0xd9
.equ field_155, 0x155  # offset +0x155
.equ field_159, 0x159  # offset +0x159

# --- external targets -----------------------------------------------

.org 0x00455c4f - 0x401000
.globl FUN_00455c4f
FUN_00455c4f:
    # block 0x00455c4f: entry, 11 instruction(s), ends with forward jump to 0x00455c80
    push ebp                                     # 00455c4f
    {load} mov ebp, esp                          # 00455c50
    sub esp, 0xc                                 # 00455c52
    mov dword ptr [ebp - local_c], ecx           # 00455c55
    mov eax, dword ptr [ebp - local_c]           # 00455c58
    movsx ecx, word ptr [eax + field_1e]         # 00455c5b
    imul ecx, ecx, 0x8d                          # 00455c5f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455c65
    mov dword ptr [ebp - local_4], edx           # 00455c6b
    mov dword ptr [ebp - local_8], 0x0           # 00455c6e
    jmp.d8 L_00455c80                            # 00455c75
L_00455c77:
    # block 0x00455c77: entered by jmp at 0x00455ca6, 3 instruction(s), falls into the block at 0x00455c80
    mov eax, dword ptr [ebp - local_8]           # 00455c77
    add eax, 0x1                                 # 00455c7a
    mov dword ptr [ebp - local_8], eax           # 00455c7d
L_00455c80:
    # block 0x00455c80: entered by jmp at 0x00455c75, 4 instruction(s), ends with jge to 0x00455ca8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00455c80
    movsx edx, word ptr [ecx + field_21]         # 00455c83
    cmp dword ptr [ebp - local_8], edx           # 00455c87
    jge.d8 L_00455ca8                            # 00455c8a
    # block 0x00455c8c: entered by fall-through of jge at 0x00455c8a, 6 instruction(s), ends with jne to 0x00455ca6 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00455c8c
    imul eax, eax, 0x96                          # 00455c8f
    mov ecx, dword ptr [ebp - local_4]           # 00455c95
    movsx edx, word ptr [ecx + eax + field_d9]   # 00455c98
    test edx, edx                                # 00455ca0
    jne.d8 L_00455ca6                            # 00455ca2
    # block 0x00455ca4: entered by fall-through of jne at 0x00455ca2, 1 instruction(s), ends with forward jump to 0x00455cbf
    jmp.d8 L_00455cbf                            # 00455ca4
L_00455ca6:
    # block 0x00455ca6: entered by jne at 0x00455ca2, 1 instruction(s), ends with backward jump to 0x00455c77
    jmp.d8 L_00455c77                            # 00455ca6
L_00455ca8:
    # block 0x00455ca8: entered by jge at 0x00455c8a, 4 instruction(s), falls into the block at 0x00455cbf
    mov eax, dword ptr [ebp - local_c]           # 00455ca8
    mov dword ptr [eax + field_155], 0x4         # 00455cab
    mov ecx, dword ptr [ebp - local_c]           # 00455cb5
    mov byte ptr [ecx + field_159], 0x1          # 00455cb8
L_00455cbf:
    # block 0x00455cbf: entered by jmp at 0x00455ca4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00455cbf
    pop ebp                                      # 00455cc1
    ret                                          # 00455cc2

