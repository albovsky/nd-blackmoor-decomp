# FUN_004ea229
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea229
# extent:       0x004ea229-0x004ea269 (64 code bytes)
# span:         0x004ea229-0x004ea269 (code 64, tables 0, padding 0)
# sha256:       e2b3ffdabbb13608e8757d15e7f95591857b3ecfc2100b96fc710ee20e54c5c2
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_inventory_surface_unload
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ea229.c.txt, not original source) refers to the data labelled s_UnloadBitmapSurface_____UNloaded_0055cb10
# name-note:    Frees the inventory bitmap surface, resets a flag and logs UnloadBitmapSurface.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2dfb, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004ea229 - 0x401000
.globl FUN_004ea229
FUN_004ea229:
    # block 0x004ea229: entry, 13 instruction(s), calls FUN_004c2dfb, ends with je to 0x004ea265 (forward)
    push ebp                                     # 004ea229
    {load} mov ebp, esp                          # 004ea22a
    push ecx                                     # 004ea22c
    mov dword ptr [ebp - local_4], ecx           # 004ea22d
    mov eax, dword ptr [ebp - local_4]           # 004ea230
    add eax, 0x699                               # 004ea233
    push eax                                     # 004ea238
    mov ecx, 0x5cf659                            # 004ea239
    call FUN_004c2dfb                            # 004ea23e
    mov dword ptr [0x5d1717], 0x0                # 004ea243
    movsx ecx, word ptr [0x63a4cd]               # 004ea24d
    test ecx, ecx                                # 004ea254
    je.d8 L_004ea265                             # 004ea256
    # block 0x004ea258: entered by fall-through of je at 0x004ea256, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ea265
    push 0x55cb10                                # 004ea258
    call FUN_0044a2b7                            # 004ea25d
    add esp, 0x4                                 # 004ea262
L_004ea265:
    # block 0x004ea265: entered by je at 0x004ea256, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ea265
    pop ebp                                      # 004ea267
    ret                                          # 004ea268

