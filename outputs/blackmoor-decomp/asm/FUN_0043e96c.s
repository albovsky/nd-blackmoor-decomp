# FUN_0043e96c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043e96c
# extent:       0x0043e96c-0x0043eab0 (324 code bytes)
# span:         0x0043e96c-0x0043eab0 (code 324, tables 0, padding 0)
# sha256:       b477293ef99886349d5dfd2b5660451d5610ec0af97cc63b83c21dfa3b41e4f8
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43e96c_lifted
# naming:       native port src/original_methods_fl40.c:m43e96c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 71/71 instructions executed, 8/8 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c, FUN_00423b51, FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43e96c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 71 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043e96c - 0x401000
.globl FUN_0043e96c
FUN_0043e96c:
    # block 0x0043e96c: entry, 5 instruction(s), ends with forward jump to 0x0043e984
    push ebp                                     # 0043e96c
    {load} mov ebp, esp                          # 0043e96d
    sub esp, 0x8                                 # 0043e96f
    mov dword ptr [ebp - local_4], 0x0           # 0043e972
    jmp.d8 L_0043e984                            # 0043e979
L_0043e97b:
    # block 0x0043e97b: entered by jmp at 0x0043eaa7, 3 instruction(s), falls into the block at 0x0043e984
    mov eax, dword ptr [ebp - local_4]           # 0043e97b
    add eax, 0x1                                 # 0043e97e
    mov dword ptr [ebp - local_4], eax           # 0043e981
L_0043e984:
    # block 0x0043e984: entered by jmp at 0x0043e979, 3 instruction(s), ends with jge to 0x0043eaac (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0043e984
    cmp dword ptr [ebp - local_4], ecx           # 0043e98b
    jge.d32 L_0043eaac                           # 0043e98e
    # block 0x0043e994: entered by fall-through of jge at 0x0043e98e, 4 instruction(s), ends with je to 0x0043eaa7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0043e994
    imul edx, edx, 0x8d                          # 0043e997
    cmp dword ptr [edx + 0x5bb63c], 0x0          # 0043e99d
    je.d32 L_0043eaa7                            # 0043e9a4
    # block 0x0043e9aa: entered by fall-through of je at 0x0043e9a4, 4 instruction(s), ends with je to 0x0043e9ed (forward)
    mov eax, dword ptr [ebp - local_4]           # 0043e9aa
    imul eax, eax, 0x8d                          # 0043e9ad
    cmp dword ptr [eax + 0x5bb5e5], 0x0          # 0043e9b3
    je.d8 L_0043e9ed                             # 0043e9ba
    # block 0x0043e9bc: entered by fall-through of je at 0x0043e9ba, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e9ed
    mov ecx, dword ptr [ebp - local_4]           # 0043e9bc
    imul ecx, ecx, 0x8d                          # 0043e9bf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043e9c5
    mov dword ptr [ebp - local_8], edx           # 0043e9cb
    mov eax, dword ptr [ebp - local_8]           # 0043e9ce
    push eax                                     # 0043e9d1
    call FUN_0051dc6c                            # 0043e9d2
    add esp, 0x4                                 # 0043e9d7
    mov ecx, dword ptr [ebp - local_4]           # 0043e9da
    imul ecx, ecx, 0x8d                          # 0043e9dd
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 0043e9e3
L_0043e9ed:
    # block 0x0043e9ed: entered by je at 0x0043e9ba, 28 instruction(s), calls FUN_00423b51, ends with je to 0x0043eaa7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0043e9ed
    imul edx, edx, 0x8d                          # 0043e9f0
    mov byte ptr [edx + 0x5bb5e3], 0x0           # 0043e9f6
    mov eax, dword ptr [ebp - local_4]           # 0043e9fd
    imul eax, eax, 0x8d                          # 0043ea00
    mov byte ptr [eax + 0x5bb625], 0x0           # 0043ea06
    mov ecx, dword ptr [ebp - local_4]           # 0043ea0d
    imul ecx, ecx, 0x8d                          # 0043ea10
    mov dword ptr [ecx + 0x5bb626], 0x0          # 0043ea16
    mov edx, dword ptr [ebp - local_4]           # 0043ea20
    imul edx, edx, 0x8d                          # 0043ea23
    mov dword ptr [edx + 0x5bb632], 0x0          # 0043ea29
    mov eax, dword ptr [ebp - local_4]           # 0043ea33
    imul eax, eax, 0x8d                          # 0043ea36
    mov word ptr [eax + 0x5bb636], 0xffff        # 0043ea3c
    mov ecx, dword ptr [ebp - local_4]           # 0043ea45
    imul ecx, ecx, 0x8d                          # 0043ea48
    mov dword ptr [ecx + 0x5bb638], 0x1          # 0043ea4e
    mov edx, dword ptr [ebp - local_4]           # 0043ea58
    imul edx, edx, 0x8d                          # 0043ea5b
    mov dword ptr [edx + 0x5bb63c], 0x0          # 0043ea61
    mov eax, dword ptr [ebp - local_4]           # 0043ea6b
    push eax                                     # 0043ea6e
    mov ecx, 0x63786d                            # 0043ea6f
    call FUN_00423b51                            # 0043ea74
    movsx ecx, word ptr [0x63a4cd]               # 0043ea79
    test ecx, ecx                                # 0043ea80
    je.d8 L_0043eaa7                             # 0043ea82
    # block 0x0043ea84: entered by fall-through of je at 0x0043ea82, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0043eaa7
    mov edx, dword ptr [ebp - local_4]           # 0043ea84
    push edx                                     # 0043ea87
    push 0x5476fc                                # 0043ea88
    push 0x63888b                                # 0043ea8d
    call FUN_0050ca3e                            # 0043ea92
    add esp, 0xc                                 # 0043ea97
    push 0x63888b                                # 0043ea9a
    call FUN_0044a2b7                            # 0043ea9f
    add esp, 0x4                                 # 0043eaa4
L_0043eaa7:
    # block 0x0043eaa7: entered by je at 0x0043e9a4; je at 0x0043ea82, 1 instruction(s), ends with backward jump to 0x0043e97b
    jmp.d32 L_0043e97b                           # 0043eaa7
L_0043eaac:
    # block 0x0043eaac: entered by jge at 0x0043e98e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0043eaac
    pop ebp                                      # 0043eaae
    ret                                          # 0043eaaf

