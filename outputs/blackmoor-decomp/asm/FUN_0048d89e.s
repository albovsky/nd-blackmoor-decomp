# FUN_0048d89e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d89e
# extent:       0x0048d89e-0x0048d914 (118 code bytes)
# span:         0x0048d89e-0x0048d914 (code 118, tables 0, padding 0)
# sha256:       55dd6272c2e9078c8e422f614795c611341a334b0430382047c21ca69dce4303
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         solved_check
# naming:       native port src/action_family_d0_runtime.c:solved_check (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    solved_check compares order[i] with body+0x319 for body+0x317 entries, sets state 2 and solved byte +0x38 on full match, as the original; oracle compares the object image (+0x2b, +0x38) and the entry effect.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [ecx + n] field_2b, field_3d, field_317, field_319; [edx + n] field_38
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d0_runtime.c:solved_check (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2b, 0x2b  # offset +0x2b
.equ field_38, 0x38  # offset +0x38
.equ field_3d, 0x3d  # offset +0x3d
.equ field_317, 0x317  # offset +0x317
.equ field_319, 0x319  # offset +0x319

# --- external targets -----------------------------------------------

.org 0x0048d89e - 0x401000
.globl FUN_0048d89e
FUN_0048d89e:
    # block 0x0048d89e: entry, 11 instruction(s), ends with forward jump to 0x0048d8cf
    push ebp                                     # 0048d89e
    {load} mov ebp, esp                          # 0048d89f
    sub esp, 0xc                                 # 0048d8a1
    mov dword ptr [ebp - local_c], ecx           # 0048d8a4
    mov eax, dword ptr [ebp - local_c]           # 0048d8a7
    movsx ecx, word ptr [eax + field_1e]         # 0048d8aa
    imul ecx, ecx, 0x8d                          # 0048d8ae
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048d8b4
    mov dword ptr [ebp - local_8], edx           # 0048d8ba
    mov dword ptr [ebp - local_4], 0x0           # 0048d8bd
    jmp.d8 L_0048d8cf                            # 0048d8c4
L_0048d8c6:
    # block 0x0048d8c6: entered by jmp at 0x0048d8fd, 3 instruction(s), falls into the block at 0x0048d8cf
    mov eax, dword ptr [ebp - local_4]           # 0048d8c6
    add eax, 0x1                                 # 0048d8c9
    mov dword ptr [ebp - local_4], eax           # 0048d8cc
L_0048d8cf:
    # block 0x0048d8cf: entered by jmp at 0x0048d8c4, 4 instruction(s), ends with jge to 0x0048d8ff (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048d8cf
    movsx edx, word ptr [ecx + field_317]        # 0048d8d2
    cmp dword ptr [ebp - local_4], edx           # 0048d8d9
    jge.d8 L_0048d8ff                            # 0048d8dc
    # block 0x0048d8de: entered by fall-through of jge at 0x0048d8dc, 8 instruction(s), ends with je to 0x0048d8fd (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048d8de
    mov ecx, dword ptr [ebp - local_c]           # 0048d8e1
    movsx edx, word ptr [ecx + 2*eax + field_3d] # 0048d8e4
    mov eax, dword ptr [ebp - local_4]           # 0048d8e9
    mov ecx, dword ptr [ebp - local_8]           # 0048d8ec
    movsx eax, word ptr [ecx + 2*eax + field_319] # 0048d8ef
    {load} cmp edx, eax                          # 0048d8f7
    je.d8 L_0048d8fd                             # 0048d8f9
    # block 0x0048d8fb: entered by fall-through of je at 0x0048d8f9, 1 instruction(s), ends with forward jump to 0x0048d910
    jmp.d8 L_0048d910                            # 0048d8fb
L_0048d8fd:
    # block 0x0048d8fd: entered by je at 0x0048d8f9, 1 instruction(s), ends with backward jump to 0x0048d8c6
    jmp.d8 L_0048d8c6                            # 0048d8fd
L_0048d8ff:
    # block 0x0048d8ff: entered by jge at 0x0048d8dc, 4 instruction(s), falls into the block at 0x0048d910
    mov ecx, dword ptr [ebp - local_c]           # 0048d8ff
    mov dword ptr [ecx + field_2b], 0x2          # 0048d902
    mov edx, dword ptr [ebp - local_c]           # 0048d909
    mov byte ptr [edx + field_38], 0x1           # 0048d90c
L_0048d910:
    # block 0x0048d910: entered by jmp at 0x0048d8fb, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048d910
    pop ebp                                      # 0048d912
    ret                                          # 0048d913

