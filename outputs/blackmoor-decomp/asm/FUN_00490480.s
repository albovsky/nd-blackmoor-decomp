# FUN_00490480
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00490480
# extent:       0x00490480-0x004904ea (106 code bytes)
# span:         0x00490480-0x004904ea (code 106, tables 0, padding 0)
# sha256:       851174aff1e23d7aaafd60848395d3a1cc6147ee7873be618325ad7b6f7700b3
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00490480
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004904fa
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
.set FUN_004904fa, .text + (0x004904fa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00490480 - 0x401000
.globl FUN_00490480
FUN_00490480:
    # block 0x00490480: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004904c5 (forward)
    push ebp                                     # 00490480
    {load} mov ebp, esp                          # 00490481
    push -0x1                                    # 00490483
    push 0x52851a                                # 00490485
    mov eax, dword ptr fs:[0x0]                  # 0049048a
    push eax                                     # 00490490
    mov dword ptr fs:[0x0], esp                  # 00490491
    sub esp, 0xc                                 # 00490498
    push 0x50fe                                  # 0049049b
    call FUN_0051dc43                            # 004904a0
    add esp, 0x4                                 # 004904a5
    mov dword ptr [ebp - local_14], eax          # 004904a8
    mov dword ptr [ebp - local_4], 0x0           # 004904ab
    cmp dword ptr [ebp - local_14], 0x0          # 004904b2
    je.d8 L_004904c5                             # 004904b6
    # block 0x004904b8: entered by fall-through of je at 0x004904b6, 4 instruction(s), calls FUN_004904fa, ends with forward jump to 0x004904cc
    mov ecx, dword ptr [ebp - local_14]          # 004904b8
    call FUN_004904fa                            # 004904bb
    mov dword ptr [ebp - local_18], eax          # 004904c0
    jmp.d8 L_004904cc                            # 004904c3
L_004904c5:
    # block 0x004904c5: entered by je at 0x004904b6, 1 instruction(s), falls into the block at 0x004904cc
    mov dword ptr [ebp - local_18], 0x0          # 004904c5
L_004904cc:
    # block 0x004904cc: entered by jmp at 0x004904c3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004904cc
    mov dword ptr [ebp - local_10], eax          # 004904cf
    mov dword ptr [ebp - local_4], 0xffffffff    # 004904d2
    mov eax, dword ptr [ebp - local_10]          # 004904d9
    mov ecx, dword ptr [ebp - local_c]           # 004904dc
    mov dword ptr fs:[0x0], ecx                  # 004904df
    {load} mov esp, ebp                          # 004904e6
    pop ebp                                      # 004904e8
    ret                                          # 004904e9

