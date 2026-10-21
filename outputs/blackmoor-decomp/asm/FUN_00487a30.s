# FUN_00487a30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487a30
# extent:       0x00487a30-0x00487a9a (106 code bytes)
# span:         0x00487a30-0x00487a9a (code 106, tables 0, padding 0)
# sha256:       b882c5fe02a71a4be4cd0333b7707dc90bf72b5435fc6af53f74770f14039ad9
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487a30_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m487a30_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x9b); returns 0x487aaa(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00487aaa
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m487a30_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00487aaa, .text + (0x00487aaa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00487a30 - 0x401000
.globl FUN_00487a30
FUN_00487a30:
    # block 0x00487a30: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00487a75 (forward)
    push ebp                                     # 00487a30
    {load} mov ebp, esp                          # 00487a31
    push -0x1                                    # 00487a33
    push 0x52840a                                # 00487a35
    mov eax, dword ptr fs:[0x0]                  # 00487a3a
    push eax                                     # 00487a40
    mov dword ptr fs:[0x0], esp                  # 00487a41
    sub esp, 0xc                                 # 00487a48
    push 0x9b                                    # 00487a4b
    call FUN_0051dc43                            # 00487a50
    add esp, 0x4                                 # 00487a55
    mov dword ptr [ebp - local_14], eax          # 00487a58
    mov dword ptr [ebp - local_4], 0x0           # 00487a5b
    cmp dword ptr [ebp - local_14], 0x0          # 00487a62
    je.d8 L_00487a75                             # 00487a66
    # block 0x00487a68: entered by fall-through of je at 0x00487a66, 4 instruction(s), calls FUN_00487aaa, ends with forward jump to 0x00487a7c
    mov ecx, dword ptr [ebp - local_14]          # 00487a68
    call FUN_00487aaa                            # 00487a6b
    mov dword ptr [ebp - local_18], eax          # 00487a70
    jmp.d8 L_00487a7c                            # 00487a73
L_00487a75:
    # block 0x00487a75: entered by je at 0x00487a66, 1 instruction(s), falls into the block at 0x00487a7c
    mov dword ptr [ebp - local_18], 0x0          # 00487a75
L_00487a7c:
    # block 0x00487a7c: entered by jmp at 0x00487a73, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00487a7c
    mov dword ptr [ebp - local_10], eax          # 00487a7f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00487a82
    mov eax, dword ptr [ebp - local_10]          # 00487a89
    mov ecx, dword ptr [ebp - local_c]           # 00487a8c
    mov dword ptr fs:[0x0], ecx                  # 00487a8f
    {load} mov esp, ebp                          # 00487a96
    pop ebp                                      # 00487a98
    ret                                          # 00487a99

