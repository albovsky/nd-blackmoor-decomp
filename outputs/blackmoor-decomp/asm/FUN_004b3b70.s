# FUN_004b3b70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3b70
# extent:       0x004b3b70-0x004b3bda (106 code bytes)
# span:         0x004b3b70-0x004b3bda (code 106, tables 0, padding 0)
# sha256:       aa361b1c438455c33261addfd1aa5ebf07c3f9a4a4f40d04065a84cb80565099
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3b70_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m4b3b70_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x782); returns 0x4b3bea(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004b3bea
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4b3b70_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.set FUN_004b3bea, .text + (0x004b3bea - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004b3b70 - 0x401000
.globl FUN_004b3b70
FUN_004b3b70:
    # block 0x004b3b70: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004b3bb5 (forward)
    push ebp                                     # 004b3b70
    {load} mov ebp, esp                          # 004b3b71
    push -0x1                                    # 004b3b73
    push 0x52870a                                # 004b3b75
    mov eax, dword ptr fs:[0x0]                  # 004b3b7a
    push eax                                     # 004b3b80
    mov dword ptr fs:[0x0], esp                  # 004b3b81
    sub esp, 0xc                                 # 004b3b88
    push 0x782                                   # 004b3b8b
    call FUN_0051dc43                            # 004b3b90
    add esp, 0x4                                 # 004b3b95
    mov dword ptr [ebp - local_14], eax          # 004b3b98
    mov dword ptr [ebp - local_4], 0x0           # 004b3b9b
    cmp dword ptr [ebp - local_14], 0x0          # 004b3ba2
    je.d8 L_004b3bb5                             # 004b3ba6
    # block 0x004b3ba8: entered by fall-through of je at 0x004b3ba6, 4 instruction(s), calls FUN_004b3bea, ends with forward jump to 0x004b3bbc
    mov ecx, dword ptr [ebp - local_14]          # 004b3ba8
    call FUN_004b3bea                            # 004b3bab
    mov dword ptr [ebp - local_18], eax          # 004b3bb0
    jmp.d8 L_004b3bbc                            # 004b3bb3
L_004b3bb5:
    # block 0x004b3bb5: entered by je at 0x004b3ba6, 1 instruction(s), falls into the block at 0x004b3bbc
    mov dword ptr [ebp - local_18], 0x0          # 004b3bb5
L_004b3bbc:
    # block 0x004b3bbc: entered by jmp at 0x004b3bb3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004b3bbc
    mov dword ptr [ebp - local_10], eax          # 004b3bbf
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b3bc2
    mov eax, dword ptr [ebp - local_10]          # 004b3bc9
    mov ecx, dword ptr [ebp - local_c]           # 004b3bcc
    mov dword ptr fs:[0x0], ecx                  # 004b3bcf
    {load} mov esp, ebp                          # 004b3bd6
    pop ebp                                      # 004b3bd8
    ret                                          # 004b3bd9

