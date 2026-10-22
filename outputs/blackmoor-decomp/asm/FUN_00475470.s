# FUN_00475470
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475470
# extent:       0x00475470-0x004754a1 (49 code bytes)
# span:         0x00475470-0x004754a1 (code 49, tables 0, padding 0)
# sha256:       b0f0bf92db09523c8bd65712f7d4a2aa6fb093d7816e2fb95d77d7b9afa54608
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m475470_lifted
# naming:       native port src/original_methods_fl40.c:m475470_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 17/17 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_355; [ecx + n] field_76; [edx + n] field_449
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m475470_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_76, 0x76  # offset +0x76
.equ field_355, 0x355  # offset +0x355
.equ field_449, 0x449  # offset +0x449

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00475470 - 0x401000
.globl FUN_00475470
FUN_00475470:
    # block 0x00475470: entry, 7 instruction(s), ends with jne to 0x00475485 (forward)
    push ebp                                     # 00475470
    {load} mov ebp, esp                          # 00475471
    push ecx                                     # 00475473
    mov dword ptr [ebp - local_4], ecx           # 00475474
    mov eax, dword ptr [ebp - local_4]           # 00475477
    cmp dword ptr [eax + field_355], 0x0         # 0047547a
    jne.d8 L_00475485                            # 00475481
    # block 0x00475483: entered by fall-through of jne at 0x00475481, 1 instruction(s), ends with forward jump to 0x0047549d
    jmp.d8 L_0047549d                            # 00475483
L_00475485:
    # block 0x00475485: entered by jne at 0x00475481, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0047549d
    mov ecx, dword ptr [ebp - local_4]           # 00475485
    mov edx, dword ptr [ecx + field_76]          # 00475488
    mov ax, word ptr [edx + field_449]           # 0047548b
    push eax                                     # 00475492
    mov ecx, 0x5c3a67                            # 00475493
    call FUN_004fb2e3                            # 00475498
L_0047549d:
    # block 0x0047549d: entered by jmp at 0x00475483, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047549d
    pop ebp                                      # 0047549f
    ret                                          # 004754a0

