# FUN_004f88ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f88ad
# extent:       0x004f88ad-0x004f88de (49 code bytes)
# span:         0x004f88ad-0x004f88de (code 49, tables 0, padding 0)
# sha256:       2b875de927fdb46e42005bf6e253ac869ea97eb21901de693d37285554af7542
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f88ad_forward_fields
# naming:       native port src/original_methods_fl39e.c:m4f88ad_forward_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4f875f(this = self, [self+0x24c], [self+0x250], [self+0x254]) and returns its eax. No jumps; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_254; [ecx + n] field_24c; [edx + n] field_250
# callees:      calls FUN_004f875f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4f88ad_forward_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254

# --- external targets -----------------------------------------------
.set FUN_004f875f, .text + (0x004f875f - 0x401000)

.org 0x004f88ad - 0x401000
.globl FUN_004f88ad
FUN_004f88ad:
    # block 0x004f88ad: entry, 18 instruction(s), calls FUN_004f875f, ends with ret
    push ebp                                     # 004f88ad
    {load} mov ebp, esp                          # 004f88ae
    push ecx                                     # 004f88b0
    mov dword ptr [ebp - local_4], ecx           # 004f88b1
    mov eax, dword ptr [ebp - local_4]           # 004f88b4
    mov ecx, dword ptr [eax + field_254]         # 004f88b7
    push ecx                                     # 004f88bd
    mov edx, dword ptr [ebp - local_4]           # 004f88be
    mov eax, dword ptr [edx + field_250]         # 004f88c1
    push eax                                     # 004f88c7
    mov ecx, dword ptr [ebp - local_4]           # 004f88c8
    mov edx, dword ptr [ecx + field_24c]         # 004f88cb
    push edx                                     # 004f88d1
    mov ecx, dword ptr [ebp - local_4]           # 004f88d2
    call FUN_004f875f                            # 004f88d5
    {load} mov esp, ebp                          # 004f88da
    pop ebp                                      # 004f88dc
    ret                                          # 004f88dd

