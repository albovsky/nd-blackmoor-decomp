# FUN_004487f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004487f0
# extent:       0x004487f0-0x0044881e (46 code bytes)
# span:         0x004487f0-0x00448820 (code 46, tables 0, padding 2)
# sha256:       f77b34f84d41317803c5fd737adb8cf241a4fa2bec3b9e43aad2afacd49483b8
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4487f0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4487f0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x447e46(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447e46, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4487f0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00447e46, .text + (0x00447e46 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004487f0 - 0x401000
.globl FUN_004487f0
FUN_004487f0:
    # block 0x004487f0: entry, 10 instruction(s), calls FUN_00447e46, ends with je to 0x00448815 (forward)
    push ebp                                     # 004487f0
    {load} mov ebp, esp                          # 004487f1
    push ecx                                     # 004487f3
    mov dword ptr [ebp - local_4], ecx           # 004487f4
    mov ecx, dword ptr [ebp - local_4]           # 004487f7
    call FUN_00447e46                            # 004487fa
    mov eax, dword ptr [ebp + arg_8]             # 004487ff
    and eax, 0x1                                 # 00448802
    test eax, eax                                # 00448805
    je.d8 L_00448815                             # 00448807
    # block 0x00448809: entered by fall-through of je at 0x00448807, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00448815
    mov ecx, dword ptr [ebp - local_4]           # 00448809
    push ecx                                     # 0044880c
    call FUN_0051dc6c                            # 0044880d
    add esp, 0x4                                 # 00448812
L_00448815:
    # block 0x00448815: entered by je at 0x00448807, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00448815
    {load} mov esp, ebp                          # 00448818
    pop ebp                                      # 0044881a
    ret 0x4                                      # 0044881b

# --- data items (not part of the function) -------------------------
.org 0x0044881e - 0x401000
PAD_0044881e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

