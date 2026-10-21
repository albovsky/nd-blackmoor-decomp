# FUN_00459a00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459a00
# extent:       0x00459a00-0x00459a6a (106 code bytes)
# span:         0x00459a00-0x00459a6a (code 106, tables 0, padding 0)
# sha256:       f67c1d570263728c456c0b8aaf0e1a83c2558ea61309924dc2c5f9b5e3007eb9
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m459a00_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m459a00_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0xe2); returns 0x459a7a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00459a7a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m459a00_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00459a7a, .text + (0x00459a7a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00459a00 - 0x401000
.globl FUN_00459a00
FUN_00459a00:
    # block 0x00459a00: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00459a45 (forward)
    push ebp                                     # 00459a00
    {load} mov ebp, esp                          # 00459a01
    push -0x1                                    # 00459a03
    push 0x52808a                                # 00459a05
    mov eax, dword ptr fs:[0x0]                  # 00459a0a
    push eax                                     # 00459a10
    mov dword ptr fs:[0x0], esp                  # 00459a11
    sub esp, 0xc                                 # 00459a18
    push 0xe2                                    # 00459a1b
    call FUN_0051dc43                            # 00459a20
    add esp, 0x4                                 # 00459a25
    mov dword ptr [ebp - local_14], eax          # 00459a28
    mov dword ptr [ebp - local_4], 0x0           # 00459a2b
    cmp dword ptr [ebp - local_14], 0x0          # 00459a32
    je.d8 L_00459a45                             # 00459a36
    # block 0x00459a38: entered by fall-through of je at 0x00459a36, 4 instruction(s), calls FUN_00459a7a, ends with forward jump to 0x00459a4c
    mov ecx, dword ptr [ebp - local_14]          # 00459a38
    call FUN_00459a7a                            # 00459a3b
    mov dword ptr [ebp - local_18], eax          # 00459a40
    jmp.d8 L_00459a4c                            # 00459a43
L_00459a45:
    # block 0x00459a45: entered by je at 0x00459a36, 1 instruction(s), falls into the block at 0x00459a4c
    mov dword ptr [ebp - local_18], 0x0          # 00459a45
L_00459a4c:
    # block 0x00459a4c: entered by jmp at 0x00459a43, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00459a4c
    mov dword ptr [ebp - local_10], eax          # 00459a4f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00459a52
    mov eax, dword ptr [ebp - local_10]          # 00459a59
    mov ecx, dword ptr [ebp - local_c]           # 00459a5c
    mov dword ptr fs:[0x0], ecx                  # 00459a5f
    {load} mov esp, ebp                          # 00459a66
    pop ebp                                      # 00459a68
    ret                                          # 00459a69

