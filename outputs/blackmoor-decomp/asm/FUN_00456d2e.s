# FUN_00456d2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456d2e
# extent:       0x00456d2e-0x00456d77 (73 code bytes)
# span:         0x00456d2e-0x00456d77 (code 73, tables 0, padding 0)
# sha256:       582b2b960adb02f5e799efd37e94cafa066350d719a26c5ee7e9164ea3e13928
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m456d2e_release_surface_call_tail
# naming:       native port src/original_methods_fl38a.c:m456d2e_release_surface_call_tail (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4c2dfb(this+0x20) if dword [this+0x20] is set, 0x4d3992(word [this+0x1c]) if not -1, then 0x456d07(this). 26/26 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00456d07
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m456d2e_release_surface_call_tail (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00456d07, .text + (0x00456d07 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00456d2e - 0x401000
.globl FUN_00456d2e
FUN_00456d2e:
    # block 0x00456d2e: entry, 7 instruction(s), ends with je to 0x00456d4f (forward)
    push ebp                                     # 00456d2e
    {load} mov ebp, esp                          # 00456d2f
    push ecx                                     # 00456d31
    mov dword ptr [ebp - local_4], ecx           # 00456d32
    mov eax, dword ptr [ebp - local_4]           # 00456d35
    cmp dword ptr [eax + field_20], 0x0          # 00456d38
    je.d8 L_00456d4f                             # 00456d3c
    # block 0x00456d3e: entered by fall-through of je at 0x00456d3c, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00456d4f
    mov ecx, dword ptr [ebp - local_4]           # 00456d3e
    add ecx, 0x20                                # 00456d41
    push ecx                                     # 00456d44
    mov ecx, 0x5cf659                            # 00456d45
    call FUN_004c2dfb                            # 00456d4a
L_00456d4f:
    # block 0x00456d4f: entered by je at 0x00456d3c, 4 instruction(s), ends with je to 0x00456d6b (forward)
    mov edx, dword ptr [ebp - local_4]           # 00456d4f
    movsx eax, word ptr [edx + field_1c]         # 00456d52
    cmp eax, -0x1                                # 00456d56
    je.d8 L_00456d6b                             # 00456d59
    # block 0x00456d5b: entered by fall-through of je at 0x00456d59, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00456d6b
    mov ecx, dword ptr [ebp - local_4]           # 00456d5b
    mov dx, word ptr [ecx + field_1c]            # 00456d5e
    push edx                                     # 00456d62
    call FUN_004d3992                            # 00456d63
    add esp, 0x4                                 # 00456d68
L_00456d6b:
    # block 0x00456d6b: entered by je at 0x00456d59, 5 instruction(s), calls FUN_00456d07, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00456d6b
    call FUN_00456d07                            # 00456d6e
    {load} mov esp, ebp                          # 00456d73
    pop ebp                                      # 00456d75
    ret                                          # 00456d76

