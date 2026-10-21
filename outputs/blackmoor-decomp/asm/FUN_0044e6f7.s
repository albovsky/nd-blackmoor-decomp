# FUN_0044e6f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e6f7
# extent:       0x0044e6f7-0x0044e74b (84 code bytes)
# span:         0x0044e6f7-0x0044e74b (code 84, tables 0, padding 0)
# sha256:       0110858c4f986ce438db8cf05033f82cd7188d1d7ee131b0cb52575208dd2fb4
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e6f7_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m44e6f7_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52ccc0u at [this], calls 0x44e767(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0044e767
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m44e6f7_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044e767, .text + (0x0044e767 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0044e6f7 - 0x401000
.globl FUN_0044e6f7
FUN_0044e6f7:
    # block 0x0044e6f7: entry, 23 instruction(s), calls FUN_0051d716, FUN_0044e767, ends with ret
    push ebp                                     # 0044e6f7
    {load} mov ebp, esp                          # 0044e6f8
    push -0x1                                    # 0044e6fa
    push 0x527fdd                                # 0044e6fc
    mov eax, dword ptr fs:[0x0]                  # 0044e701
    push eax                                     # 0044e707
    mov dword ptr fs:[0x0], esp                  # 0044e708
    push ecx                                     # 0044e70f
    mov dword ptr [ebp - local_10], ecx          # 0044e710
    mov ecx, dword ptr [ebp - local_10]          # 0044e713
    call FUN_0051d716                            # 0044e716
    mov dword ptr [ebp - local_4], 0x0           # 0044e71b
    mov eax, dword ptr [ebp - local_10]          # 0044e722
    mov dword ptr [eax], 0x52ccc0                # 0044e725
    mov ecx, dword ptr [ebp - local_10]          # 0044e72b
    call FUN_0044e767                            # 0044e72e
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044e733
    mov eax, dword ptr [ebp - local_10]          # 0044e73a
    mov ecx, dword ptr [ebp - local_c]           # 0044e73d
    mov dword ptr fs:[0x0], ecx                  # 0044e740
    {load} mov esp, ebp                          # 0044e747
    pop ebp                                      # 0044e749
    ret                                          # 0044e74a

