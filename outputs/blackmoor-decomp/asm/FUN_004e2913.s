# FUN_004e2913
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2913
# extent:       0x004e2913-0x004e2940 (45 code bytes)
# span:         0x004e2913-0x004e2940 (code 45, tables 0, padding 0)
# sha256:       8b05ea1a6c92484a58d8e7e742efd76158878fe37603e2769f2a9ab6d3b8dabd
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2913_lifted
# naming:       native port src/original_methods_fl39d.c:m4e2913_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (31 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_17b; [ecx + n] field_17b
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e2913_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_17b, 0x17b  # offset +0x17b

# --- external targets -----------------------------------------------

.org 0x004e2913 - 0x401000
.globl FUN_004e2913
FUN_004e2913:
    # block 0x004e2913: entry, 7 instruction(s), ends with je to 0x004e293a (forward)
    push ebp                                     # 004e2913
    {load} mov ebp, esp                          # 004e2914
    push ecx                                     # 004e2916
    mov dword ptr [ebp - local_4], ecx           # 004e2917
    mov eax, dword ptr [ebp - local_4]           # 004e291a
    cmp dword ptr [eax + field_17b], 0x0         # 004e291d
    je.d8 L_004e293a                             # 004e2924
    # block 0x004e2926: entered by fall-through of je at 0x004e2924, 4 instruction(s), ends with forward jump to 0x004e293c
    mov ecx, dword ptr [ebp - local_4]           # 004e2926
    mov dword ptr [ecx + field_17b], 0x0         # 004e2929
    mov eax, 0x1                                 # 004e2933
    jmp.d8 L_004e293c                            # 004e2938
L_004e293a:
    # block 0x004e293a: entered by je at 0x004e2924, 1 instruction(s), falls into the block at 0x004e293c
    {load} xor eax, eax                          # 004e293a
L_004e293c:
    # block 0x004e293c: entered by jmp at 0x004e2938, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e293c
    pop ebp                                      # 004e293e
    ret                                          # 004e293f

