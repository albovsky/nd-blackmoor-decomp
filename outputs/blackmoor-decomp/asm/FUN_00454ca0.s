# FUN_00454ca0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454ca0
# extent:       0x00454ca0-0x00454d0a (106 code bytes)
# span:         0x00454ca0-0x00454d0a (code 106, tables 0, padding 0)
# sha256:       0b65fd7d85627dcae5b0bdf92bfbc243665f6558c84428f6e201efa6acafeb61
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454ca0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m454ca0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x174); returns 0x454d1a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00454d1a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m454ca0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00454d1a, .text + (0x00454d1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00454ca0 - 0x401000
.globl FUN_00454ca0
FUN_00454ca0:
    # block 0x00454ca0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00454ce5 (forward)
    push ebp                                     # 00454ca0
    {load} mov ebp, esp                          # 00454ca1
    push -0x1                                    # 00454ca3
    push 0x527ffa                                # 00454ca5
    mov eax, dword ptr fs:[0x0]                  # 00454caa
    push eax                                     # 00454cb0
    mov dword ptr fs:[0x0], esp                  # 00454cb1
    sub esp, 0xc                                 # 00454cb8
    push 0x174                                   # 00454cbb
    call FUN_0051dc43                            # 00454cc0
    add esp, 0x4                                 # 00454cc5
    mov dword ptr [ebp - local_14], eax          # 00454cc8
    mov dword ptr [ebp - local_4], 0x0           # 00454ccb
    cmp dword ptr [ebp - local_14], 0x0          # 00454cd2
    je.d8 L_00454ce5                             # 00454cd6
    # block 0x00454cd8: entered by fall-through of je at 0x00454cd6, 4 instruction(s), calls FUN_00454d1a, ends with forward jump to 0x00454cec
    mov ecx, dword ptr [ebp - local_14]          # 00454cd8
    call FUN_00454d1a                            # 00454cdb
    mov dword ptr [ebp - local_18], eax          # 00454ce0
    jmp.d8 L_00454cec                            # 00454ce3
L_00454ce5:
    # block 0x00454ce5: entered by je at 0x00454cd6, 1 instruction(s), falls into the block at 0x00454cec
    mov dword ptr [ebp - local_18], 0x0          # 00454ce5
L_00454cec:
    # block 0x00454cec: entered by jmp at 0x00454ce3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00454cec
    mov dword ptr [ebp - local_10], eax          # 00454cef
    mov dword ptr [ebp - local_4], 0xffffffff    # 00454cf2
    mov eax, dword ptr [ebp - local_10]          # 00454cf9
    mov ecx, dword ptr [ebp - local_c]           # 00454cfc
    mov dword ptr fs:[0x0], ecx                  # 00454cff
    {load} mov esp, ebp                          # 00454d06
    pop ebp                                      # 00454d08
    ret                                          # 00454d09

