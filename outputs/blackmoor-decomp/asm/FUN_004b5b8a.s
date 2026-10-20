# FUN_004b5b8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5b8a
# extent:       0x004b5b8a-0x004b5bc8 (62 code bytes)
# span:         0x004b5b8a-0x004b5bc8 (code 62, tables 0, padding 0)
# sha256:       739d01b29369b06b2f4168435b360a251a3fc289e72b38ed622b63a72cda33f0
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b5b8a_cleanup
# naming:       native port src/original_methods_fl17.c:m4b5b8a_cleanup (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b5b8a_cleanup; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 62 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_229; [ecx + n] field_1c, field_22a; [edx + n] field_225
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d1_runtime.c:d1_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_225, 0x225  # offset +0x225
.equ field_229, 0x229  # offset +0x229
.equ field_22a, 0x22a  # offset +0x22a

# --- external targets -----------------------------------------------

.org 0x004b5b8a - 0x401000
.globl FUN_004b5b8a
FUN_004b5b8a:
    # block 0x004b5b8a: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004b5b8a
    {load} mov ebp, esp                          # 004b5b8b
    push ecx                                     # 004b5b8d
    mov dword ptr [ebp - local_4], ecx           # 004b5b8e
    mov eax, dword ptr [ebp - local_4]           # 004b5b91
    mov word ptr [eax + field_1e], 0xffff        # 004b5b94
    mov ecx, dword ptr [ebp - local_4]           # 004b5b9a
    mov word ptr [ecx + field_1c], 0xffff        # 004b5b9d
    mov edx, dword ptr [ebp - local_4]           # 004b5ba3
    mov dword ptr [edx + field_225], 0x0         # 004b5ba6
    mov eax, dword ptr [ebp - local_4]           # 004b5bb0
    mov byte ptr [eax + field_229], 0x0          # 004b5bb3
    mov ecx, dword ptr [ebp - local_4]           # 004b5bba
    mov byte ptr [ecx + field_22a], 0x0          # 004b5bbd
    {load} mov esp, ebp                          # 004b5bc4
    pop ebp                                      # 004b5bc6
    ret                                          # 004b5bc7

