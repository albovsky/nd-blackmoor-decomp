# FUN_004b7229
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7229
# extent:       0x004b7229-0x004b7272 (73 code bytes)
# span:         0x004b7229-0x004b7272 (code 73, tables 0, padding 0)
# sha256:       280cdd2224d62353f4adec88b1afbae780e3bbc352df4cf4ca30494d3bb7492a
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7229_release_entry
# naming:       native port src/original_methods_fl39a.c:m4b7229_release_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When dword [self+0x1d] != 0 calls 0x4c2dfb(0x5cf659, self+0x1d); when the signed word [self+0x2f] != -1 calls 0x4d3992(word); then returns 0x4b71f7(self). Both jumps taken both ways; all 27 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1d; [ecx + n] field_2f; [edx + n] field_2f
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004b71f7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4b7229_release_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1d, 0x1d  # offset +0x1d
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004b71f7, .text + (0x004b71f7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004b7229 - 0x401000
.globl FUN_004b7229
FUN_004b7229:
    # block 0x004b7229: entry, 7 instruction(s), ends with je to 0x004b724a (forward)
    push ebp                                     # 004b7229
    {load} mov ebp, esp                          # 004b722a
    push ecx                                     # 004b722c
    mov dword ptr [ebp - local_4], ecx           # 004b722d
    mov eax, dword ptr [ebp - local_4]           # 004b7230
    cmp dword ptr [eax + field_1d], 0x0          # 004b7233
    je.d8 L_004b724a                             # 004b7237
    # block 0x004b7239: entered by fall-through of je at 0x004b7237, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004b724a
    mov ecx, dword ptr [ebp - local_4]           # 004b7239
    add ecx, 0x1d                                # 004b723c
    push ecx                                     # 004b723f
    mov ecx, 0x5cf659                            # 004b7240
    call FUN_004c2dfb                            # 004b7245
L_004b724a:
    # block 0x004b724a: entered by je at 0x004b7237, 4 instruction(s), ends with je to 0x004b7266 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b724a
    movsx eax, word ptr [edx + field_2f]         # 004b724d
    cmp eax, -0x1                                # 004b7251
    je.d8 L_004b7266                             # 004b7254
    # block 0x004b7256: entered by fall-through of je at 0x004b7254, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b7266
    mov ecx, dword ptr [ebp - local_4]           # 004b7256
    mov dx, word ptr [ecx + field_2f]            # 004b7259
    push edx                                     # 004b725d
    call FUN_004d3992                            # 004b725e
    add esp, 0x4                                 # 004b7263
L_004b7266:
    # block 0x004b7266: entered by je at 0x004b7254, 5 instruction(s), calls FUN_004b71f7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004b7266
    call FUN_004b71f7                            # 004b7269
    {load} mov esp, ebp                          # 004b726e
    pop ebp                                      # 004b7270
    ret                                          # 004b7271

