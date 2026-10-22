# FUN_0042ad27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ad27
# extent:       0x0042ad27-0x0042ad90 (105 code bytes)
# span:         0x0042ad27-0x0042ad90 (code 105, tables 0, padding 0)
# sha256:       b1403fcf726f6ee54f0d2db54e1723fa71845778bdee497faac41bf24c283834
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_framed_two_frame_clear
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.h:266 says "0x42ad27: framed two-frame clear requested by the conversation UI"
# name-note:    Framed two-frame clear requested by the conversation UI.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.h:caption_framed_clear_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0042ad27 - 0x401000
.globl FUN_0042ad27
FUN_0042ad27:
    # block 0x0042ad27: entry, 8 instruction(s), ends with jl to 0x0042ad71 (forward)
    push ebp                                     # 0042ad27
    {load} mov ebp, esp                          # 0042ad28
    mov ax, word ptr [0x5b15d4]                  # 0042ad2a
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042ad30
    mov word ptr [0x5b15d4], ax                  # 0042ad34
    movsx ecx, word ptr [0x5b15d4]               # 0042ad3a
    test ecx, ecx                                # 0042ad41
    jl.d8 L_0042ad71                             # 0042ad43
    # block 0x0042ad45: entered by fall-through of jl at 0x0042ad43, 3 instruction(s), ends with jge to 0x0042ad71 (forward)
    movsx edx, word ptr [0x5b15d4]               # 0042ad45
    cmp edx, 0x1                                 # 0042ad4c
    jge.d8 L_0042ad71                            # 0042ad4f
    # block 0x0042ad51: entered by fall-through of jge at 0x0042ad4f, 4 instruction(s), ends with forward jump to 0x0042ad8e
    mov dword ptr [0x5d17f5], 0x0                # 0042ad51
    mov dword ptr [0x5d183f], 0x1                # 0042ad5b
    mov dword ptr [0x5b15d6], 0x0                # 0042ad65
    jmp.d8 L_0042ad8e                            # 0042ad6f
L_0042ad71:
    # block 0x0042ad71: entered by jl at 0x0042ad43; jge at 0x0042ad4f, 3 instruction(s), falls into the block at 0x0042ad8e
    mov dword ptr [0x5d183f], 0x0                # 0042ad71
    mov word ptr [0x5b15d4], 0xffff              # 0042ad7b
    mov dword ptr [0x5b15c8], 0x0                # 0042ad84
L_0042ad8e:
    # block 0x0042ad8e: entered by jmp at 0x0042ad6f, 2 instruction(s), ends with ret
    pop ebp                                      # 0042ad8e
    ret                                          # 0042ad8f

