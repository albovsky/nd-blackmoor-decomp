# FUN_00446ed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446ed0
# extent:       0x00446ed0-0x00446efe (46 code bytes)
# span:         0x00446ed0-0x00446f00 (code 46, tables 0, padding 2)
# sha256:       4200c4875a87ee41271eeea0caf95b81d7aad0d1585831092f5abc976b51bfc4
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m446ed0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m446ed0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x445e0f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00445e0f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m446ed0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00445e0f, .text + (0x00445e0f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00446ed0 - 0x401000
.globl FUN_00446ed0
FUN_00446ed0:
    # block 0x00446ed0: entry, 10 instruction(s), calls FUN_00445e0f, ends with je to 0x00446ef5 (forward)
    push ebp                                     # 00446ed0
    {load} mov ebp, esp                          # 00446ed1
    push ecx                                     # 00446ed3
    mov dword ptr [ebp - local_4], ecx           # 00446ed4
    mov ecx, dword ptr [ebp - local_4]           # 00446ed7
    call FUN_00445e0f                            # 00446eda
    mov eax, dword ptr [ebp + arg_8]             # 00446edf
    and eax, 0x1                                 # 00446ee2
    test eax, eax                                # 00446ee5
    je.d8 L_00446ef5                             # 00446ee7
    # block 0x00446ee9: entered by fall-through of je at 0x00446ee7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00446ef5
    mov ecx, dword ptr [ebp - local_4]           # 00446ee9
    push ecx                                     # 00446eec
    call FUN_0051dc6c                            # 00446eed
    add esp, 0x4                                 # 00446ef2
L_00446ef5:
    # block 0x00446ef5: entered by je at 0x00446ee7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00446ef5
    {load} mov esp, ebp                          # 00446ef8
    pop ebp                                      # 00446efa
    ret 0x4                                      # 00446efb

# --- data items (not part of the function) -------------------------
.org 0x00446efe - 0x401000
PAD_00446efe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

