# FUN_004ab85a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab85a
# extent:       0x004ab85a-0x004ab899 (63 code bytes)
# span:         0x004ab85a-0x004ab899 (code 63, tables 0, padding 0)
# sha256:       abd829e7759b1d071295bf900a330643e25fd7bc8025b7c3547aa10b7bf0f9fb
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab85a_lifted
# naming:       native port src/original_methods_fl41.c:m4ab85a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 18/18 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [ecx + n] field_31
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ab85a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_31, 0x31  # offset +0x31

# --- external targets -----------------------------------------------

.org 0x004ab85a - 0x401000
.globl FUN_004ab85a
FUN_004ab85a:
    # block 0x004ab85a: entry, 18 instruction(s), ends with ret 0x4
    push ebp                                     # 004ab85a
    {load} mov ebp, esp                          # 004ab85b
    sub esp, 0xc                                 # 004ab85d
    mov dword ptr [ebp - local_c], ecx           # 004ab860
    mov word ptr [ebp - local_8], 0x0            # 004ab863
    mov eax, dword ptr [ebp - local_c]           # 004ab869
    movsx ecx, word ptr [eax + field_1e]         # 004ab86c
    imul ecx, ecx, 0x8d                          # 004ab870
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ab876
    mov dword ptr [ebp - local_4], edx           # 004ab87c
    movsx eax, word ptr [ebp + arg_8]            # 004ab87f
    mov ecx, dword ptr [ebp - local_4]           # 004ab883
    mov dx, word ptr [ecx + 2*eax + field_31]    # 004ab886
    mov word ptr [ebp - local_8], dx             # 004ab88b
    mov ax, word ptr [ebp - local_8]             # 004ab88f
    {load} mov esp, ebp                          # 004ab893
    pop ebp                                      # 004ab895
    ret 0x4                                      # 004ab896

