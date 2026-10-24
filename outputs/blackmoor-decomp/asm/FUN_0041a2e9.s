# FUN_0041a2e9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a2e9
# extent:       0x0041a2e9-0x0041a336 (77 code bytes)
# span:         0x0041a2e9-0x0041a336 (code 77, tables 0, padding 0)
# sha256:       4ec8f1fc2d52189975816a1c9c2bdd96ad4d46e37fc02dff5b80952212532b52
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a2e9_lifted
# naming:       native port src/original_methods_fl40.c:m41a2e9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 24/24 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_dc8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41a2e9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_dc8, 0xdc8  # offset +0xdc8

# --- external targets -----------------------------------------------

.org 0x0041a2e9 - 0x401000
.globl FUN_0041a2e9
FUN_0041a2e9:
    # block 0x0041a2e9: entry, 6 instruction(s), ends with forward jump to 0x0041a306
    push ebp                                     # 0041a2e9
    {load} mov ebp, esp                          # 0041a2ea
    sub esp, 0x8                                 # 0041a2ec
    mov dword ptr [ebp - local_8], ecx           # 0041a2ef
    mov word ptr [ebp - local_4], 0x0            # 0041a2f2
    jmp.d8 L_0041a306                            # 0041a2f8
L_0041a2fa:
    # block 0x0041a2fa: entered by jmp at 0x0041a32c, 3 instruction(s), falls into the block at 0x0041a306
    mov ax, word ptr [ebp - local_4]             # 0041a2fa
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041a2fe
    mov word ptr [ebp - local_4], ax             # 0041a302
L_0041a306:
    # block 0x0041a306: entered by jmp at 0x0041a2f8, 3 instruction(s), ends with jge to 0x0041a32e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041a306
    cmp ecx, 0x1e                                # 0041a30a
    jge.d8 L_0041a32e                            # 0041a30d
    # block 0x0041a30f: entered by fall-through of jge at 0x0041a30d, 5 instruction(s), ends with jne to 0x0041a32c (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041a30f
    imul edx, edx, 0x84d                         # 0041a313
    mov eax, dword ptr [ebp - local_8]           # 0041a319
    cmp dword ptr [eax + edx + field_dc8], 0x0   # 0041a31c
    jne.d8 L_0041a32c                            # 0041a324
    # block 0x0041a326: entered by fall-through of jne at 0x0041a324, 2 instruction(s), ends with forward jump to 0x0041a332
    mov ax, word ptr [ebp - local_4]             # 0041a326
    jmp.d8 L_0041a332                            # 0041a32a
L_0041a32c:
    # block 0x0041a32c: entered by jne at 0x0041a324, 1 instruction(s), ends with backward jump to 0x0041a2fa
    jmp.d8 L_0041a2fa                            # 0041a32c
L_0041a32e:
    # block 0x0041a32e: entered by jge at 0x0041a30d, 1 instruction(s), falls into the block at 0x0041a332
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041a32e
L_0041a332:
    # block 0x0041a332: entered by jmp at 0x0041a32a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041a332
    pop ebp                                      # 0041a334
    ret                                          # 0041a335

