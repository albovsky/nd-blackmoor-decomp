# FUN_005117ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005117ea
# extent:       0x005117ea-0x0051181f (53 code bytes)
# span:         0x005117ea-0x0051181f (code 53, tables 0, padding 0)
# sha256:       bdd9c94b0f84d222abba49b0dd9c6ff49164736dc4a0b443c3c5514c565947fe
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005117ea
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_4
# callees:      calls FUN_00510f91
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00510f91, .text + (0x00510f91 - 0x401000)

.org 0x005117ea - 0x401000
.globl FUN_005117ea
FUN_005117ea:
    # block 0x005117ea: entry, 5 instruction(s), ends with js to 0x00511803 (forward)
    push ebp                                     # 005117ea
    {load} mov ebp, esp                          # 005117eb
    mov ecx, dword ptr [ebp + arg_c]             # 005117ed
    dec dword ptr [ecx + field_4]                # 005117f0
    js.d8 L_00511803                             # 005117f3
    # block 0x005117f5: entered by fall-through of js at 0x005117f3, 6 instruction(s), ends with forward jump to 0x0051180e
    mov edx, dword ptr [ecx]                     # 005117f5
    mov al, byte ptr [ebp + arg_8]               # 005117f7
    mov byte ptr [edx], al                       # 005117fa
    inc dword ptr [ecx]                          # 005117fc
    movzx eax, al                                # 005117fe
    jmp.d8 L_0051180e                            # 00511801
L_00511803:
    # block 0x00511803: entered by js at 0x005117f3, 5 instruction(s), calls FUN_00510f91, falls into the block at 0x0051180e
    push ecx                                     # 00511803
    push dword ptr [ebp + arg_8]                 # 00511804
    call FUN_00510f91                            # 00511807
    pop ecx                                      # 0051180c
    pop ecx                                      # 0051180d
L_0051180e:
    # block 0x0051180e: entered by jmp at 0x00511801, 3 instruction(s), ends with jne to 0x0051181b (forward)
    cmp eax, -0x1                                # 0051180e
    mov eax, dword ptr [ebp + arg_10]            # 00511811
    jne.d8 L_0051181b                            # 00511814
    # block 0x00511816: entered by fall-through of jne at 0x00511814, 3 instruction(s), ends with ret
    or dword ptr [eax], -0x1                     # 00511816
    pop ebp                                      # 00511819
    ret                                          # 0051181a
L_0051181b:
    # block 0x0051181b: entered by jne at 0x00511814, 3 instruction(s), ends with ret
    inc dword ptr [eax]                          # 0051181b
    pop ebp                                      # 0051181d
    ret                                          # 0051181e

