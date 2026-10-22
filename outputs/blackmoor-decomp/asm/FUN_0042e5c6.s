# FUN_0042e5c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e5c6
# extent:       0x0042e5c6-0x0042e693 (205 code bytes)
# span:         0x0042e5c6-0x0042e693 (code 205, tables 0, padding 0)
# sha256:       76262d727e2b989184dae55e67d7db4cfc809f5db0e64caa858eab33f6a0ac79
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_next_scene_pop_applier
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/42e5c6.c.txt, not original source) refers to the data labelled s_ERROR___tried_to_pop_the_next_sc_00545a1c
# name-note:    Applies the saved next scene and its fields to the current-scene globals and marks it consumed, with an ERROR if nothing was queued (tried to pop the next scene).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42e5c6_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042e5c6 - 0x401000
.globl FUN_0042e5c6
FUN_0042e5c6:
    # block 0x0042e5c6: entry, 5 instruction(s), ends with jne to 0x0042e5f4 (forward)
    push ebp                                     # 0042e5c6
    {load} mov ebp, esp                          # 0042e5c7
    movsx eax, word ptr [0x5c3a31]               # 0042e5c9
    cmp eax, 0x270f                              # 0042e5d0
    jne.d8 L_0042e5f4                            # 0042e5d5
    # block 0x0042e5d7: entered by fall-through of jne at 0x0042e5d5, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042e691
    push 0x0                                     # 0042e5d7
    push 0x0                                     # 0042e5d9
    push 0x545a1c                                # 0042e5db
    call FUN_0052139c                            # 0042e5e0
    mov ecx, 0x5cf659                            # 0042e5e5
    call FUN_004c97b4                            # 0042e5ea
    jmp.d32 L_0042e691                           # 0042e5ef
L_0042e5f4:
    # block 0x0042e5f4: entered by jne at 0x0042e5d5, 18 instruction(s), ends with jne to 0x0042e66b (forward)
    movsx ecx, word ptr [0x5c3a31]               # 0042e5f4
    mov dword ptr [0x5bb57b], ecx                # 0042e5fb
    movsx edx, word ptr [0x5c3a33]               # 0042e601
    mov dword ptr [0x5bb57f], edx                # 0042e608
    mov ax, word ptr [0x5c3a35]                  # 0042e60e
    mov word ptr [0x5bb599], ax                  # 0042e614
    mov cx, word ptr [0x5c3a37]                  # 0042e61a
    mov word ptr [0x5bb595], cx                  # 0042e621
    mov edx, dword ptr [0x5c3a3b]                # 0042e628
    mov dword ptr [0x5bb59b], edx                # 0042e62e
    mov eax, dword ptr [0x5c3a3f]                # 0042e634
    mov dword ptr [0x5bb59f], eax                # 0042e639
    mov ecx, dword ptr [0x5c3a43]                # 0042e63e
    mov dword ptr [0x5bb5a3], ecx                # 0042e644
    mov word ptr [0x5c39ff], 0x1                 # 0042e64a
    movsx edx, word ptr [0x5c3a39]               # 0042e653
    cmp edx, 0x1                                 # 0042e65a
    jne.d8 L_0042e66b                            # 0042e65d
    # block 0x0042e65f: entered by fall-through of jne at 0x0042e65d, 2 instruction(s), ends with forward jump to 0x0042e675
    mov dword ptr [0x5bb1ca], 0x0                # 0042e65f
    jmp.d8 L_0042e675                            # 0042e669
L_0042e66b:
    # block 0x0042e66b: entered by jne at 0x0042e65d, 1 instruction(s), falls into the block at 0x0042e675
    mov dword ptr [0x5bb1ca], 0x1                # 0042e66b
L_0042e675:
    # block 0x0042e675: entered by jmp at 0x0042e669, 3 instruction(s), falls into the block at 0x0042e691
    mov dword ptr [0x583999], 0x4                # 0042e675
    mov word ptr [0x5c3a31], 0x270f              # 0042e67f
    mov word ptr [0x5c3a33], 0x270f              # 0042e688
L_0042e691:
    # block 0x0042e691: entered by jmp at 0x0042e5ef, 2 instruction(s), ends with ret
    pop ebp                                      # 0042e691
    ret                                          # 0042e692

