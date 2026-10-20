# FUN_0048d067
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d067
# extent:       0x0048d067-0x0048d09c (53 code bytes)
# span:         0x0048d067-0x0048d09c (code 53, tables 0, padding 0)
# sha256:       5497e61ad63a4f2aece7487de826762d09ce52d10dfbbaff93520faa756571f3
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48d067_cleanup
# naming:       native port src/original_methods_fl17.c:m48d067_cleanup (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48d067_cleanup; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 53 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_37; [ecx + n] field_1c, field_38; [edx + n] field_33
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m48d067_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_33, 0x33  # offset +0x33
.equ field_37, 0x37  # offset +0x37
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x0048d067 - 0x401000
.globl FUN_0048d067
FUN_0048d067:
    # block 0x0048d067: entry, 17 instruction(s), ends with ret
    push ebp                                     # 0048d067
    {load} mov ebp, esp                          # 0048d068
    push ecx                                     # 0048d06a
    mov dword ptr [ebp - local_4], ecx           # 0048d06b
    mov eax, dword ptr [ebp - local_4]           # 0048d06e
    mov word ptr [eax + field_1e], 0xffff        # 0048d071
    mov ecx, dword ptr [ebp - local_4]           # 0048d077
    mov word ptr [ecx + field_1c], 0xffff        # 0048d07a
    mov edx, dword ptr [ebp - local_4]           # 0048d080
    mov dword ptr [edx + field_33], 0x0          # 0048d083
    mov eax, dword ptr [ebp - local_4]           # 0048d08a
    mov byte ptr [eax + field_37], 0x0           # 0048d08d
    mov ecx, dword ptr [ebp - local_4]           # 0048d091
    mov byte ptr [ecx + field_38], 0x0           # 0048d094
    {load} mov esp, ebp                          # 0048d098
    pop ebp                                      # 0048d09a
    ret                                          # 0048d09b

