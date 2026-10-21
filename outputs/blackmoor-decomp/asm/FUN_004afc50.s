# FUN_004afc50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afc50
# extent:       0x004afc50-0x004afcba (106 code bytes)
# span:         0x004afc50-0x004afcba (code 106, tables 0, padding 0)
# sha256:       e6c405060e7f3cdd367474576a88c9e15f5bb84260d24b6c58ef00cbd6170e01
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4afc50_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m4afc50_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x1541); returns 0x4afcca(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004afcca
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4afc50_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_004afcca, .text + (0x004afcca - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004afc50 - 0x401000
.globl FUN_004afc50
FUN_004afc50:
    # block 0x004afc50: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004afc95 (forward)
    push ebp                                     # 004afc50
    {load} mov ebp, esp                          # 004afc51
    push -0x1                                    # 004afc53
    push 0x5286da                                # 004afc55
    mov eax, dword ptr fs:[0x0]                  # 004afc5a
    push eax                                     # 004afc60
    mov dword ptr fs:[0x0], esp                  # 004afc61
    sub esp, 0xc                                 # 004afc68
    push 0x1541                                  # 004afc6b
    call FUN_0051dc43                            # 004afc70
    add esp, 0x4                                 # 004afc75
    mov dword ptr [ebp - local_14], eax          # 004afc78
    mov dword ptr [ebp - local_4], 0x0           # 004afc7b
    cmp dword ptr [ebp - local_14], 0x0          # 004afc82
    je.d8 L_004afc95                             # 004afc86
    # block 0x004afc88: entered by fall-through of je at 0x004afc86, 4 instruction(s), calls FUN_004afcca, ends with forward jump to 0x004afc9c
    mov ecx, dword ptr [ebp - local_14]          # 004afc88
    call FUN_004afcca                            # 004afc8b
    mov dword ptr [ebp - local_18], eax          # 004afc90
    jmp.d8 L_004afc9c                            # 004afc93
L_004afc95:
    # block 0x004afc95: entered by je at 0x004afc86, 1 instruction(s), falls into the block at 0x004afc9c
    mov dword ptr [ebp - local_18], 0x0          # 004afc95
L_004afc9c:
    # block 0x004afc9c: entered by jmp at 0x004afc93, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004afc9c
    mov dword ptr [ebp - local_10], eax          # 004afc9f
    mov dword ptr [ebp - local_4], 0xffffffff    # 004afca2
    mov eax, dword ptr [ebp - local_10]          # 004afca9
    mov ecx, dword ptr [ebp - local_c]           # 004afcac
    mov dword ptr fs:[0x0], ecx                  # 004afcaf
    {load} mov esp, ebp                          # 004afcb6
    pop ebp                                      # 004afcb8
    ret                                          # 004afcb9

