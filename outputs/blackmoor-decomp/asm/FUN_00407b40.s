# FUN_00407b40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407b40
# extent:       0x00407b40-0x00407baa (106 code bytes)
# span:         0x00407b40-0x00407baa (code 106, tables 0, padding 0)
# sha256:       4f6075e2b7cbb18c44e273067b7fc99b30b9b2f2321fe16753519d867bb74cc8
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407b40_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m407b40_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x98c); returns 0x407bba(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00407bba
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m407b40_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00407bba, .text + (0x00407bba - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00407b40 - 0x401000
.globl FUN_00407b40
FUN_00407b40:
    # block 0x00407b40: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00407b85 (forward)
    push ebp                                     # 00407b40
    {load} mov ebp, esp                          # 00407b41
    push -0x1                                    # 00407b43
    push 0x526d4a                                # 00407b45
    mov eax, dword ptr fs:[0x0]                  # 00407b4a
    push eax                                     # 00407b50
    mov dword ptr fs:[0x0], esp                  # 00407b51
    sub esp, 0xc                                 # 00407b58
    push 0x98c                                   # 00407b5b
    call FUN_0051dc43                            # 00407b60
    add esp, 0x4                                 # 00407b65
    mov dword ptr [ebp - local_14], eax          # 00407b68
    mov dword ptr [ebp - local_4], 0x0           # 00407b6b
    cmp dword ptr [ebp - local_14], 0x0          # 00407b72
    je.d8 L_00407b85                             # 00407b76
    # block 0x00407b78: entered by fall-through of je at 0x00407b76, 4 instruction(s), calls FUN_00407bba, ends with forward jump to 0x00407b8c
    mov ecx, dword ptr [ebp - local_14]          # 00407b78
    call FUN_00407bba                            # 00407b7b
    mov dword ptr [ebp - local_18], eax          # 00407b80
    jmp.d8 L_00407b8c                            # 00407b83
L_00407b85:
    # block 0x00407b85: entered by je at 0x00407b76, 1 instruction(s), falls into the block at 0x00407b8c
    mov dword ptr [ebp - local_18], 0x0          # 00407b85
L_00407b8c:
    # block 0x00407b8c: entered by jmp at 0x00407b83, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00407b8c
    mov dword ptr [ebp - local_10], eax          # 00407b8f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00407b92
    mov eax, dword ptr [ebp - local_10]          # 00407b99
    mov ecx, dword ptr [ebp - local_c]           # 00407b9c
    mov dword ptr fs:[0x0], ecx                  # 00407b9f
    {load} mov esp, ebp                          # 00407ba6
    pop ebp                                      # 00407ba8
    ret                                          # 00407ba9

