# FUN_004cc8b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc8b0
# extent:       0x004cc8b0-0x004cc917 (103 code bytes)
# span:         0x004cc8b0-0x004cc917 (code 103, tables 0, padding 0)
# sha256:       cb1d59b8fd28fa60a4df3e4160058636ed1322d323080600f9421aa58a3ba30a
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cc8b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004cc927
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
.set FUN_004cc927, .text + (0x004cc927 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004cc8b0 - 0x401000
.globl FUN_004cc8b0
FUN_004cc8b0:
    # block 0x004cc8b0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004cc8f2 (forward)
    push ebp                                     # 004cc8b0
    {load} mov ebp, esp                          # 004cc8b1
    push -0x1                                    # 004cc8b3
    push 0x52881a                                # 004cc8b5
    mov eax, dword ptr fs:[0x0]                  # 004cc8ba
    push eax                                     # 004cc8c0
    mov dword ptr fs:[0x0], esp                  # 004cc8c1
    sub esp, 0xc                                 # 004cc8c8
    push 0x1c                                    # 004cc8cb
    call FUN_0051dc43                            # 004cc8cd
    add esp, 0x4                                 # 004cc8d2
    mov dword ptr [ebp - local_14], eax          # 004cc8d5
    mov dword ptr [ebp - local_4], 0x0           # 004cc8d8
    cmp dword ptr [ebp - local_14], 0x0          # 004cc8df
    je.d8 L_004cc8f2                             # 004cc8e3
    # block 0x004cc8e5: entered by fall-through of je at 0x004cc8e3, 4 instruction(s), calls FUN_004cc927, ends with forward jump to 0x004cc8f9
    mov ecx, dword ptr [ebp - local_14]          # 004cc8e5
    call FUN_004cc927                            # 004cc8e8
    mov dword ptr [ebp - local_18], eax          # 004cc8ed
    jmp.d8 L_004cc8f9                            # 004cc8f0
L_004cc8f2:
    # block 0x004cc8f2: entered by je at 0x004cc8e3, 1 instruction(s), falls into the block at 0x004cc8f9
    mov dword ptr [ebp - local_18], 0x0          # 004cc8f2
L_004cc8f9:
    # block 0x004cc8f9: entered by jmp at 0x004cc8f0, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004cc8f9
    mov dword ptr [ebp - local_10], eax          # 004cc8fc
    mov dword ptr [ebp - local_4], 0xffffffff    # 004cc8ff
    mov eax, dword ptr [ebp - local_10]          # 004cc906
    mov ecx, dword ptr [ebp - local_c]           # 004cc909
    mov dword ptr fs:[0x0], ecx                  # 004cc90c
    {load} mov esp, ebp                          # 004cc913
    pop ebp                                      # 004cc915
    ret                                          # 004cc916

