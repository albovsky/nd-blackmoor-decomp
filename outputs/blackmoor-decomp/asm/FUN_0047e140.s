# FUN_0047e140
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e140
# extent:       0x0047e140-0x0047e16e (46 code bytes)
# span:         0x0047e140-0x0047e170 (code 46, tables 0, padding 2)
# sha256:       412d30c71c352d0254a4ef9b37b625fd727789ce94c18d62d05c13460bebafca
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47e140_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m47e140_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x47d4db(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047d4db, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m47e140_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0047d4db, .text + (0x0047d4db - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047e140 - 0x401000
.globl FUN_0047e140
FUN_0047e140:
    # block 0x0047e140: entry, 10 instruction(s), calls FUN_0047d4db, ends with je to 0x0047e165 (forward)
    push ebp                                     # 0047e140
    {load} mov ebp, esp                          # 0047e141
    push ecx                                     # 0047e143
    mov dword ptr [ebp - local_4], ecx           # 0047e144
    mov ecx, dword ptr [ebp - local_4]           # 0047e147
    call FUN_0047d4db                            # 0047e14a
    mov eax, dword ptr [ebp + arg_8]             # 0047e14f
    and eax, 0x1                                 # 0047e152
    test eax, eax                                # 0047e155
    je.d8 L_0047e165                             # 0047e157
    # block 0x0047e159: entered by fall-through of je at 0x0047e157, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047e165
    mov ecx, dword ptr [ebp - local_4]           # 0047e159
    push ecx                                     # 0047e15c
    call FUN_0051dc6c                            # 0047e15d
    add esp, 0x4                                 # 0047e162
L_0047e165:
    # block 0x0047e165: entered by je at 0x0047e157, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0047e165
    {load} mov esp, ebp                          # 0047e168
    pop ebp                                      # 0047e16a
    ret 0x4                                      # 0047e16b

# --- data items (not part of the function) -------------------------
.org 0x0047e16e - 0x401000
PAD_0047e16e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

