# FUN_004c948f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c948f
# extent:       0x004c948f-0x004c94ec (93 code bytes)
# span:         0x004c948f-0x004c94ec (code 93, tables 0, padding 0)
# sha256:       0b8219b7d88ac84ec24522564e2fd3a1b319f6e14431ec3a68c70fb75e894bc6
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c948f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c72
# callees:      calls FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_c72, 0xc72  # offset +0xc72

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c948f - 0x401000
.globl FUN_004c948f
FUN_004c948f:
    # block 0x004c948f: entry, 6 instruction(s), ends with forward jump to 0x004c94ac
    push ebp                                     # 004c948f
    {load} mov ebp, esp                          # 004c9490
    sub esp, 0x8                                 # 004c9492
    mov dword ptr [ebp - local_8], ecx           # 004c9495
    mov word ptr [ebp - local_4], 0x0            # 004c9498
    jmp.d8 L_004c94ac                            # 004c949e
L_004c94a0:
    # block 0x004c94a0: entered by jmp at 0x004c94cc, 3 instruction(s), falls into the block at 0x004c94ac
    mov ax, word ptr [ebp - local_4]             # 004c94a0
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c94a4
    mov word ptr [ebp - local_4], ax             # 004c94a8
L_004c94ac:
    # block 0x004c94ac: entered by jmp at 0x004c949e, 3 instruction(s), ends with jge to 0x004c94ce (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c94ac
    cmp ecx, 0x18                                # 004c94b0
    jge.d8 L_004c94ce                            # 004c94b3
    # block 0x004c94b5: entered by fall-through of jge at 0x004c94b3, 4 instruction(s), ends with jne to 0x004c94cc (forward)
    movsx edx, word ptr [ebp - local_4]          # 004c94b5
    mov eax, dword ptr [ebp - local_8]           # 004c94b9
    cmp dword ptr [eax + 4*edx + field_c72], 0x0 # 004c94bc
    jne.d8 L_004c94cc                            # 004c94c4
    # block 0x004c94c6: entered by fall-through of jne at 0x004c94c4, 2 instruction(s), ends with forward jump to 0x004c94e8
    mov ax, word ptr [ebp - local_4]             # 004c94c6
    jmp.d8 L_004c94e8                            # 004c94ca
L_004c94cc:
    # block 0x004c94cc: entered by jne at 0x004c94c4, 1 instruction(s), ends with backward jump to 0x004c94a0
    jmp.d8 L_004c94a0                            # 004c94cc
L_004c94ce:
    # block 0x004c94ce: entered by jge at 0x004c94b3, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004c94e8
    push 0x0                                     # 004c94ce
    push 0x0                                     # 004c94d0
    push 0x557ae4                                # 004c94d2
    call FUN_0052139c                            # 004c94d7
    mov ecx, dword ptr [ebp - local_8]           # 004c94dc
    call FUN_004c97b4                            # 004c94df
    .insn 0x66, 0x0d, 0xffff{:u16}               # 004c94e4
L_004c94e8:
    # block 0x004c94e8: entered by jmp at 0x004c94ca, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c94e8
    pop ebp                                      # 004c94ea
    ret                                          # 004c94eb

