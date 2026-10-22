# FUN_00465075
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465075
# extent:       0x00465075-0x004650db (102 code bytes)
# span:         0x00465075-0x004650db (code 102, tables 0, padding 0)
# sha256:       c62cbd9b54d7f29b78eb8f06ef402eb45a917266943fb5814f2cc935c5be732e
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00465075
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_bd; [ecx + n] field_c1; [edx + n] field_94
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_94, 0x94  # offset +0x94
.equ field_bd, 0xbd  # offset +0xbd
.equ field_c1, 0xc1  # offset +0xc1

# --- external targets -----------------------------------------------

.org 0x00465075 - 0x401000
.globl FUN_00465075
FUN_00465075:
    # block 0x00465075: entry, 11 instruction(s), ends with forward jump to 0x004650a6
    push ebp                                     # 00465075
    {load} mov ebp, esp                          # 00465076
    sub esp, 0xc                                 # 00465078
    mov dword ptr [ebp - local_c], ecx           # 0046507b
    mov eax, dword ptr [ebp - local_c]           # 0046507e
    movsx ecx, word ptr [eax + field_1e]         # 00465081
    imul ecx, ecx, 0x8d                          # 00465085
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046508b
    mov dword ptr [ebp - local_8], edx           # 00465091
    mov dword ptr [ebp - local_4], 0x0           # 00465094
    jmp.d8 L_004650a6                            # 0046509b
L_0046509d:
    # block 0x0046509d: entered by jmp at 0x004650be, 3 instruction(s), falls into the block at 0x004650a6
    mov eax, dword ptr [ebp - local_4]           # 0046509d
    add eax, 0x1                                 # 004650a0
    mov dword ptr [ebp - local_4], eax           # 004650a3
L_004650a6:
    # block 0x004650a6: entered by jmp at 0x0046509b, 2 instruction(s), ends with jge to 0x004650c0 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004650a6
    jge.d8 L_004650c0                            # 004650aa
    # block 0x004650ac: entered by fall-through of jge at 0x004650aa, 4 instruction(s), ends with jne to 0x004650be (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004650ac
    mov edx, dword ptr [ebp - local_c]           # 004650af
    cmp dword ptr [edx + 4*ecx + field_94], 0x0  # 004650b2
    jne.d8 L_004650be                            # 004650ba
    # block 0x004650bc: entered by fall-through of jne at 0x004650ba, 1 instruction(s), ends with forward jump to 0x004650d7
    jmp.d8 L_004650d7                            # 004650bc
L_004650be:
    # block 0x004650be: entered by jne at 0x004650ba, 1 instruction(s), ends with backward jump to 0x0046509d
    jmp.d8 L_0046509d                            # 004650be
L_004650c0:
    # block 0x004650c0: entered by jge at 0x004650aa, 4 instruction(s), falls into the block at 0x004650d7
    mov eax, dword ptr [ebp - local_c]           # 004650c0
    mov dword ptr [eax + field_bd], 0x3          # 004650c3
    mov ecx, dword ptr [ebp - local_c]           # 004650cd
    mov byte ptr [ecx + field_c1], 0x1           # 004650d0
L_004650d7:
    # block 0x004650d7: entered by jmp at 0x004650bc, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004650d7
    pop ebp                                      # 004650d9
    ret                                          # 004650da

