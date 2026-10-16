# FUN_004756f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004756f0
# extent:       0x004756f0-0x0047575a (106 code bytes)
# span:         0x004756f0-0x0047575a (code 106, tables 0, padding 0)
# sha256:       ba9d9cea07e18cac122d94c2836d05c1f5815b99c660d007078c2b36d3c9f633
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004756f0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0047576a
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
.set FUN_0047576a, .text + (0x0047576a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004756f0 - 0x401000
.globl FUN_004756f0
FUN_004756f0:
    # block 0x004756f0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00475735 (forward)
    push ebp                                     # 004756f0
    {load} mov ebp, esp                          # 004756f1
    push -0x1                                    # 004756f3
    push 0x5282ca                                # 004756f5
    mov eax, dword ptr fs:[0x0]                  # 004756fa
    push eax                                     # 00475700
    mov dword ptr fs:[0x0], esp                  # 00475701
    sub esp, 0xc                                 # 00475708
    push 0x8da                                   # 0047570b
    call FUN_0051dc43                            # 00475710
    add esp, 0x4                                 # 00475715
    mov dword ptr [ebp - local_14], eax          # 00475718
    mov dword ptr [ebp - local_4], 0x0           # 0047571b
    cmp dword ptr [ebp - local_14], 0x0          # 00475722
    je.d8 L_00475735                             # 00475726
    # block 0x00475728: entered by fall-through of je at 0x00475726, 4 instruction(s), calls FUN_0047576a, ends with forward jump to 0x0047573c
    mov ecx, dword ptr [ebp - local_14]          # 00475728
    call FUN_0047576a                            # 0047572b
    mov dword ptr [ebp - local_18], eax          # 00475730
    jmp.d8 L_0047573c                            # 00475733
L_00475735:
    # block 0x00475735: entered by je at 0x00475726, 1 instruction(s), falls into the block at 0x0047573c
    mov dword ptr [ebp - local_18], 0x0          # 00475735
L_0047573c:
    # block 0x0047573c: entered by jmp at 0x00475733, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0047573c
    mov dword ptr [ebp - local_10], eax          # 0047573f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00475742
    mov eax, dword ptr [ebp - local_10]          # 00475749
    mov ecx, dword ptr [ebp - local_c]           # 0047574c
    mov dword ptr fs:[0x0], ecx                  # 0047574f
    {load} mov esp, ebp                          # 00475756
    pop ebp                                      # 00475758
    ret                                          # 00475759

