# FUN_00490547
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00490547
# extent:       0x00490547-0x00490598 (81 code bytes)
# span:         0x00490547-0x00490598 (code 81, tables 0, padding 0)
# sha256:       333c3094960cbf47273b5e5ad70223c2ad7c50bcb6cdcab9f5030df22784b46b
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m490547_destroy_with_frame
# naming:       native port src/original_methods_fl39a.c:m490547_destroy_with_frame (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the dword 0x52daf8u at [this], calls 0x490d50(this) then 0x51d730(this) and returns the eax of the second; the SEH frame is not modelled. No jumps; all 22 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00490d50, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m490547_destroy_with_frame (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00490d50, .text + (0x00490d50 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00490547 - 0x401000
.globl FUN_00490547
FUN_00490547:
    # block 0x00490547: entry, 22 instruction(s), calls FUN_00490d50, FUN_0051d730, ends with ret
    push ebp                                     # 00490547
    {load} mov ebp, esp                          # 00490548
    push -0x1                                    # 0049054a
    push 0x52852d                                # 0049054c
    mov eax, dword ptr fs:[0x0]                  # 00490551
    push eax                                     # 00490557
    mov dword ptr fs:[0x0], esp                  # 00490558
    push ecx                                     # 0049055f
    mov dword ptr [ebp - local_10], ecx          # 00490560
    mov eax, dword ptr [ebp - local_10]          # 00490563
    mov dword ptr [eax], 0x52daf8                # 00490566
    mov dword ptr [ebp - local_4], 0x0           # 0049056c
    mov ecx, dword ptr [ebp - local_10]          # 00490573
    call FUN_00490d50                            # 00490576
    mov dword ptr [ebp - local_4], 0xffffffff    # 0049057b
    mov ecx, dword ptr [ebp - local_10]          # 00490582
    call FUN_0051d730                            # 00490585
    mov ecx, dword ptr [ebp - local_c]           # 0049058a
    mov dword ptr fs:[0x0], ecx                  # 0049058d
    {load} mov esp, ebp                          # 00490594
    pop ebp                                      # 00490596
    ret                                          # 00490597

