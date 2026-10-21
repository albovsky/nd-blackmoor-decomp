# FUN_00488cf0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488cf0
# extent:       0x00488cf0-0x00488d5a (106 code bytes)
# span:         0x00488cf0-0x00488d5a (code 106, tables 0, padding 0)
# sha256:       a4cba23fbfab55b4c9ff9bcbe13b24e89b0ce5e754d8e5bd508854ec398b6ddb
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m488cf0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m488cf0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0xd0); returns 0x488d6a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00488d6a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m488cf0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00488d6a, .text + (0x00488d6a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00488cf0 - 0x401000
.globl FUN_00488cf0
FUN_00488cf0:
    # block 0x00488cf0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00488d35 (forward)
    push ebp                                     # 00488cf0
    {load} mov ebp, esp                          # 00488cf1
    push -0x1                                    # 00488cf3
    push 0x52843a                                # 00488cf5
    mov eax, dword ptr fs:[0x0]                  # 00488cfa
    push eax                                     # 00488d00
    mov dword ptr fs:[0x0], esp                  # 00488d01
    sub esp, 0xc                                 # 00488d08
    push 0xd0                                    # 00488d0b
    call FUN_0051dc43                            # 00488d10
    add esp, 0x4                                 # 00488d15
    mov dword ptr [ebp - local_14], eax          # 00488d18
    mov dword ptr [ebp - local_4], 0x0           # 00488d1b
    cmp dword ptr [ebp - local_14], 0x0          # 00488d22
    je.d8 L_00488d35                             # 00488d26
    # block 0x00488d28: entered by fall-through of je at 0x00488d26, 4 instruction(s), calls FUN_00488d6a, ends with forward jump to 0x00488d3c
    mov ecx, dword ptr [ebp - local_14]          # 00488d28
    call FUN_00488d6a                            # 00488d2b
    mov dword ptr [ebp - local_18], eax          # 00488d30
    jmp.d8 L_00488d3c                            # 00488d33
L_00488d35:
    # block 0x00488d35: entered by je at 0x00488d26, 1 instruction(s), falls into the block at 0x00488d3c
    mov dword ptr [ebp - local_18], 0x0          # 00488d35
L_00488d3c:
    # block 0x00488d3c: entered by jmp at 0x00488d33, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00488d3c
    mov dword ptr [ebp - local_10], eax          # 00488d3f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00488d42
    mov eax, dword ptr [ebp - local_10]          # 00488d49
    mov ecx, dword ptr [ebp - local_c]           # 00488d4c
    mov dword ptr fs:[0x0], ecx                  # 00488d4f
    {load} mov esp, ebp                          # 00488d56
    pop ebp                                      # 00488d58
    ret                                          # 00488d59

