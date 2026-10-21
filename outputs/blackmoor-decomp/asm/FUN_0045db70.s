# FUN_0045db70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045db70
# extent:       0x0045db70-0x0045db9e (46 code bytes)
# span:         0x0045db70-0x0045dba0 (code 46, tables 0, padding 2)
# sha256:       087262357001269b884c9f9fb2aeb2eb36c46161a31760a73ef9435142a08e58
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45db70_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m45db70_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x45b3ce(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0045b3ce, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m45db70_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0045b3ce, .text + (0x0045b3ce - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0045db70 - 0x401000
.globl FUN_0045db70
FUN_0045db70:
    # block 0x0045db70: entry, 10 instruction(s), calls FUN_0045b3ce, ends with je to 0x0045db95 (forward)
    push ebp                                     # 0045db70
    {load} mov ebp, esp                          # 0045db71
    push ecx                                     # 0045db73
    mov dword ptr [ebp - local_4], ecx           # 0045db74
    mov ecx, dword ptr [ebp - local_4]           # 0045db77
    call FUN_0045b3ce                            # 0045db7a
    mov eax, dword ptr [ebp + arg_8]             # 0045db7f
    and eax, 0x1                                 # 0045db82
    test eax, eax                                # 0045db85
    je.d8 L_0045db95                             # 0045db87
    # block 0x0045db89: entered by fall-through of je at 0x0045db87, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0045db95
    mov ecx, dword ptr [ebp - local_4]           # 0045db89
    push ecx                                     # 0045db8c
    call FUN_0051dc6c                            # 0045db8d
    add esp, 0x4                                 # 0045db92
L_0045db95:
    # block 0x0045db95: entered by je at 0x0045db87, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0045db95
    {load} mov esp, ebp                          # 0045db98
    pop ebp                                      # 0045db9a
    ret 0x4                                      # 0045db9b

# --- data items (not part of the function) -------------------------
.org 0x0045db9e - 0x401000
PAD_0045db9e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

