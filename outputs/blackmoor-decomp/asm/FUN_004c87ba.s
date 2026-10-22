# FUN_004c87ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c87ba
# extent:       0x004c87ba-0x004c880f (85 code bytes)
# span:         0x004c87ba-0x004c880f (code 85, tables 0, padding 0)
# sha256:       2dd1c6a75c76eec1a01f094322e62a6158936f59d6a00c79b0c6cab43895782b
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c87ba_fill_stride
# naming:       native port src/original_methods_fl39e.c:m4c87ba_fill_stride (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Writes the low byte of the fifth argument count times (signed compare; zero, negative and positive counts) at p, p += the stack argument at +0x10 each time; All instructions run; both jump directions taken.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4c87ba_fill_stride (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004c87ba - 0x401000
.globl FUN_004c87ba
FUN_004c87ba:
    # block 0x004c87ba: entry, 9 instruction(s), ends with forward jump to 0x004c87dd
    push ebp                                     # 004c87ba
    {load} mov ebp, esp                          # 004c87bb
    sub esp, 0xc                                 # 004c87bd
    mov dword ptr [ebp - local_c], ecx           # 004c87c0
    mov eax, dword ptr [ebp + arg_8]             # 004c87c3
    mov ecx, dword ptr [eax]                     # 004c87c6
    mov dword ptr [ebp - local_4], ecx           # 004c87c8
    mov dword ptr [ebp - local_8], 0x0           # 004c87cb
    jmp.d8 L_004c87dd                            # 004c87d2
L_004c87d4:
    # block 0x004c87d4: entered by jmp at 0x004c87f6, 3 instruction(s), falls into the block at 0x004c87dd
    mov edx, dword ptr [ebp - local_8]           # 004c87d4
    add edx, 0x1                                 # 004c87d7
    mov dword ptr [ebp - local_8], edx           # 004c87da
L_004c87dd:
    # block 0x004c87dd: entered by jmp at 0x004c87d2, 3 instruction(s), ends with jge to 0x004c87f8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c87dd
    cmp eax, dword ptr [ebp + arg_14]            # 004c87e0
    jge.d8 L_004c87f8                            # 004c87e3
    # block 0x004c87e5: entered by fall-through of jge at 0x004c87e3, 7 instruction(s), ends with backward jump to 0x004c87d4
    mov ecx, dword ptr [ebp - local_4]           # 004c87e5
    mov dl, byte ptr [ebp + arg_18]              # 004c87e8
    mov byte ptr [ecx], dl                       # 004c87eb
    mov eax, dword ptr [ebp - local_4]           # 004c87ed
    add eax, dword ptr [ebp + arg_10]            # 004c87f0
    mov dword ptr [ebp - local_4], eax           # 004c87f3
    jmp.d8 L_004c87d4                            # 004c87f6
L_004c87f8:
    # block 0x004c87f8: entered by jge at 0x004c87e3, 9 instruction(s), ends with ret 0x14
    mov ecx, dword ptr [ebp - local_4]           # 004c87f8
    add ecx, dword ptr [ebp + arg_c]             # 004c87fb
    mov dword ptr [ebp - local_4], ecx           # 004c87fe
    mov edx, dword ptr [ebp + arg_8]             # 004c8801
    mov eax, dword ptr [ebp - local_4]           # 004c8804
    mov dword ptr [edx], eax                     # 004c8807
    {load} mov esp, ebp                          # 004c8809
    pop ebp                                      # 004c880b
    ret 0x14                                     # 004c880c

