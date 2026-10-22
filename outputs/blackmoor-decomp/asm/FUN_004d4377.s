# FUN_004d4377
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4377
# extent:       0x004d4377-0x004d4410 (153 code bytes)
# span:         0x004d4377-0x004d4410 (code 153, tables 0, padding 0)
# sha256:       9d4846ec87e513a5012abe07e99d99a4acffb60010a62beaa2557aa2729b5bc4
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_credits_init
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d4377.c.txt, not original source) refers to the data labelled s_CIFTREE_0055a54c, s_DF_Credits_Surface_0055a538
# name-note:    Starts the credits: clears state, sets a tick timer, loads the DF_Credits_Surface from CIFTREE and loads the credits text surface.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dad60, FUN_00425fc0, KERNEL32.dll!GetTickCount, FUN_004c2dfb, FUN_004c2790, FUN_004d46b3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d46b3, .text + (0x004d46b3 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)

.org 0x004d4377 - 0x401000
.globl FUN_004d4377
FUN_004d4377:
    # block 0x004d4377: entry, 8 instruction(s), calls FUN_004dad60, ends with je to 0x004d439b (forward)
    push ebp                                     # 004d4377
    {load} mov ebp, esp                          # 004d4378
    mov ecx, 0x5830a6                            # 004d437a
    call FUN_004dad60                            # 004d437f
    {load} xor eax, eax                          # 004d4384
    mov al, byte ptr [0x58320d]                  # 004d4386
    test eax, eax                                # 004d438b
    je.d8 L_004d439b                             # 004d438d
    # block 0x004d438f: entered by fall-through of je at 0x004d438d, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004d439b
    mov byte ptr [0x58320d], 0x0                 # 004d438f
    call FUN_00425fc0                            # 004d4396
L_004d439b:
    # block 0x004d439b: entered by je at 0x004d438d, 23 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004c2dfb, FUN_004c2790, FUN_004d46b3, ends with ret
    mov dword ptr [0x5b010f], 0x0                # 004d439b
    mov word ptr [0x5b00e7], 0xffff              # 004d43a5
    mov word ptr [0x5b00e9], 0x0                 # 004d43ae
    call dword ptr [0x52a23c]                    # 004d43b7
    movsx ecx, word ptr [0x5b00b4]               # 004d43bd
    {load} add eax, ecx                          # 004d43c4
    mov dword ptr [0x5b00eb], eax                # 004d43c6
    push 0x5d0387                                # 004d43cb
    mov ecx, 0x5cf659                            # 004d43d0
    call FUN_004c2dfb                            # 004d43d5
    push 0x5d038b                                # 004d43da
    mov ecx, 0x5cf659                            # 004d43df
    call FUN_004c2dfb                            # 004d43e4
    push 0x55a538                                # 004d43e9
    push 0x6                                     # 004d43ee
    push 0x5b0032                                # 004d43f0
    push 0x55a54c                                # 004d43f5
    mov ecx, 0x5cf659                            # 004d43fa
    call FUN_004c2790                            # 004d43ff
    mov dword ptr [0x5d0387], eax                # 004d4404
    call FUN_004d46b3                            # 004d4409
    pop ebp                                      # 004d440e
    ret                                          # 004d440f

