# FUN_0048ba30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ba30
# extent:       0x0048ba30-0x0048ba97 (103 code bytes)
# span:         0x0048ba30-0x0048ba97 (code 103, tables 0, padding 0)
# sha256:       cb487d1509cf3e68980662510e67c6cf590d245e62ff053efb64d480b50a978b
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ba30_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m48ba30_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x56); returns 0x48baa7(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0048baa7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m48ba30_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_0048baa7, .text + (0x0048baa7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048ba30 - 0x401000
.globl FUN_0048ba30
FUN_0048ba30:
    # block 0x0048ba30: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0048ba72 (forward)
    push ebp                                     # 0048ba30
    {load} mov ebp, esp                          # 0048ba31
    push -0x1                                    # 0048ba33
    push 0x52848a                                # 0048ba35
    mov eax, dword ptr fs:[0x0]                  # 0048ba3a
    push eax                                     # 0048ba40
    mov dword ptr fs:[0x0], esp                  # 0048ba41
    sub esp, 0xc                                 # 0048ba48
    push 0x56                                    # 0048ba4b
    call FUN_0051dc43                            # 0048ba4d
    add esp, 0x4                                 # 0048ba52
    mov dword ptr [ebp - local_14], eax          # 0048ba55
    mov dword ptr [ebp - local_4], 0x0           # 0048ba58
    cmp dword ptr [ebp - local_14], 0x0          # 0048ba5f
    je.d8 L_0048ba72                             # 0048ba63
    # block 0x0048ba65: entered by fall-through of je at 0x0048ba63, 4 instruction(s), calls FUN_0048baa7, ends with forward jump to 0x0048ba79
    mov ecx, dword ptr [ebp - local_14]          # 0048ba65
    call FUN_0048baa7                            # 0048ba68
    mov dword ptr [ebp - local_18], eax          # 0048ba6d
    jmp.d8 L_0048ba79                            # 0048ba70
L_0048ba72:
    # block 0x0048ba72: entered by je at 0x0048ba63, 1 instruction(s), falls into the block at 0x0048ba79
    mov dword ptr [ebp - local_18], 0x0          # 0048ba72
L_0048ba79:
    # block 0x0048ba79: entered by jmp at 0x0048ba70, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0048ba79
    mov dword ptr [ebp - local_10], eax          # 0048ba7c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048ba7f
    mov eax, dword ptr [ebp - local_10]          # 0048ba86
    mov ecx, dword ptr [ebp - local_c]           # 0048ba89
    mov dword ptr fs:[0x0], ecx                  # 0048ba8c
    {load} mov esp, ebp                          # 0048ba93
    pop ebp                                      # 0048ba95
    ret                                          # 0048ba96

