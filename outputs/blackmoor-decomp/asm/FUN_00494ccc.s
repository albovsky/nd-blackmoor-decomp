# FUN_00494ccc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00494ccc
# extent:       0x00494ccc-0x00494d54 (136 code bytes)
# span:         0x00494ccc-0x00494d54 (code 136, tables 0, padding 0)
# sha256:       3714130fa9ea1ac302674a5eda304652520249e1054ea38f1d91d2a2fa64b50c
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m494ccc_lifted
# naming:       native port src/original_methods_fl41.c:m494ccc_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 2 seeds; oracle: 36/36 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1f93, field_1fa7; [edx + n] field_1f7f, field_1fff
# callees:      calls FUN_004dadff, FUN_00494d54, FUN_004c3efb, FUN_00496410, FUN_004c4202
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m494ccc_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 36 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1f7f, 0x1f7f  # offset +0x1f7f
.equ field_1f93, 0x1f93  # offset +0x1f93
.equ field_1fa7, 0x1fa7  # offset +0x1fa7
.equ field_1fff, 0x1fff  # offset +0x1fff

# --- external targets -----------------------------------------------
.set FUN_00494d54, .text + (0x00494d54 - 0x401000)
.set FUN_00496410, .text + (0x00496410 - 0x401000)
.set FUN_004c3efb, .text + (0x004c3efb - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)

.org 0x00494ccc - 0x401000
.globl FUN_00494ccc
FUN_00494ccc:
    # block 0x00494ccc: entry, 36 instruction(s), calls FUN_004dadff, FUN_00494d54, FUN_004c3efb, FUN_00496410, FUN_004c4202, ends with ret
    push ebp                                     # 00494ccc
    {load} mov ebp, esp                          # 00494ccd
    push ecx                                     # 00494ccf
    mov dword ptr [ebp - local_4], ecx           # 00494cd0
    mov ecx, 0x5830a6                            # 00494cd3
    call FUN_004dadff                            # 00494cd8
    mov ecx, dword ptr [ebp - local_4]           # 00494cdd
    call FUN_00494d54                            # 00494ce0
    push 0x54f800                                # 00494ce5
    mov eax, dword ptr [ebp - local_4]           # 00494cea
    add eax, 0x1f83                              # 00494ced
    push eax                                     # 00494cf2
    push 0x583186                                # 00494cf3
    mov ecx, dword ptr [0x5cf665]                # 00494cf8
    push ecx                                     # 00494cfe
    mov ecx, 0x5cf659                            # 00494cff
    call FUN_004c3efb                            # 00494d04
    mov edx, dword ptr [ebp - local_4]           # 00494d09
    mov eax, dword ptr [ebp - local_4]           # 00494d0c
    mov ecx, dword ptr [eax + field_1fa7]        # 00494d0f
    mov dword ptr [edx + field_1f7f], ecx        # 00494d15
    mov edx, dword ptr [ebp - local_4]           # 00494d1b
    mov eax, dword ptr [ebp - local_4]           # 00494d1e
    mov ecx, dword ptr [eax + field_1f93]        # 00494d21
    mov dword ptr [edx + field_1fff], ecx        # 00494d27
    mov ecx, dword ptr [ebp - local_4]           # 00494d2d
    call FUN_00496410                            # 00494d30
    push 0x54f82c                                # 00494d35
    push 0x583186                                # 00494d3a
    mov edx, dword ptr [0x5cf665]                # 00494d3f
    push edx                                     # 00494d45
    mov ecx, 0x5cf659                            # 00494d46
    call FUN_004c4202                            # 00494d4b
    {load} mov esp, ebp                          # 00494d50
    pop ebp                                      # 00494d52
    ret                                          # 00494d53

