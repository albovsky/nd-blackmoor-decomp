# FUN_0044fb54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044fb54
# extent:       0x0044fb54-0x0044fb88 (52 code bytes)
# span:         0x0044fb54-0x0044fb88 (code 52, tables 0, padding 0)
# sha256:       bbeb1eb20f3be6a1227dc927f3d80fb49f7397322643bc23de4a98a25333fc43
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44fb54_lifted
# naming:       native port src/original_methods_fl40.c:m44fb54_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 18/18 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_14; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44fb54_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0044fb54 - 0x401000
.globl FUN_0044fb54
FUN_0044fb54:
    # block 0x0044fb54: entry, 7 instruction(s), ends with je to 0x0044fb84 (forward)
    push ebp                                     # 0044fb54
    {load} mov ebp, esp                          # 0044fb55
    push ecx                                     # 0044fb57
    mov dword ptr [ebp - local_4], ecx           # 0044fb58
    mov eax, dword ptr [ebp - local_4]           # 0044fb5b
    cmp dword ptr [eax + field_14], 0x0          # 0044fb5e
    je.d8 L_0044fb84                             # 0044fb62
    # block 0x0044fb64: entered by fall-through of je at 0x0044fb62, 4 instruction(s), ends with je to 0x0044fb84 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044fb64
    movsx edx, word ptr [ecx + field_4]          # 0044fb67
    cmp edx, -0x1                                # 0044fb6b
    je.d8 L_0044fb84                             # 0044fb6e
    # block 0x0044fb70: entered by fall-through of je at 0x0044fb6e, 4 instruction(s), falls into the block at 0x0044fb84
    mov eax, dword ptr [ebp - local_4]           # 0044fb70
    movsx ecx, word ptr [eax + field_4]          # 0044fb73
    imul ecx, ecx, 0x4a                          # 0044fb77
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0044fb7a
L_0044fb84:
    # block 0x0044fb84: entered by je at 0x0044fb62; je at 0x0044fb6e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044fb84
    pop ebp                                      # 0044fb86
    ret                                          # 0044fb87

