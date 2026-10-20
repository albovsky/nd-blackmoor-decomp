# FUN_004c2e5b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2e5b
# extent:       0x004c2e5b-0x004c2e97 (60 code bytes)
# span:         0x004c2e5b-0x004c2e97 (code 60, tables 0, padding 0)
# sha256:       e94e55f6430c1ea8935fe83ec3982d90045f6ef510a1601fd28546f751e25b93
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cel_free_layer_header
# naming:       native port src/action_family_3f_runtime.c:cel_free_layer_header (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the note is the acceptance note, a statement about the native port
# name-note:    Extracted from cel_free_slot_layers (no behaviour change): non-null header freed via host callback (original 0x51dc6c, a seam) and cleared. Tests-only: no oracle executes it whole; t_reader_rules checks the frees.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_free_layer_header (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c2e5b - 0x401000
.globl FUN_004c2e5b
FUN_004c2e5b:
    # block 0x004c2e5b: entry, 6 instruction(s), ends with jne to 0x004c2e6c (forward)
    push ebp                                     # 004c2e5b
    {load} mov ebp, esp                          # 004c2e5c
    sub esp, 0x8                                 # 004c2e5e
    mov dword ptr [ebp - local_8], ecx           # 004c2e61
    cmp dword ptr [ebp + arg_8], 0x0             # 004c2e64
    jne.d8 L_004c2e6c                            # 004c2e68
    # block 0x004c2e6a: entered by fall-through of jne at 0x004c2e68, 1 instruction(s), ends with forward jump to 0x004c2e91
    jmp.d8 L_004c2e91                            # 004c2e6a
L_004c2e6c:
    # block 0x004c2e6c: entered by jne at 0x004c2e68, 3 instruction(s), ends with je to 0x004c2e91 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004c2e6c
    cmp dword ptr [eax], 0x0                     # 004c2e6f
    je.d8 L_004c2e91                             # 004c2e72
    # block 0x004c2e74: entered by fall-through of je at 0x004c2e72, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c2e91
    mov ecx, dword ptr [ebp + arg_8]             # 004c2e74
    mov edx, dword ptr [ecx]                     # 004c2e77
    mov dword ptr [ebp - local_4], edx           # 004c2e79
    mov eax, dword ptr [ebp - local_4]           # 004c2e7c
    push eax                                     # 004c2e7f
    call FUN_0051dc6c                            # 004c2e80
    add esp, 0x4                                 # 004c2e85
    mov ecx, dword ptr [ebp + arg_8]             # 004c2e88
    mov dword ptr [ecx], 0x0                     # 004c2e8b
L_004c2e91:
    # block 0x004c2e91: entered by jmp at 0x004c2e6a; je at 0x004c2e72, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c2e91
    pop ebp                                      # 004c2e93
    ret 0x4                                      # 004c2e94

