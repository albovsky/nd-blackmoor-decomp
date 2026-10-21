# FUN_004a7b90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7b90
# extent:       0x004a7b90-0x004a7bfa (106 code bytes)
# span:         0x004a7b90-0x004a7bfa (code 106, tables 0, padding 0)
# sha256:       c14edd2ce946a0bcbc098fc667c3a49aa2e2a8a64452e4f72832e864addabaf2
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7b90_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m4a7b90_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x13fd); returns 0x4a7c0a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004a7c0a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4a7b90_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_004a7c0a, .text + (0x004a7c0a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a7b90 - 0x401000
.globl FUN_004a7b90
FUN_004a7b90:
    # block 0x004a7b90: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004a7bd5 (forward)
    push ebp                                     # 004a7b90
    {load} mov ebp, esp                          # 004a7b91
    push -0x1                                    # 004a7b93
    push 0x52861a                                # 004a7b95
    mov eax, dword ptr fs:[0x0]                  # 004a7b9a
    push eax                                     # 004a7ba0
    mov dword ptr fs:[0x0], esp                  # 004a7ba1
    sub esp, 0xc                                 # 004a7ba8
    push 0x13fd                                  # 004a7bab
    call FUN_0051dc43                            # 004a7bb0
    add esp, 0x4                                 # 004a7bb5
    mov dword ptr [ebp - local_14], eax          # 004a7bb8
    mov dword ptr [ebp - local_4], 0x0           # 004a7bbb
    cmp dword ptr [ebp - local_14], 0x0          # 004a7bc2
    je.d8 L_004a7bd5                             # 004a7bc6
    # block 0x004a7bc8: entered by fall-through of je at 0x004a7bc6, 4 instruction(s), calls FUN_004a7c0a, ends with forward jump to 0x004a7bdc
    mov ecx, dword ptr [ebp - local_14]          # 004a7bc8
    call FUN_004a7c0a                            # 004a7bcb
    mov dword ptr [ebp - local_18], eax          # 004a7bd0
    jmp.d8 L_004a7bdc                            # 004a7bd3
L_004a7bd5:
    # block 0x004a7bd5: entered by je at 0x004a7bc6, 1 instruction(s), falls into the block at 0x004a7bdc
    mov dword ptr [ebp - local_18], 0x0          # 004a7bd5
L_004a7bdc:
    # block 0x004a7bdc: entered by jmp at 0x004a7bd3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004a7bdc
    mov dword ptr [ebp - local_10], eax          # 004a7bdf
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a7be2
    mov eax, dword ptr [ebp - local_10]          # 004a7be9
    mov ecx, dword ptr [ebp - local_c]           # 004a7bec
    mov dword ptr fs:[0x0], ecx                  # 004a7bef
    {load} mov esp, ebp                          # 004a7bf6
    pop ebp                                      # 004a7bf8
    ret                                          # 004a7bf9

