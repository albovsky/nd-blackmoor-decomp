# FUN_004c8757
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c8757
# extent:       0x004c8757-0x004c87ba (99 code bytes)
# span:         0x004c8757-0x004c87ba (code 99, tables 0, padding 0)
# sha256:       93f5988c6854d01bcc51958736563290f868d062f14192b9a804a9c4360fb1f3
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c8757
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

.org 0x004c8757 - 0x401000
.globl FUN_004c8757
FUN_004c8757:
    # block 0x004c8757: entry, 9 instruction(s), ends with forward jump to 0x004c877a
    push ebp                                     # 004c8757
    {load} mov ebp, esp                          # 004c8758
    sub esp, 0xc                                 # 004c875a
    mov dword ptr [ebp - local_c], ecx           # 004c875d
    mov eax, dword ptr [ebp + arg_8]             # 004c8760
    mov ecx, dword ptr [eax]                     # 004c8763
    mov dword ptr [ebp - local_4], ecx           # 004c8765
    mov dword ptr [ebp - local_8], 0x0           # 004c8768
    jmp.d8 L_004c877a                            # 004c876f
L_004c8771:
    # block 0x004c8771: entered by jmp at 0x004c87a1, 3 instruction(s), falls into the block at 0x004c877a
    mov edx, dword ptr [ebp - local_8]           # 004c8771
    add edx, 0x1                                 # 004c8774
    mov dword ptr [ebp - local_8], edx           # 004c8777
L_004c877a:
    # block 0x004c877a: entered by jmp at 0x004c876f, 3 instruction(s), ends with jge to 0x004c87a3 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c877a
    cmp eax, dword ptr [ebp + arg_14]            # 004c877d
    jge.d8 L_004c87a3                            # 004c8780
    # block 0x004c8782: entered by fall-through of jge at 0x004c8780, 10 instruction(s), ends with backward jump to 0x004c8771
    mov ecx, dword ptr [ebp - local_4]           # 004c8782
    mov dx, word ptr [ebp + arg_18]              # 004c8785
    mov word ptr [ecx], dx                       # 004c8789
    movsx eax, word ptr [0x639895]               # 004c878c
    mov ecx, dword ptr [ebp + arg_10]            # 004c8793
    imul ecx, eax                                # 004c8796
    mov edx, dword ptr [ebp - local_4]           # 004c8799
    {load} add edx, ecx                          # 004c879c
    mov dword ptr [ebp - local_4], edx           # 004c879e
    jmp.d8 L_004c8771                            # 004c87a1
L_004c87a3:
    # block 0x004c87a3: entered by jge at 0x004c8780, 9 instruction(s), ends with ret 0x14
    mov eax, dword ptr [ebp - local_4]           # 004c87a3
    add eax, dword ptr [ebp + arg_c]             # 004c87a6
    mov dword ptr [ebp - local_4], eax           # 004c87a9
    mov ecx, dword ptr [ebp + arg_8]             # 004c87ac
    mov edx, dword ptr [ebp - local_4]           # 004c87af
    mov dword ptr [ecx], edx                     # 004c87b2
    {load} mov esp, ebp                          # 004c87b4
    pop ebp                                      # 004c87b6
    ret 0x14                                     # 004c87b7

