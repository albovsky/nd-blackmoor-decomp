# FUN_004dbf6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbf6e
# extent:       0x004dbf6e-0x004dbfbf (81 code bytes)
# span:         0x004dbf6e-0x004dbfbf (code 81, tables 0, padding 0)
# sha256:       cccee722b26c89277b68b635b6e9827fb50fdfa0f4549dcb83fed1e8a8fdc76c
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dbf6e_destroy_with_frame
# naming:       native port src/original_methods_fl39a.c:m4dbf6e_destroy_with_frame (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the dword 0x52e478u at [this], calls 0x4dc043(this) then 0x51d730(this) and returns the eax of the second; the SEH frame is not modelled. No jumps; all 22 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dc043, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4dbf6e_destroy_with_frame (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004dc043, .text + (0x004dc043 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004dbf6e - 0x401000
.globl FUN_004dbf6e
FUN_004dbf6e:
    # block 0x004dbf6e: entry, 22 instruction(s), calls FUN_004dc043, FUN_0051d730, ends with ret
    push ebp                                     # 004dbf6e
    {load} mov ebp, esp                          # 004dbf6f
    push -0x1                                    # 004dbf71
    push 0x5288b0                                # 004dbf73
    mov eax, dword ptr fs:[0x0]                  # 004dbf78
    push eax                                     # 004dbf7e
    mov dword ptr fs:[0x0], esp                  # 004dbf7f
    push ecx                                     # 004dbf86
    mov dword ptr [ebp - local_10], ecx          # 004dbf87
    mov eax, dword ptr [ebp - local_10]          # 004dbf8a
    mov dword ptr [eax], 0x52e478                # 004dbf8d
    mov dword ptr [ebp - local_4], 0x0           # 004dbf93
    mov ecx, dword ptr [ebp - local_10]          # 004dbf9a
    call FUN_004dc043                            # 004dbf9d
    mov dword ptr [ebp - local_4], 0xffffffff    # 004dbfa2
    mov ecx, dword ptr [ebp - local_10]          # 004dbfa9
    call FUN_0051d730                            # 004dbfac
    mov ecx, dword ptr [ebp - local_c]           # 004dbfb1
    mov dword ptr fs:[0x0], ecx                  # 004dbfb4
    {load} mov esp, ebp                          # 004dbfbb
    pop ebp                                      # 004dbfbd
    ret                                          # 004dbfbe

