# FUN_004b5aa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5aa0
# extent:       0x004b5aa0-0x004b5b0a (106 code bytes)
# span:         0x004b5aa0-0x004b5b0a (code 106, tables 0, padding 0)
# sha256:       9124742ee0fa737cc43041cf1ebf996dacb2530bc897f33ecf173ec69d48a0c8
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b5aa0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004b5b1a
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
.set FUN_004b5b1a, .text + (0x004b5b1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004b5aa0 - 0x401000
.globl FUN_004b5aa0
FUN_004b5aa0:
    # block 0x004b5aa0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004b5ae5 (forward)
    push ebp                                     # 004b5aa0
    {load} mov ebp, esp                          # 004b5aa1
    push -0x1                                    # 004b5aa3
    push 0x52873a                                # 004b5aa5
    mov eax, dword ptr fs:[0x0]                  # 004b5aaa
    push eax                                     # 004b5ab0
    mov dword ptr fs:[0x0], esp                  # 004b5ab1
    sub esp, 0xc                                 # 004b5ab8
    push 0x278                                   # 004b5abb
    call FUN_0051dc43                            # 004b5ac0
    add esp, 0x4                                 # 004b5ac5
    mov dword ptr [ebp - local_14], eax          # 004b5ac8
    mov dword ptr [ebp - local_4], 0x0           # 004b5acb
    cmp dword ptr [ebp - local_14], 0x0          # 004b5ad2
    je.d8 L_004b5ae5                             # 004b5ad6
    # block 0x004b5ad8: entered by fall-through of je at 0x004b5ad6, 4 instruction(s), calls FUN_004b5b1a, ends with forward jump to 0x004b5aec
    mov ecx, dword ptr [ebp - local_14]          # 004b5ad8
    call FUN_004b5b1a                            # 004b5adb
    mov dword ptr [ebp - local_18], eax          # 004b5ae0
    jmp.d8 L_004b5aec                            # 004b5ae3
L_004b5ae5:
    # block 0x004b5ae5: entered by je at 0x004b5ad6, 1 instruction(s), falls into the block at 0x004b5aec
    mov dword ptr [ebp - local_18], 0x0          # 004b5ae5
L_004b5aec:
    # block 0x004b5aec: entered by jmp at 0x004b5ae3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004b5aec
    mov dword ptr [ebp - local_10], eax          # 004b5aef
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b5af2
    mov eax, dword ptr [ebp - local_10]          # 004b5af9
    mov ecx, dword ptr [ebp - local_c]           # 004b5afc
    mov dword ptr fs:[0x0], ecx                  # 004b5aff
    {load} mov esp, ebp                          # 004b5b06
    pop ebp                                      # 004b5b08
    ret                                          # 004b5b09

