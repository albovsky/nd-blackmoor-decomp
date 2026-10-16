# FUN_0046e580
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e580
# extent:       0x0046e580-0x0046e5ea (106 code bytes)
# span:         0x0046e580-0x0046e5ea (code 106, tables 0, padding 0)
# sha256:       c7f0047ae2a70d5490dd87e7d199f38649eaf030308c426d6ce58951468a6d79
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046e580
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0046e5fa
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
.set FUN_0046e5fa, .text + (0x0046e5fa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0046e580 - 0x401000
.globl FUN_0046e580
FUN_0046e580:
    # block 0x0046e580: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0046e5c5 (forward)
    push ebp                                     # 0046e580
    {load} mov ebp, esp                          # 0046e581
    push -0x1                                    # 0046e583
    push 0x52820a                                # 0046e585
    mov eax, dword ptr fs:[0x0]                  # 0046e58a
    push eax                                     # 0046e590
    mov dword ptr fs:[0x0], esp                  # 0046e591
    sub esp, 0xc                                 # 0046e598
    push 0x95                                    # 0046e59b
    call FUN_0051dc43                            # 0046e5a0
    add esp, 0x4                                 # 0046e5a5
    mov dword ptr [ebp - local_14], eax          # 0046e5a8
    mov dword ptr [ebp - local_4], 0x0           # 0046e5ab
    cmp dword ptr [ebp - local_14], 0x0          # 0046e5b2
    je.d8 L_0046e5c5                             # 0046e5b6
    # block 0x0046e5b8: entered by fall-through of je at 0x0046e5b6, 4 instruction(s), calls FUN_0046e5fa, ends with forward jump to 0x0046e5cc
    mov ecx, dword ptr [ebp - local_14]          # 0046e5b8
    call FUN_0046e5fa                            # 0046e5bb
    mov dword ptr [ebp - local_18], eax          # 0046e5c0
    jmp.d8 L_0046e5cc                            # 0046e5c3
L_0046e5c5:
    # block 0x0046e5c5: entered by je at 0x0046e5b6, 1 instruction(s), falls into the block at 0x0046e5cc
    mov dword ptr [ebp - local_18], 0x0          # 0046e5c5
L_0046e5cc:
    # block 0x0046e5cc: entered by jmp at 0x0046e5c3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0046e5cc
    mov dword ptr [ebp - local_10], eax          # 0046e5cf
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046e5d2
    mov eax, dword ptr [ebp - local_10]          # 0046e5d9
    mov ecx, dword ptr [ebp - local_c]           # 0046e5dc
    mov dword ptr fs:[0x0], ecx                  # 0046e5df
    {load} mov esp, ebp                          # 0046e5e6
    pop ebp                                      # 0046e5e8
    ret                                          # 0046e5e9

