# FUN_00424035
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00424035
# extent:       0x00424035-0x0042405a (37 code bytes)
# span:         0x00424035-0x0042405a (code 37, tables 0, padding 0)
# sha256:       97e9fcceebbe3c3c5447a32f9a00bba1d7ab7d131bf0e15ef472c24d8ba1c056
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m424035_selected_slot
# naming:       native port src/original_methods_fl17.c:m424035_selected_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m424035_selected_slot; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 37 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24; [ecx + n] field_24; [edx + n] field_12
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m424035_selected_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_12, 0x12  # offset +0x12
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x00424035 - 0x401000
.globl FUN_00424035
FUN_00424035:
    # block 0x00424035: entry, 7 instruction(s), ends with jne to 0x0042404a (forward)
    push ebp                                     # 00424035
    {load} mov ebp, esp                          # 00424036
    push ecx                                     # 00424038
    mov dword ptr [ebp - local_4], ecx           # 00424039
    mov eax, dword ptr [ebp + arg_8]             # 0042403c
    cmp dword ptr [eax + field_24], 0x0          # 0042403f
    jne.d8 L_0042404a                            # 00424043
    # block 0x00424045: entered by fall-through of jne at 0x00424043, 2 instruction(s), ends with forward jump to 0x00424054
    or eax, -0x1                                 # 00424045
    jmp.d8 L_00424054                            # 00424048
L_0042404a:
    # block 0x0042404a: entered by jne at 0x00424043, 3 instruction(s), falls into the block at 0x00424054
    mov ecx, dword ptr [ebp + arg_8]             # 0042404a
    mov edx, dword ptr [ecx + field_24]          # 0042404d
    movsx eax, word ptr [edx + field_12]         # 00424050
L_00424054:
    # block 0x00424054: entered by jmp at 0x00424048, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00424054
    pop ebp                                      # 00424056
    ret 0x4                                      # 00424057

