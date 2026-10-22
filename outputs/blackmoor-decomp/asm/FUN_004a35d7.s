# FUN_004a35d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a35d7
# extent:       0x004a35d7-0x004a3667 (144 code bytes)
# span:         0x004a35d7-0x004a3670 (code 144, tables 0, padding 9)
# sha256:       3dae7b19975152f44af985383bc7df3696869d2031668404d9aca9d96f4d1d25
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a35d7_lifted
# naming:       native port src/original_methods_fl41.c:m4a35d7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 39/39 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004d2c20
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a35d7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)

.org 0x004a35d7 - 0x401000
.globl FUN_004a35d7
FUN_004a35d7:
    # block 0x004a35d7: entry, 39 instruction(s), calls FUN_004c5377, FUN_004d2c20, ends with ret
    push ebp                                     # 004a35d7
    {load} mov ebp, esp                          # 004a35d8
    push 0x5504b0                                # 004a35da
    push 0x61d305                                # 004a35df
    mov eax, dword ptr [0x61d2fd]                # 004a35e4
    add eax, 0x6                                 # 004a35e9
    push eax                                     # 004a35ec
    mov ecx, dword ptr [0x5cf665]                # 004a35ed
    push ecx                                     # 004a35f3
    mov edx, dword ptr [0x5d15e3]                # 004a35f4
    push edx                                     # 004a35fa
    mov ecx, 0x5cf659                            # 004a35fb
    call FUN_004c5377                            # 004a3600
    push 0x0                                     # 004a3605
    mov eax, dword ptr [0x5cf665]                # 004a3607
    push eax                                     # 004a360c
    mov ecx, dword ptr [0x61d2fd]                # 004a360d
    movsx edx, word ptr [ecx]                    # 004a3613
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004a3616
    push eax                                     # 004a361d
    mov cx, word ptr [0x61d311]                  # 004a361e
    push ecx                                     # 004a3625
    mov dx, word ptr [0x61d305]                  # 004a3626
    push edx                                     # 004a362d
    mov eax, dword ptr [0x61d2fd]                # 004a362e
    movsx ecx, word ptr [eax]                    # 004a3633
    imul ecx, ecx, 0x1d0                         # 004a3636
    add ecx, 0x5adb3a                            # 004a363c
    push ecx                                     # 004a3642
    mov edx, dword ptr [0x61d2fd]                # 004a3643
    movsx eax, word ptr [edx]                    # 004a3649
    imul eax, eax, 0x7f3                         # 004a364c
    add eax, 0x5a4c24                            # 004a3652
    push eax                                     # 004a3657
    push 0x61d315                                # 004a3658
    call FUN_004d2c20                            # 004a365d
    add esp, 0x20                                # 004a3662
    pop ebp                                      # 004a3665
    ret                                          # 004a3666

# --- data items (not part of the function) -------------------------
.org 0x004a3667 - 0x401000
PAD_004a3667:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

