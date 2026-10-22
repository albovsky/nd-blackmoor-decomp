# FUN_004e0377
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0377
# extent:       0x004e0377-0x004e03d7 (96 code bytes)
# span:         0x004e0377-0x004e03e0 (code 96, tables 0, padding 9)
# sha256:       9952dbc65535924de1252803d987adc8698cf77347229dbc22ab2feba104bb47
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e0377_lifted
# naming:       native port src/original_methods_fl39d.c:m4e0377_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e0377_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004e0377 - 0x401000
.globl FUN_004e0377
FUN_004e0377:
    # block 0x004e0377: entry, 5 instruction(s), ends with jne to 0x004e03af (forward)
    push ebp                                     # 004e0377
    {load} mov ebp, esp                          # 004e0378
    movsx eax, word ptr [0x5835d8]               # 004e037a
    cmp eax, 0x2                                 # 004e0381
    jne.d8 L_004e03af                            # 004e0384
    # block 0x004e0386: entered by fall-through of jne at 0x004e0384, 10 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e03d5
    push 0x55bb0c                                # 004e0386
    push 0x5832ce                                # 004e038b
    push 0x58330e                                # 004e0390
    mov ecx, dword ptr [0x5cf665]                # 004e0395
    push ecx                                     # 004e039b
    mov edx, dword ptr [0x5d298b]                # 004e039c
    push edx                                     # 004e03a2
    mov ecx, 0x5cf659                            # 004e03a3
    call FUN_004c5377                            # 004e03a8
    jmp.d8 L_004e03d5                            # 004e03ad
L_004e03af:
    # block 0x004e03af: entered by jne at 0x004e0384, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004e03d5
    push 0x55bb2c                                # 004e03af
    push 0x5832ce                                # 004e03b4
    push 0x5832ce                                # 004e03b9
    mov eax, dword ptr [0x5cf665]                # 004e03be
    push eax                                     # 004e03c3
    mov ecx, dword ptr [0x5d2819]                # 004e03c4
    push ecx                                     # 004e03ca
    mov ecx, 0x5cf659                            # 004e03cb
    call FUN_004c5377                            # 004e03d0
L_004e03d5:
    # block 0x004e03d5: entered by jmp at 0x004e03ad, 2 instruction(s), ends with ret
    pop ebp                                      # 004e03d5
    ret                                          # 004e03d6

# --- data items (not part of the function) -------------------------
.org 0x004e03d7 - 0x401000
PAD_004e03d7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

