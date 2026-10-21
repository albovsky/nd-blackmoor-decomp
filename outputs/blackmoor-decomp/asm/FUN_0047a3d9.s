# FUN_0047a3d9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047a3d9
# extent:       0x0047a3d9-0x0047a416 (61 code bytes)
# span:         0x0047a3d9-0x0047a416 (code 61, tables 0, padding 0)
# sha256:       eed94043665c0a3634b02829e4ec9607c06fede1e3fc802335bdc1153a428c69
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47a3d9_set_flags
# naming:       native port src/original_methods_fl34c.c:m47a3d9_set_flags (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4789d6(self); test eax,eax on the full 32 bits: nonzero stores 1 at self+0x1576 and self+0x24, zero stores 0 at self+0x1576 only. je both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1576; [ecx + n] field_24; [edx + n] field_1576
# callees:      calls FUN_004789d6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34c.c:m47a3d9_set_flags (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_1576, 0x1576  # offset +0x1576

# --- external targets -----------------------------------------------
.set FUN_004789d6, .text + (0x004789d6 - 0x401000)

.org 0x0047a3d9 - 0x401000
.globl FUN_0047a3d9
FUN_0047a3d9:
    # block 0x0047a3d9: entry, 8 instruction(s), calls FUN_004789d6, ends with je to 0x0047a405 (forward)
    push ebp                                     # 0047a3d9
    {load} mov ebp, esp                          # 0047a3da
    push ecx                                     # 0047a3dc
    mov dword ptr [ebp - local_4], ecx           # 0047a3dd
    mov ecx, dword ptr [ebp - local_4]           # 0047a3e0
    call FUN_004789d6                            # 0047a3e3
    test eax, eax                                # 0047a3e8
    je.d8 L_0047a405                             # 0047a3ea
    # block 0x0047a3ec: entered by fall-through of je at 0x0047a3ea, 5 instruction(s), ends with forward jump to 0x0047a412
    mov eax, dword ptr [ebp - local_4]           # 0047a3ec
    mov dword ptr [eax + field_1576], 0x1        # 0047a3ef
    mov ecx, dword ptr [ebp - local_4]           # 0047a3f9
    mov dword ptr [ecx + field_24], 0x1          # 0047a3fc
    jmp.d8 L_0047a412                            # 0047a403
L_0047a405:
    # block 0x0047a405: entered by je at 0x0047a3ea, 2 instruction(s), falls into the block at 0x0047a412
    mov edx, dword ptr [ebp - local_4]           # 0047a405
    mov dword ptr [edx + field_1576], 0x0        # 0047a408
L_0047a412:
    # block 0x0047a412: entered by jmp at 0x0047a403, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047a412
    pop ebp                                      # 0047a414
    ret                                          # 0047a415

