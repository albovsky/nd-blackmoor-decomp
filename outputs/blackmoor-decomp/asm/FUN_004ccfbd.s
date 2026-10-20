# FUN_004ccfbd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccfbd
# extent:       0x004ccfbd-0x004ccff5 (56 code bytes)
# span:         0x004ccfbd-0x004ccff5 (code 56, tables 0, padding 0)
# sha256:       543981467bbf45c36eeed21dcef5ce3d2972f4a7cc01714fdee0c5dd259b421d
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccfbd_release_surface
# naming:       native port src/original_methods_fl16.c:m4ccfbd_release_surface (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4ccfbd_release_surface (dword +0x212 released through 0x4c2dfb via the Fl16Host callback, then := 0). The older release_surface in action_family_2d_runtime.c works on a typed struct and is not the credited symbol.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_212; [edx + n] field_212
# callees:      calls FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.c:release_surface (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_212, 0x212  # offset +0x212

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004ccfbd - 0x401000
.globl FUN_004ccfbd
FUN_004ccfbd:
    # block 0x004ccfbd: entry, 7 instruction(s), ends with je to 0x004ccff1 (forward)
    push ebp                                     # 004ccfbd
    {load} mov ebp, esp                          # 004ccfbe
    push ecx                                     # 004ccfc0
    mov dword ptr [ebp - local_4], ecx           # 004ccfc1
    mov eax, dword ptr [ebp - local_4]           # 004ccfc4
    cmp dword ptr [eax + field_212], 0x0         # 004ccfc7
    je.d8 L_004ccff1                             # 004ccfce
    # block 0x004ccfd0: entered by fall-through of je at 0x004ccfce, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ccff1
    mov ecx, dword ptr [ebp - local_4]           # 004ccfd0
    add ecx, 0x212                               # 004ccfd3
    push ecx                                     # 004ccfd9
    mov ecx, 0x5cf659                            # 004ccfda
    call FUN_004c2dfb                            # 004ccfdf
    mov edx, dword ptr [ebp - local_4]           # 004ccfe4
    mov dword ptr [edx + field_212], 0x0         # 004ccfe7
L_004ccff1:
    # block 0x004ccff1: entered by je at 0x004ccfce, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ccff1
    pop ebp                                      # 004ccff3
    ret                                          # 004ccff4

