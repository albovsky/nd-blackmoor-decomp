# FUN_004ab9fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab9fa
# extent:       0x004ab9fa-0x004aba6d (115 code bytes)
# span:         0x004ab9fa-0x004aba6d (code 115, tables 0, padding 0)
# sha256:       04685c356330a173f9b983ae737caf0dd93d98361c8073535a819fef1ca8becf
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab9fa_lifted
# naming:       native port src/original_methods_fl41.c:m4ab9fa_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 35/35 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [ecx + n] field_21, field_48, field_59, field_aab; [edx + n] field_5e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ab9fa_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_48, 0x48  # offset +0x48
.equ field_59, 0x59  # offset +0x59
.equ field_5e, 0x5e  # offset +0x5e
.equ field_aab, 0xaab  # offset +0xaab

# --- external targets -----------------------------------------------

.org 0x004ab9fa - 0x401000
.globl FUN_004ab9fa
FUN_004ab9fa:
    # block 0x004ab9fa: entry, 11 instruction(s), ends with forward jump to 0x004aba2b
    push ebp                                     # 004ab9fa
    {load} mov ebp, esp                          # 004ab9fb
    sub esp, 0xc                                 # 004ab9fd
    mov dword ptr [ebp - local_c], ecx           # 004aba00
    mov eax, dword ptr [ebp - local_c]           # 004aba03
    movsx ecx, word ptr [eax + field_1e]         # 004aba06
    imul ecx, ecx, 0x8d                          # 004aba0a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004aba10
    mov dword ptr [ebp - local_8], edx           # 004aba16
    mov dword ptr [ebp - local_4], 0x0           # 004aba19
    jmp.d8 L_004aba2b                            # 004aba20
L_004aba22:
    # block 0x004aba22: entered by jmp at 0x004aba56, 3 instruction(s), falls into the block at 0x004aba2b
    mov eax, dword ptr [ebp - local_4]           # 004aba22
    add eax, 0x1                                 # 004aba25
    mov dword ptr [ebp - local_4], eax           # 004aba28
L_004aba2b:
    # block 0x004aba2b: entered by jmp at 0x004aba20, 4 instruction(s), ends with jge to 0x004aba58 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004aba2b
    movsx edx, word ptr [ecx + field_21]         # 004aba2e
    cmp dword ptr [ebp - local_4], edx           # 004aba32
    jge.d8 L_004aba58                            # 004aba35
    # block 0x004aba37: entered by fall-through of jge at 0x004aba35, 8 instruction(s), ends with je to 0x004aba56 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004aba37
    mov ecx, dword ptr [ebp - local_c]           # 004aba3a
    movsx edx, word ptr [ecx + 2*eax + field_48] # 004aba3d
    mov eax, dword ptr [ebp - local_4]           # 004aba42
    mov ecx, dword ptr [ebp - local_8]           # 004aba45
    movsx eax, word ptr [ecx + 2*eax + field_aab] # 004aba48
    {load} cmp edx, eax                          # 004aba50
    je.d8 L_004aba56                             # 004aba52
    # block 0x004aba54: entered by fall-through of je at 0x004aba52, 1 instruction(s), ends with forward jump to 0x004aba69
    jmp.d8 L_004aba69                            # 004aba54
L_004aba56:
    # block 0x004aba56: entered by je at 0x004aba52, 1 instruction(s), ends with backward jump to 0x004aba22
    jmp.d8 L_004aba22                            # 004aba56
L_004aba58:
    # block 0x004aba58: entered by jge at 0x004aba35, 4 instruction(s), falls into the block at 0x004aba69
    mov ecx, dword ptr [ebp - local_c]           # 004aba58
    mov byte ptr [ecx + field_59], 0x1           # 004aba5b
    mov edx, dword ptr [ebp - local_c]           # 004aba5f
    mov dword ptr [edx + field_5e], 0x1          # 004aba62
L_004aba69:
    # block 0x004aba69: entered by jmp at 0x004aba54, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004aba69
    pop ebp                                      # 004aba6b
    ret                                          # 004aba6c

