# FUN_004fb018
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb018
# extent:       0x004fb018-0x004fb071 (89 code bytes)
# span:         0x004fb018-0x004fb071 (code 89, tables 0, padding 0)
# sha256:       648bb1b932269ec9dfd757b94323c7c19cfec9dbf87b37f952f3ef8aa07ffc62
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_scene_sound_unload_all
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_6d_runtime.h:22 says "then 0x4fb018 on the scene sound object 0x5c3a67 (unload the MSND channel and sound channels 0..13)"
# name-note:    Unloads the MSND channel and sound channels 0..13 on the scene sound object 0x5c3a67.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004fc05d, FUN_004fc808
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:unload_scene_sound_object (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fc05d, .text + (0x004fc05d - 0x401000)
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fb018 - 0x401000
.globl FUN_004fb018
FUN_004fb018:
    # block 0x004fb018: entry, 7 instruction(s), ends with je to 0x004fb039 (forward)
    push ebp                                     # 004fb018
    {load} mov ebp, esp                          # 004fb019
    sub esp, 0x8                                 # 004fb01b
    mov dword ptr [ebp - local_8], ecx           # 004fb01e
    movsx eax, word ptr [0x63a4cd]               # 004fb021
    test eax, eax                                # 004fb028
    je.d8 L_004fb039                             # 004fb02a
    # block 0x004fb02c: entered by fall-through of je at 0x004fb02a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fb039
    push 0x560678                                # 004fb02c
    call FUN_0044a2b7                            # 004fb031
    add esp, 0x4                                 # 004fb036
L_004fb039:
    # block 0x004fb039: entered by je at 0x004fb02a, 4 instruction(s), calls FUN_004fc05d, ends with forward jump to 0x004fb055
    mov ecx, dword ptr [ebp - local_8]           # 004fb039
    call FUN_004fc05d                            # 004fb03c
    mov word ptr [ebp - local_4], 0x0            # 004fb041
    jmp.d8 L_004fb055                            # 004fb047
L_004fb049:
    # block 0x004fb049: entered by jmp at 0x004fb06b, 3 instruction(s), falls into the block at 0x004fb055
    mov cx, word ptr [ebp - local_4]             # 004fb049
    add cx, 0x1                                  # 004fb04d
    mov word ptr [ebp - local_4], cx             # 004fb051
L_004fb055:
    # block 0x004fb055: entered by jmp at 0x004fb047, 3 instruction(s), ends with jge to 0x004fb06d (forward)
    movsx edx, word ptr [ebp - local_4]          # 004fb055
    cmp edx, 0xe                                 # 004fb059
    jge.d8 L_004fb06d                            # 004fb05c
    # block 0x004fb05e: entered by fall-through of jge at 0x004fb05c, 5 instruction(s), calls FUN_004fc808, ends with backward jump to 0x004fb049
    mov ax, word ptr [ebp - local_4]             # 004fb05e
    push eax                                     # 004fb062
    mov ecx, dword ptr [ebp - local_8]           # 004fb063
    call FUN_004fc808                            # 004fb066
    jmp.d8 L_004fb049                            # 004fb06b
L_004fb06d:
    # block 0x004fb06d: entered by jge at 0x004fb05c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fb06d
    pop ebp                                      # 004fb06f
    ret                                          # 004fb070

