# FUN_004089b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004089b0
# extent:       0x004089b0-0x00408a1a (106 code bytes)
# span:         0x004089b0-0x00408a1a (code 106, tables 0, padding 0)
# sha256:       683e271f171036fb434584a267948ef1b5ed55e688ce228f2969e1833a18a9e9
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004089b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00408a2a
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
.set FUN_00408a2a, .text + (0x00408a2a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004089b0 - 0x401000
.globl FUN_004089b0
FUN_004089b0:
    # block 0x004089b0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004089f5 (forward)
    push ebp                                     # 004089b0
    {load} mov ebp, esp                          # 004089b1
    push -0x1                                    # 004089b3
    push 0x526d8a                                # 004089b5
    mov eax, dword ptr fs:[0x0]                  # 004089ba
    push eax                                     # 004089c0
    mov dword ptr fs:[0x0], esp                  # 004089c1
    sub esp, 0xc                                 # 004089c8
    push 0xa8c                                   # 004089cb
    call FUN_0051dc43                            # 004089d0
    add esp, 0x4                                 # 004089d5
    mov dword ptr [ebp - local_14], eax          # 004089d8
    mov dword ptr [ebp - local_4], 0x0           # 004089db
    cmp dword ptr [ebp - local_14], 0x0          # 004089e2
    je.d8 L_004089f5                             # 004089e6
    # block 0x004089e8: entered by fall-through of je at 0x004089e6, 4 instruction(s), calls FUN_00408a2a, ends with forward jump to 0x004089fc
    mov ecx, dword ptr [ebp - local_14]          # 004089e8
    call FUN_00408a2a                            # 004089eb
    mov dword ptr [ebp - local_18], eax          # 004089f0
    jmp.d8 L_004089fc                            # 004089f3
L_004089f5:
    # block 0x004089f5: entered by je at 0x004089e6, 1 instruction(s), falls into the block at 0x004089fc
    mov dword ptr [ebp - local_18], 0x0          # 004089f5
L_004089fc:
    # block 0x004089fc: entered by jmp at 0x004089f3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004089fc
    mov dword ptr [ebp - local_10], eax          # 004089ff
    mov dword ptr [ebp - local_4], 0xffffffff    # 00408a02
    mov eax, dword ptr [ebp - local_10]          # 00408a09
    mov ecx, dword ptr [ebp - local_c]           # 00408a0c
    mov dword ptr fs:[0x0], ecx                  # 00408a0f
    {load} mov esp, ebp                          # 00408a16
    pop ebp                                      # 00408a18
    ret                                          # 00408a19

