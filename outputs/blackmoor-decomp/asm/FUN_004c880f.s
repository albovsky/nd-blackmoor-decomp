# FUN_004c880f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c880f
# extent:       0x004c880f-0x004c8872 (99 code bytes)
# span:         0x004c880f-0x004c8872 (code 99, tables 0, padding 0)
# sha256:       52218b930ffaf1a8f602f720b158b2e533ef7ba62784df40b1ec8a8167f85fff
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c880f
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004c880f - 0x401000
.globl FUN_004c880f
FUN_004c880f:
    # block 0x004c880f: entry, 9 instruction(s), ends with forward jump to 0x004c8832
    push ebp                                     # 004c880f
    {load} mov ebp, esp                          # 004c8810
    sub esp, 0xc                                 # 004c8812
    mov dword ptr [ebp - local_c], ecx           # 004c8815
    mov eax, dword ptr [ebp + arg_8]             # 004c8818
    mov ecx, dword ptr [eax]                     # 004c881b
    mov dword ptr [ebp - local_4], ecx           # 004c881d
    mov dword ptr [ebp - local_8], 0x0           # 004c8820
    jmp.d8 L_004c8832                            # 004c8827
L_004c8829:
    # block 0x004c8829: entered by jmp at 0x004c884d, 3 instruction(s), falls into the block at 0x004c8832
    mov edx, dword ptr [ebp - local_8]           # 004c8829
    add edx, 0x1                                 # 004c882c
    mov dword ptr [ebp - local_8], edx           # 004c882f
L_004c8832:
    # block 0x004c8832: entered by jmp at 0x004c8827, 3 instruction(s), ends with jge to 0x004c884f (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c8832
    cmp eax, dword ptr [ebp + arg_14]            # 004c8835
    jge.d8 L_004c884f                            # 004c8838
    # block 0x004c883a: entered by fall-through of jge at 0x004c8838, 7 instruction(s), ends with backward jump to 0x004c8829
    mov ecx, dword ptr [ebp - local_4]           # 004c883a
    mov dx, word ptr [ebp + arg_18]              # 004c883d
    mov word ptr [ecx], dx                       # 004c8841
    mov eax, dword ptr [ebp - local_4]           # 004c8844
    add eax, dword ptr [ebp + arg_c]             # 004c8847
    mov dword ptr [ebp - local_4], eax           # 004c884a
    jmp.d8 L_004c8829                            # 004c884d
L_004c884f:
    # block 0x004c884f: entered by jge at 0x004c8838, 12 instruction(s), ends with ret 0x14
    movsx ecx, word ptr [0x639895]               # 004c884f
    mov edx, dword ptr [ebp + arg_10]            # 004c8856
    imul edx, ecx                                # 004c8859
    mov eax, dword ptr [ebp - local_4]           # 004c885c
    {load} add eax, edx                          # 004c885f
    mov dword ptr [ebp - local_4], eax           # 004c8861
    mov ecx, dword ptr [ebp + arg_8]             # 004c8864
    mov edx, dword ptr [ebp - local_4]           # 004c8867
    mov dword ptr [ecx], edx                     # 004c886a
    {load} mov esp, ebp                          # 004c886c
    pop ebp                                      # 004c886e
    ret 0x14                                     # 004c886f

