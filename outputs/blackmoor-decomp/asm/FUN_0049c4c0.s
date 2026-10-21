# FUN_0049c4c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c4c0
# extent:       0x0049c4c0-0x0049c52a (106 code bytes)
# span:         0x0049c4c0-0x0049c52a (code 106, tables 0, padding 0)
# sha256:       70d4928a955c9c8672e90e25770a8db0bcde94c7794f55680702825e472792d6
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c4c0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m49c4c0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0xe4c); returns 0x49c53a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0049c53a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m49c4c0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_0049c53a, .text + (0x0049c53a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0049c4c0 - 0x401000
.globl FUN_0049c4c0
FUN_0049c4c0:
    # block 0x0049c4c0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0049c505 (forward)
    push ebp                                     # 0049c4c0
    {load} mov ebp, esp                          # 0049c4c1
    push -0x1                                    # 0049c4c3
    push 0x52854a                                # 0049c4c5
    mov eax, dword ptr fs:[0x0]                  # 0049c4ca
    push eax                                     # 0049c4d0
    mov dword ptr fs:[0x0], esp                  # 0049c4d1
    sub esp, 0xc                                 # 0049c4d8
    push 0xe4c                                   # 0049c4db
    call FUN_0051dc43                            # 0049c4e0
    add esp, 0x4                                 # 0049c4e5
    mov dword ptr [ebp - local_14], eax          # 0049c4e8
    mov dword ptr [ebp - local_4], 0x0           # 0049c4eb
    cmp dword ptr [ebp - local_14], 0x0          # 0049c4f2
    je.d8 L_0049c505                             # 0049c4f6
    # block 0x0049c4f8: entered by fall-through of je at 0x0049c4f6, 4 instruction(s), calls FUN_0049c53a, ends with forward jump to 0x0049c50c
    mov ecx, dword ptr [ebp - local_14]          # 0049c4f8
    call FUN_0049c53a                            # 0049c4fb
    mov dword ptr [ebp - local_18], eax          # 0049c500
    jmp.d8 L_0049c50c                            # 0049c503
L_0049c505:
    # block 0x0049c505: entered by je at 0x0049c4f6, 1 instruction(s), falls into the block at 0x0049c50c
    mov dword ptr [ebp - local_18], 0x0          # 0049c505
L_0049c50c:
    # block 0x0049c50c: entered by jmp at 0x0049c503, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0049c50c
    mov dword ptr [ebp - local_10], eax          # 0049c50f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0049c512
    mov eax, dword ptr [ebp - local_10]          # 0049c519
    mov ecx, dword ptr [ebp - local_c]           # 0049c51c
    mov dword ptr fs:[0x0], ecx                  # 0049c51f
    {load} mov esp, ebp                          # 0049c526
    pop ebp                                      # 0049c528
    ret                                          # 0049c529

