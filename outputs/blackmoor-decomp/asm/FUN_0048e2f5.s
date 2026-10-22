# FUN_0048e2f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e2f5
# extent:       0x0048e2f5-0x0048e324 (47 code bytes)
# span:         0x0048e2f5-0x0048e324 (code 47, tables 0, padding 0)
# sha256:       a01e3460dbdd8c57538d10e605ed2d18109449a4c50b69a1c021eef885a0ecbf
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e2f5_release_word
# naming:       native port src/original_methods_fl39e.c:m48e2f5_release_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When the signed word [self+0x1c] != -1 calls 0x4d3992(word); then returns 0x48e28a(self). The jump taken both ways (word -1 and other words incl. 0xfffe, 0x8000); all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004d3992, FUN_0048e28a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m48e2f5_release_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0048e28a, .text + (0x0048e28a - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0048e2f5 - 0x401000
.globl FUN_0048e2f5
FUN_0048e2f5:
    # block 0x0048e2f5: entry, 8 instruction(s), ends with je to 0x0048e318 (forward)
    push ebp                                     # 0048e2f5
    {load} mov ebp, esp                          # 0048e2f6
    push ecx                                     # 0048e2f8
    mov dword ptr [ebp - local_4], ecx           # 0048e2f9
    mov eax, dword ptr [ebp - local_4]           # 0048e2fc
    movsx ecx, word ptr [eax + field_1c]         # 0048e2ff
    cmp ecx, -0x1                                # 0048e303
    je.d8 L_0048e318                             # 0048e306
    # block 0x0048e308: entered by fall-through of je at 0x0048e306, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0048e318
    mov edx, dword ptr [ebp - local_4]           # 0048e308
    mov ax, word ptr [edx + field_1c]            # 0048e30b
    push eax                                     # 0048e30f
    call FUN_004d3992                            # 0048e310
    add esp, 0x4                                 # 0048e315
L_0048e318:
    # block 0x0048e318: entered by je at 0x0048e306, 5 instruction(s), calls FUN_0048e28a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0048e318
    call FUN_0048e28a                            # 0048e31b
    {load} mov esp, ebp                          # 0048e320
    pop ebp                                      # 0048e322
    ret                                          # 0048e323

