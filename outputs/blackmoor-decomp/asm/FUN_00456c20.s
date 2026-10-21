# FUN_00456c20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456c20
# extent:       0x00456c20-0x00456c87 (103 code bytes)
# span:         0x00456c20-0x00456c87 (code 103, tables 0, padding 0)
# sha256:       405a19746372ea4c6a8095e5f30b72a48269d2a88993e015f209fa39050595c0
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m456c20_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m456c20_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x44); returns 0x456c97(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00456c97
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m456c20_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00456c97, .text + (0x00456c97 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00456c20 - 0x401000
.globl FUN_00456c20
FUN_00456c20:
    # block 0x00456c20: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00456c62 (forward)
    push ebp                                     # 00456c20
    {load} mov ebp, esp                          # 00456c21
    push -0x1                                    # 00456c23
    push 0x52802a                                # 00456c25
    mov eax, dword ptr fs:[0x0]                  # 00456c2a
    push eax                                     # 00456c30
    mov dword ptr fs:[0x0], esp                  # 00456c31
    sub esp, 0xc                                 # 00456c38
    push 0x44                                    # 00456c3b
    call FUN_0051dc43                            # 00456c3d
    add esp, 0x4                                 # 00456c42
    mov dword ptr [ebp - local_14], eax          # 00456c45
    mov dword ptr [ebp - local_4], 0x0           # 00456c48
    cmp dword ptr [ebp - local_14], 0x0          # 00456c4f
    je.d8 L_00456c62                             # 00456c53
    # block 0x00456c55: entered by fall-through of je at 0x00456c53, 4 instruction(s), calls FUN_00456c97, ends with forward jump to 0x00456c69
    mov ecx, dword ptr [ebp - local_14]          # 00456c55
    call FUN_00456c97                            # 00456c58
    mov dword ptr [ebp - local_18], eax          # 00456c5d
    jmp.d8 L_00456c69                            # 00456c60
L_00456c62:
    # block 0x00456c62: entered by je at 0x00456c53, 1 instruction(s), falls into the block at 0x00456c69
    mov dword ptr [ebp - local_18], 0x0          # 00456c62
L_00456c69:
    # block 0x00456c69: entered by jmp at 0x00456c60, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00456c69
    mov dword ptr [ebp - local_10], eax          # 00456c6c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00456c6f
    mov eax, dword ptr [ebp - local_10]          # 00456c76
    mov ecx, dword ptr [ebp - local_c]           # 00456c79
    mov dword ptr fs:[0x0], ecx                  # 00456c7c
    {load} mov esp, ebp                          # 00456c83
    pop ebp                                      # 00456c85
    ret                                          # 00456c86

