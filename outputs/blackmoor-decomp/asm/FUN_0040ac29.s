# FUN_0040ac29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ac29
# extent:       0x0040ac29-0x0040ac7b (82 code bytes)
# span:         0x0040ac29-0x0040ac7b (code 82, tables 0, padding 0)
# sha256:       26eb48456d82bf4b265b2db2108ab9c385784877d507b18d8c70b8eda817629d
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40ac29_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40ac29_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x58c), compares 4 bytes with the tag at 0x53eca8; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec2fe; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40ac29_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040ac29 - 0x401000
.globl FUN_0040ac29
FUN_0040ac29:
    # block 0x0040ac29: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ac6d (forward)
    push ebp                                     # 0040ac29
    {load} mov ebp, esp                          # 0040ac2a
    sub esp, 0x18                                # 0040ac2c
    push esi                                     # 0040ac2f
    push edi                                     # 0040ac30
    mov dword ptr [ebp - local_18], ecx          # 0040ac31
    push 0x13                                    # 0040ac34
    lea eax, [ebp - local_14]                    # 0040ac36
    push eax                                     # 0040ac39
    mov ecx, dword ptr [ebp - local_18]          # 0040ac3a
    add ecx, 0x58c                               # 0040ac3d
    call FUN_0051d5b2                            # 0040ac43
    mov edi, 0x53eca8                            # 0040ac48
    lea esi, [ebp - local_14]                    # 0040ac4d
    mov ecx, 0x4                                 # 0040ac50
    {load} xor edx, edx                          # 0040ac55
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ac57
    je.d8 L_0040ac6d                             # 0040ac59
    # block 0x0040ac5b: entered by fall-through of je at 0x0040ac59, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ac6d
    lea eax, [ebp - local_14]                    # 0040ac5b
    push eax                                     # 0040ac5e
    call FUN_0050cb1b                            # 0040ac5f
    add esp, 0x4                                 # 0040ac64
    mov word ptr [0x5ec2fe], ax                  # 0040ac67
L_0040ac6d:
    # block 0x0040ac6d: entered by je at 0x0040ac59, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ac6d
    call FUN_004090ab                            # 0040ac70
    pop edi                                      # 0040ac75
    pop esi                                      # 0040ac76
    {load} mov esp, ebp                          # 0040ac77
    pop ebp                                      # 0040ac79
    ret                                          # 0040ac7a

