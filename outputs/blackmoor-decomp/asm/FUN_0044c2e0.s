# FUN_0044c2e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c2e0
# extent:       0x0044c2e0-0x0044c384 (164 code bytes)
# span:         0x0044c2e0-0x0044c384 (code 164, tables 0, padding 0)
# sha256:       a215de7f66ad250fb4a0a04283632c909ff8e293b43fd41f292413d705187560
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_overlay_surface_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_33_runtime.h:170 says "0x44c2e0(1): loads the overlay surface -> handle"
# name-note:    Loads the overlay surface and returns its handle.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2790, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)

.org 0x0044c2e0 - 0x401000
.globl FUN_0044c2e0
FUN_0044c2e0:
    # block 0x0044c2e0: entry, 7 instruction(s), ends with je to 0x0044c2fc (forward)
    push ebp                                     # 0044c2e0
    {load} mov ebp, esp                          # 0044c2e1
    push ecx                                     # 0044c2e3
    movsx eax, word ptr [ebp + arg_8]            # 0044c2e4
    mov dword ptr [ebp - local_4], eax           # 0044c2e8
    cmp dword ptr [ebp - local_4], 0x1           # 0044c2eb
    je.d8 L_0044c2fc                             # 0044c2ef
    # block 0x0044c2f1: entered by fall-through of je at 0x0044c2ef, 2 instruction(s), ends with je to 0x0044c33f (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 0044c2f1
    je.d8 L_0044c33f                             # 0044c2f5
    # block 0x0044c2f7: entered by fall-through of je at 0x0044c2f5, 1 instruction(s), ends with forward jump to 0x0044c380
    jmp.d32 L_0044c380                           # 0044c2f7
L_0044c2fc:
    # block 0x0044c2fc: entered by je at 0x0044c2ef, 2 instruction(s), ends with jne to 0x0044c33d (forward)
    cmp dword ptr [0x5d03c7], 0x0                # 0044c2fc
    jne.d8 L_0044c33d                            # 0044c303
    # block 0x0044c305: entered by fall-through of jne at 0x0044c303, 10 instruction(s), calls FUN_004c2790, ends with je to 0x0044c33d (forward)
    push 0x54912c                                # 0044c305
    push 0x6                                     # 0044c30a
    push 0x5b4e68                                # 0044c30c
    push 0x549148                                # 0044c311
    mov ecx, 0x5cf659                            # 0044c316
    call FUN_004c2790                            # 0044c31b
    mov dword ptr [0x5d03c7], eax                # 0044c320
    movsx ecx, word ptr [0x63a4cd]               # 0044c325
    test ecx, ecx                                # 0044c32c
    je.d8 L_0044c33d                             # 0044c32e
    # block 0x0044c330: entered by fall-through of je at 0x0044c32e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c33d
    push 0x549150                                # 0044c330
    call FUN_0044a2b7                            # 0044c335
    add esp, 0x4                                 # 0044c33a
L_0044c33d:
    # block 0x0044c33d: entered by jne at 0x0044c303; je at 0x0044c32e, 1 instruction(s), ends with forward jump to 0x0044c380
    jmp.d8 L_0044c380                            # 0044c33d
L_0044c33f:
    # block 0x0044c33f: entered by je at 0x0044c2f5, 2 instruction(s), ends with jne to 0x0044c380 (forward)
    cmp dword ptr [0x5d03cb], 0x0                # 0044c33f
    jne.d8 L_0044c380                            # 0044c346
    # block 0x0044c348: entered by fall-through of jne at 0x0044c346, 10 instruction(s), calls FUN_004c2790, ends with je to 0x0044c380 (forward)
    push 0x5491ac                                # 0044c348
    push 0x6                                     # 0044c34d
    push 0x5b50df                                # 0044c34f
    push 0x5491c8                                # 0044c354
    mov ecx, 0x5cf659                            # 0044c359
    call FUN_004c2790                            # 0044c35e
    mov dword ptr [0x5d03cb], eax                # 0044c363
    movsx edx, word ptr [0x63a4cd]               # 0044c368
    test edx, edx                                # 0044c36f
    je.d8 L_0044c380                             # 0044c371
    # block 0x0044c373: entered by fall-through of je at 0x0044c371, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c380
    push 0x5491d0                                # 0044c373
    call FUN_0044a2b7                            # 0044c378
    add esp, 0x4                                 # 0044c37d
L_0044c380:
    # block 0x0044c380: entered by jmp at 0x0044c2f7; jmp at 0x0044c33d; jne at 0x0044c346; je at 0x0044c371, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044c380
    pop ebp                                      # 0044c382
    ret                                          # 0044c383

