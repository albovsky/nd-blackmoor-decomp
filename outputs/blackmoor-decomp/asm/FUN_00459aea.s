# FUN_00459aea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459aea
# extent:       0x00459aea-0x00459b87 (157 code bytes)
# span:         0x00459aea-0x00459b87 (code 157, tables 0, padding 0)
# sha256:       b3e3b24ae4c088f423ee4b6e16154f4d558b8284115bccc76bd9d662d242feca
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459aea
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_d6, field_e1; [ecx + n] field_24, field_c8, field_cc, field_ce; [edx + n] field_1e, field_22, field_df
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_c8, 0xc8  # offset +0xc8
.equ field_cc, 0xcc  # offset +0xcc
.equ field_ce, 0xce  # offset +0xce
.equ field_d6, 0xd6  # offset +0xd6
.equ field_df, 0xdf  # offset +0xdf
.equ field_e1, 0xe1  # offset +0xe1

# --- external targets -----------------------------------------------

.org 0x00459aea - 0x401000
.globl FUN_00459aea
FUN_00459aea:
    # block 0x00459aea: entry, 22 instruction(s), ends with forward jump to 0x00459b5b
    push ebp                                     # 00459aea
    {load} mov ebp, esp                          # 00459aeb
    sub esp, 0x8                                 # 00459aed
    mov dword ptr [ebp - local_8], ecx           # 00459af0
    mov eax, dword ptr [ebp - local_8]           # 00459af3
    mov word ptr [eax + field_1c], 0xffff        # 00459af6
    mov ecx, dword ptr [ebp - local_8]           # 00459afc
    mov dword ptr [ecx + field_c8], 0x0          # 00459aff
    mov edx, dword ptr [ebp - local_8]           # 00459b09
    mov word ptr [edx + field_22], 0xffff        # 00459b0c
    mov eax, dword ptr [ebp - local_8]           # 00459b12
    mov byte ptr [eax + field_d6], 0x0           # 00459b15
    mov ecx, dword ptr [ebp - local_8]           # 00459b1c
    mov word ptr [ecx + field_cc], 0xffff        # 00459b1f
    mov edx, dword ptr [ebp - local_8]           # 00459b28
    mov word ptr [edx + field_df], 0x0           # 00459b2b
    mov eax, dword ptr [ebp - local_8]           # 00459b34
    mov byte ptr [eax + field_e1], 0x0           # 00459b37
    mov ecx, dword ptr [ebp - local_8]           # 00459b3e
    mov word ptr [ecx + field_24], 0x0           # 00459b41
    mov word ptr [ebp - local_4], 0x0            # 00459b47
    jmp.d8 L_00459b5b                            # 00459b4d
L_00459b4f:
    # block 0x00459b4f: entered by jmp at 0x00459b81, 3 instruction(s), falls into the block at 0x00459b5b
    mov dx, word ptr [ebp - local_4]             # 00459b4f
    add dx, 0x1                                  # 00459b53
    mov word ptr [ebp - local_4], dx             # 00459b57
L_00459b5b:
    # block 0x00459b5b: entered by jmp at 0x00459b4d, 3 instruction(s), ends with jge to 0x00459b83 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00459b5b
    cmp eax, 0x4                                 # 00459b5f
    jge.d8 L_00459b83                            # 00459b62
    # block 0x00459b64: entered by fall-through of jge at 0x00459b62, 7 instruction(s), ends with backward jump to 0x00459b4f
    movsx ecx, word ptr [ebp - local_4]          # 00459b64
    mov edx, dword ptr [ebp - local_8]           # 00459b68
    mov byte ptr [edx + ecx + field_1e], 0x0     # 00459b6b
    movsx eax, word ptr [ebp - local_4]          # 00459b70
    mov ecx, dword ptr [ebp - local_8]           # 00459b74
    mov word ptr [ecx + 2*eax + field_ce], 0xffff # 00459b77
    jmp.d8 L_00459b4f                            # 00459b81
L_00459b83:
    # block 0x00459b83: entered by jge at 0x00459b62, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00459b83
    pop ebp                                      # 00459b85
    ret                                          # 00459b86

