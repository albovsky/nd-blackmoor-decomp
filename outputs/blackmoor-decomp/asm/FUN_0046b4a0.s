# FUN_0046b4a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b4a0
# extent:       0x0046b4a0-0x0046b50a (106 code bytes)
# span:         0x0046b4a0-0x0046b50a (code 106, tables 0, padding 0)
# sha256:       911e8325f8447154e61efc81e9d8e322e57a4a1a57a1916aac81e4d56e84f05b
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46b4a0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m46b4a0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x8302); returns 0x46b51a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0046b51a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m46b4a0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_0046b51a, .text + (0x0046b51a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0046b4a0 - 0x401000
.globl FUN_0046b4a0
FUN_0046b4a0:
    # block 0x0046b4a0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0046b4e5 (forward)
    push ebp                                     # 0046b4a0
    {load} mov ebp, esp                          # 0046b4a1
    push -0x1                                    # 0046b4a3
    push 0x5281da                                # 0046b4a5
    mov eax, dword ptr fs:[0x0]                  # 0046b4aa
    push eax                                     # 0046b4b0
    mov dword ptr fs:[0x0], esp                  # 0046b4b1
    sub esp, 0xc                                 # 0046b4b8
    push 0x8302                                  # 0046b4bb
    call FUN_0051dc43                            # 0046b4c0
    add esp, 0x4                                 # 0046b4c5
    mov dword ptr [ebp - local_14], eax          # 0046b4c8
    mov dword ptr [ebp - local_4], 0x0           # 0046b4cb
    cmp dword ptr [ebp - local_14], 0x0          # 0046b4d2
    je.d8 L_0046b4e5                             # 0046b4d6
    # block 0x0046b4d8: entered by fall-through of je at 0x0046b4d6, 4 instruction(s), calls FUN_0046b51a, ends with forward jump to 0x0046b4ec
    mov ecx, dword ptr [ebp - local_14]          # 0046b4d8
    call FUN_0046b51a                            # 0046b4db
    mov dword ptr [ebp - local_18], eax          # 0046b4e0
    jmp.d8 L_0046b4ec                            # 0046b4e3
L_0046b4e5:
    # block 0x0046b4e5: entered by je at 0x0046b4d6, 1 instruction(s), falls into the block at 0x0046b4ec
    mov dword ptr [ebp - local_18], 0x0          # 0046b4e5
L_0046b4ec:
    # block 0x0046b4ec: entered by jmp at 0x0046b4e3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0046b4ec
    mov dword ptr [ebp - local_10], eax          # 0046b4ef
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046b4f2
    mov eax, dword ptr [ebp - local_10]          # 0046b4f9
    mov ecx, dword ptr [ebp - local_c]           # 0046b4fc
    mov dword ptr fs:[0x0], ecx                  # 0046b4ff
    {load} mov esp, ebp                          # 0046b506
    pop ebp                                      # 0046b508
    ret                                          # 0046b509

