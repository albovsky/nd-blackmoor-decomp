# FUN_0045dd96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dd96
# extent:       0x0045dd96-0x0045ddd0 (58 code bytes)
# span:         0x0045dd96-0x0045ddd0 (code 58, tables 0, padding 0)
# sha256:       0019c8e05fe878d017f1c3a9e7ebfcec30e3eaede89f13a80a491583934cac1c
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45dd96_lifted
# naming:       native port src/original_methods_fl40.c:m45dd96_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 5 seeds; oracle 20/20 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_321; [ecx + n] field_1c; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45dd96_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_321, 0x321  # offset +0x321

# --- external targets -----------------------------------------------

.org 0x0045dd96 - 0x401000
.globl FUN_0045dd96
FUN_0045dd96:
    # block 0x0045dd96: entry, 9 instruction(s), ends with je to 0x0045ddcc (forward)
    push ebp                                     # 0045dd96
    {load} mov ebp, esp                          # 0045dd97
    push ecx                                     # 0045dd99
    mov dword ptr [ebp - local_4], ecx           # 0045dd9a
    mov eax, dword ptr [ebp - local_4]           # 0045dd9d
    {load} xor ecx, ecx                          # 0045dda0
    mov cl, byte ptr [eax + field_321]           # 0045dda2
    test ecx, ecx                                # 0045dda8
    je.d8 L_0045ddcc                             # 0045ddaa
    # block 0x0045ddac: entered by fall-through of je at 0x0045ddaa, 4 instruction(s), ends with je to 0x0045ddcc (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045ddac
    movsx eax, word ptr [edx + field_1c]         # 0045ddaf
    cmp eax, -0x1                                # 0045ddb3
    je.d8 L_0045ddcc                             # 0045ddb6
    # block 0x0045ddb8: entered by fall-through of je at 0x0045ddb6, 4 instruction(s), falls into the block at 0x0045ddcc
    mov ecx, dword ptr [ebp - local_4]           # 0045ddb8
    movsx edx, word ptr [ecx + field_1c]         # 0045ddbb
    imul edx, edx, 0x4a                          # 0045ddbf
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0045ddc2
L_0045ddcc:
    # block 0x0045ddcc: entered by je at 0x0045ddaa; je at 0x0045ddb6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045ddcc
    pop ebp                                      # 0045ddce
    ret                                          # 0045ddcf

