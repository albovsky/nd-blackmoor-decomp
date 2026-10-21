# FUN_0048a620
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a620
# extent:       0x0048a620-0x0048a68a (106 code bytes)
# span:         0x0048a620-0x0048a68a (code 106, tables 0, padding 0)
# sha256:       e2e43a9ca9cb5a6b4b3c5dd9055b6658655166071885b80695d8ccdf397ac41a
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a620_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m48a620_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x1ce); returns 0x48a69a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0048a69a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m48a620_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_0048a69a, .text + (0x0048a69a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048a620 - 0x401000
.globl FUN_0048a620
FUN_0048a620:
    # block 0x0048a620: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0048a665 (forward)
    push ebp                                     # 0048a620
    {load} mov ebp, esp                          # 0048a621
    push -0x1                                    # 0048a623
    push 0x52845a                                # 0048a625
    mov eax, dword ptr fs:[0x0]                  # 0048a62a
    push eax                                     # 0048a630
    mov dword ptr fs:[0x0], esp                  # 0048a631
    sub esp, 0xc                                 # 0048a638
    push 0x1ce                                   # 0048a63b
    call FUN_0051dc43                            # 0048a640
    add esp, 0x4                                 # 0048a645
    mov dword ptr [ebp - local_14], eax          # 0048a648
    mov dword ptr [ebp - local_4], 0x0           # 0048a64b
    cmp dword ptr [ebp - local_14], 0x0          # 0048a652
    je.d8 L_0048a665                             # 0048a656
    # block 0x0048a658: entered by fall-through of je at 0x0048a656, 4 instruction(s), calls FUN_0048a69a, ends with forward jump to 0x0048a66c
    mov ecx, dword ptr [ebp - local_14]          # 0048a658
    call FUN_0048a69a                            # 0048a65b
    mov dword ptr [ebp - local_18], eax          # 0048a660
    jmp.d8 L_0048a66c                            # 0048a663
L_0048a665:
    # block 0x0048a665: entered by je at 0x0048a656, 1 instruction(s), falls into the block at 0x0048a66c
    mov dword ptr [ebp - local_18], 0x0          # 0048a665
L_0048a66c:
    # block 0x0048a66c: entered by jmp at 0x0048a663, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0048a66c
    mov dword ptr [ebp - local_10], eax          # 0048a66f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048a672
    mov eax, dword ptr [ebp - local_10]          # 0048a679
    mov ecx, dword ptr [ebp - local_c]           # 0048a67c
    mov dword ptr fs:[0x0], ecx                  # 0048a67f
    {load} mov esp, ebp                          # 0048a686
    pop ebp                                      # 0048a688
    ret                                          # 0048a689

