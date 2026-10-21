# FUN_00447db0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447db0
# extent:       0x00447db0-0x00447e17 (103 code bytes)
# span:         0x00447db0-0x00447e17 (code 103, tables 0, padding 0)
# sha256:       91cad78765d657f2081fc074c93f101e8414fcc58909efc1407e941a7c6b50d0
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447db0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m447db0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x22); returns 0x447e27(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00447e27
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m447db0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00447e27, .text + (0x00447e27 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00447db0 - 0x401000
.globl FUN_00447db0
FUN_00447db0:
    # block 0x00447db0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00447df2 (forward)
    push ebp                                     # 00447db0
    {load} mov ebp, esp                          # 00447db1
    push -0x1                                    # 00447db3
    push 0x527efa                                # 00447db5
    mov eax, dword ptr fs:[0x0]                  # 00447dba
    push eax                                     # 00447dc0
    mov dword ptr fs:[0x0], esp                  # 00447dc1
    sub esp, 0xc                                 # 00447dc8
    push 0x22                                    # 00447dcb
    call FUN_0051dc43                            # 00447dcd
    add esp, 0x4                                 # 00447dd2
    mov dword ptr [ebp - local_14], eax          # 00447dd5
    mov dword ptr [ebp - local_4], 0x0           # 00447dd8
    cmp dword ptr [ebp - local_14], 0x0          # 00447ddf
    je.d8 L_00447df2                             # 00447de3
    # block 0x00447de5: entered by fall-through of je at 0x00447de3, 4 instruction(s), calls FUN_00447e27, ends with forward jump to 0x00447df9
    mov ecx, dword ptr [ebp - local_14]          # 00447de5
    call FUN_00447e27                            # 00447de8
    mov dword ptr [ebp - local_18], eax          # 00447ded
    jmp.d8 L_00447df9                            # 00447df0
L_00447df2:
    # block 0x00447df2: entered by je at 0x00447de3, 1 instruction(s), falls into the block at 0x00447df9
    mov dword ptr [ebp - local_18], 0x0          # 00447df2
L_00447df9:
    # block 0x00447df9: entered by jmp at 0x00447df0, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00447df9
    mov dword ptr [ebp - local_10], eax          # 00447dfc
    mov dword ptr [ebp - local_4], 0xffffffff    # 00447dff
    mov eax, dword ptr [ebp - local_10]          # 00447e06
    mov ecx, dword ptr [ebp - local_c]           # 00447e09
    mov dword ptr fs:[0x0], ecx                  # 00447e0c
    {load} mov esp, ebp                          # 00447e13
    pop ebp                                      # 00447e15
    ret                                          # 00447e16

