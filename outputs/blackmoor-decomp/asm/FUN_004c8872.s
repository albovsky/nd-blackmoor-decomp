# FUN_004c8872
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c8872
# extent:       0x004c8872-0x004c88c7 (85 code bytes)
# span:         0x004c8872-0x004c88c7 (code 85, tables 0, padding 0)
# sha256:       269970495886b74015a73f5782f9055b2a30cded8c3995d94a11dd43619274ea
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c8872
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x004c8872 - 0x401000
.globl FUN_004c8872
FUN_004c8872:
    # block 0x004c8872: entry, 9 instruction(s), ends with forward jump to 0x004c8895
    push ebp                                     # 004c8872
    {load} mov ebp, esp                          # 004c8873
    sub esp, 0xc                                 # 004c8875
    mov dword ptr [ebp - local_c], ecx           # 004c8878
    mov eax, dword ptr [ebp + arg_8]             # 004c887b
    mov ecx, dword ptr [eax]                     # 004c887e
    mov dword ptr [ebp - local_4], ecx           # 004c8880
    mov dword ptr [ebp - local_8], 0x0           # 004c8883
    jmp.d8 L_004c8895                            # 004c888a
L_004c888c:
    # block 0x004c888c: entered by jmp at 0x004c88ae, 3 instruction(s), falls into the block at 0x004c8895
    mov edx, dword ptr [ebp - local_8]           # 004c888c
    add edx, 0x1                                 # 004c888f
    mov dword ptr [ebp - local_8], edx           # 004c8892
L_004c8895:
    # block 0x004c8895: entered by jmp at 0x004c888a, 3 instruction(s), ends with jge to 0x004c88b0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c8895
    cmp eax, dword ptr [ebp + arg_14]            # 004c8898
    jge.d8 L_004c88b0                            # 004c889b
    # block 0x004c889d: entered by fall-through of jge at 0x004c889b, 7 instruction(s), ends with backward jump to 0x004c888c
    mov ecx, dword ptr [ebp - local_4]           # 004c889d
    mov dl, byte ptr [ebp + arg_18]              # 004c88a0
    mov byte ptr [ecx], dl                       # 004c88a3
    mov eax, dword ptr [ebp - local_4]           # 004c88a5
    add eax, dword ptr [ebp + arg_c]             # 004c88a8
    mov dword ptr [ebp - local_4], eax           # 004c88ab
    jmp.d8 L_004c888c                            # 004c88ae
L_004c88b0:
    # block 0x004c88b0: entered by jge at 0x004c889b, 9 instruction(s), ends with ret 0x14
    mov ecx, dword ptr [ebp - local_4]           # 004c88b0
    add ecx, dword ptr [ebp + arg_10]            # 004c88b3
    mov dword ptr [ebp - local_4], ecx           # 004c88b6
    mov edx, dword ptr [ebp + arg_8]             # 004c88b9
    mov eax, dword ptr [ebp - local_4]           # 004c88bc
    mov dword ptr [edx], eax                     # 004c88bf
    {load} mov esp, ebp                          # 004c88c1
    pop ebp                                      # 004c88c3
    ret 0x14                                     # 004c88c4

