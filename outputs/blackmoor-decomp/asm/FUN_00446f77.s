# FUN_00446f77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446f77
# extent:       0x00446f77-0x00446faa (51 code bytes)
# span:         0x00446f77-0x00446faa (code 51, tables 0, padding 0)
# sha256:       1c4fc69cc7a73c3c6fb82201431a99a6fa455405ba044d436a048904893c203c
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m446f77_construct
# naming:       native port src/original_methods_fl34c.c:m446f77_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(self), stores vtable 0x52ca58 at self, zero dwords at the unaligned self+0x31 and +0x35, returns self. Stores follow the call (callee writes overwritten).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_31; [edx + n] field_35
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34c.c:m446f77_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00446f77 - 0x401000
.globl FUN_00446f77
FUN_00446f77:
    # block 0x00446f77: entry, 16 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 00446f77
    {load} mov ebp, esp                          # 00446f78
    push ecx                                     # 00446f7a
    mov dword ptr [ebp - local_4], ecx           # 00446f7b
    mov ecx, dword ptr [ebp - local_4]           # 00446f7e
    call FUN_0051d716                            # 00446f81
    mov eax, dword ptr [ebp - local_4]           # 00446f86
    mov dword ptr [eax], 0x52ca58                # 00446f89
    mov ecx, dword ptr [ebp - local_4]           # 00446f8f
    mov dword ptr [ecx + field_31], 0x0          # 00446f92
    mov edx, dword ptr [ebp - local_4]           # 00446f99
    mov dword ptr [edx + field_35], 0x0          # 00446f9c
    mov eax, dword ptr [ebp - local_4]           # 00446fa3
    {load} mov esp, ebp                          # 00446fa6
    pop ebp                                      # 00446fa8
    ret                                          # 00446fa9

