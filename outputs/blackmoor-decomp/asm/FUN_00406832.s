# FUN_00406832
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406832
# extent:       0x00406832-0x00406879 (71 code bytes)
# span:         0x00406832-0x00406879 (code 71, tables 0, padding 0)
# sha256:       c42ce8fafb9e81356c3950395e875d2d020c945e73016348512c7badea70c96f
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406832_toggle_5e3512
# naming:       native port src/original_methods_fl32a.c:m406832_toggle_5e3512 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3512; when it was not 1 it becomes 1 and a word 0x5e335e equal to 2 becomes 0xffff; then calls 0x404be1; all four jump directions taken, all executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m406832_toggle_5e3512 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406832 - 0x401000
.globl FUN_00406832
FUN_00406832:
    # block 0x00406832: entry, 6 instruction(s), ends with jne to 0x0040684e (forward)
    push ebp                                     # 00406832
    {load} mov ebp, esp                          # 00406833
    push ecx                                     # 00406835
    mov dword ptr [ebp - local_4], ecx           # 00406836
    cmp dword ptr [0x5e3512], 0x1                # 00406839
    jne.d8 L_0040684e                            # 00406840
    # block 0x00406842: entered by fall-through of jne at 0x00406840, 2 instruction(s), ends with forward jump to 0x0040686d
    mov dword ptr [0x5e3512], 0x0                # 00406842
    jmp.d8 L_0040686d                            # 0040684c
L_0040684e:
    # block 0x0040684e: entered by jne at 0x00406840, 4 instruction(s), ends with jne to 0x0040686d (forward)
    mov dword ptr [0x5e3512], 0x1                # 0040684e
    movsx eax, word ptr [0x5e335e]               # 00406858
    cmp eax, 0x2                                 # 0040685f
    jne.d8 L_0040686d                            # 00406862
    # block 0x00406864: entered by fall-through of jne at 0x00406862, 1 instruction(s), falls into the block at 0x0040686d
    mov word ptr [0x5e335e], 0xffff              # 00406864
L_0040686d:
    # block 0x0040686d: entered by jmp at 0x0040684c; jne at 0x00406862, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040686d
    call FUN_00404be1                            # 00406870
    {load} mov esp, ebp                          # 00406875
    pop ebp                                      # 00406877
    ret                                          # 00406878

