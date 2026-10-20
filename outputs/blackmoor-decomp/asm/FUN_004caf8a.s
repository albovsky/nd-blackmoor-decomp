# FUN_004caf8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caf8a
# extent:       0x004caf8a-0x004cafc1 (55 code bytes)
# span:         0x004caf8a-0x004cafc1 (code 55, tables 0, padding 0)
# sha256:       932329bb7205664a814efa0db5de25d22f1322d8eca64228f8bf7514091ddc44
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4caf8a_reset
# naming:       native port src/original_methods_fl17.c:m4caf8a_reset (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4caf8a_reset; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 55 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c; [edx + n] field_c
# callees:      calls FUN_004cbb00, FUN_004d3992, FUN_004caf03
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4caf8a_reset (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004caf03, .text + (0x004caf03 - 0x401000)
.set FUN_004cbb00, .text + (0x004cbb00 - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004caf8a - 0x401000
.globl FUN_004caf8a
FUN_004caf8a:
    # block 0x004caf8a: entry, 10 instruction(s), calls FUN_004cbb00, ends with je to 0x004cafb5 (forward)
    push ebp                                     # 004caf8a
    {load} mov ebp, esp                          # 004caf8b
    push ecx                                     # 004caf8d
    mov dword ptr [ebp - local_4], ecx           # 004caf8e
    mov ecx, dword ptr [ebp - local_4]           # 004caf91
    call FUN_004cbb00                            # 004caf94
    mov eax, dword ptr [ebp - local_4]           # 004caf99
    movsx ecx, word ptr [eax + field_c]          # 004caf9c
    cmp ecx, -0x1                                # 004cafa0
    je.d8 L_004cafb5                             # 004cafa3
    # block 0x004cafa5: entered by fall-through of je at 0x004cafa3, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004cafb5
    mov edx, dword ptr [ebp - local_4]           # 004cafa5
    mov ax, word ptr [edx + field_c]             # 004cafa8
    push eax                                     # 004cafac
    call FUN_004d3992                            # 004cafad
    add esp, 0x4                                 # 004cafb2
L_004cafb5:
    # block 0x004cafb5: entered by je at 0x004cafa3, 5 instruction(s), calls FUN_004caf03, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004cafb5
    call FUN_004caf03                            # 004cafb8
    {load} mov esp, ebp                          # 004cafbd
    pop ebp                                      # 004cafbf
    ret                                          # 004cafc0

