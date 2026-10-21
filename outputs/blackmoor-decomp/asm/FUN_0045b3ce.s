# FUN_0045b3ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b3ce
# extent:       0x0045b3ce-0x0045b3ea (28 code bytes)
# span:         0x0045b3ce-0x0045b3ea (code 28, tables 0, padding 0)
# sha256:       922450c051896d522276e265fc63ac1945027a8d27c37a3c04cd92788cddd9e6
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45b3ce_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m45b3ce_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cf70u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m45b3ce_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0045b3ce - 0x401000
.globl FUN_0045b3ce
FUN_0045b3ce:
    # block 0x0045b3ce: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0045b3ce
    {load} mov ebp, esp                          # 0045b3cf
    push ecx                                     # 0045b3d1
    mov dword ptr [ebp - local_4], ecx           # 0045b3d2
    mov eax, dword ptr [ebp - local_4]           # 0045b3d5
    mov dword ptr [eax], 0x52cf70                # 0045b3d8
    mov ecx, dword ptr [ebp - local_4]           # 0045b3de
    call FUN_0051d730                            # 0045b3e1
    {load} mov esp, ebp                          # 0045b3e6
    pop ebp                                      # 0045b3e8
    ret                                          # 0045b3e9

