# FUN_004a62a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a62a0
# extent:       0x004a62a0-0x004a630a (106 code bytes)
# span:         0x004a62a0-0x004a630a (code 106, tables 0, padding 0)
# sha256:       c5360c298e076d4dce8609211a1f5fad0811dcd67207c3aa9dbd5d54d06126c2
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a62a0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004a631a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004a631a, .text + (0x004a631a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a62a0 - 0x401000
.globl FUN_004a62a0
FUN_004a62a0:
    # block 0x004a62a0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004a62e5 (forward)
    push ebp                                     # 004a62a0
    {load} mov ebp, esp                          # 004a62a1
    push -0x1                                    # 004a62a3
    push 0x5285ea                                # 004a62a5
    mov eax, dword ptr fs:[0x0]                  # 004a62aa
    push eax                                     # 004a62b0
    mov dword ptr fs:[0x0], esp                  # 004a62b1
    sub esp, 0xc                                 # 004a62b8
    push 0xa8                                    # 004a62bb
    call FUN_0051dc43                            # 004a62c0
    add esp, 0x4                                 # 004a62c5
    mov dword ptr [ebp - local_14], eax          # 004a62c8
    mov dword ptr [ebp - local_4], 0x0           # 004a62cb
    cmp dword ptr [ebp - local_14], 0x0          # 004a62d2
    je.d8 L_004a62e5                             # 004a62d6
    # block 0x004a62d8: entered by fall-through of je at 0x004a62d6, 4 instruction(s), calls FUN_004a631a, ends with forward jump to 0x004a62ec
    mov ecx, dword ptr [ebp - local_14]          # 004a62d8
    call FUN_004a631a                            # 004a62db
    mov dword ptr [ebp - local_18], eax          # 004a62e0
    jmp.d8 L_004a62ec                            # 004a62e3
L_004a62e5:
    # block 0x004a62e5: entered by je at 0x004a62d6, 1 instruction(s), falls into the block at 0x004a62ec
    mov dword ptr [ebp - local_18], 0x0          # 004a62e5
L_004a62ec:
    # block 0x004a62ec: entered by jmp at 0x004a62e3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004a62ec
    mov dword ptr [ebp - local_10], eax          # 004a62ef
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a62f2
    mov eax, dword ptr [ebp - local_10]          # 004a62f9
    mov ecx, dword ptr [ebp - local_c]           # 004a62fc
    mov dword ptr fs:[0x0], ecx                  # 004a62ff
    {load} mov esp, ebp                          # 004a6306
    pop ebp                                      # 004a6308
    ret                                          # 004a6309

