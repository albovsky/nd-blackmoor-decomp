# FUN_0040a75b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a75b
# extent:       0x0040a75b-0x0040a7ad (82 code bytes)
# span:         0x0040a75b-0x0040a7ad (code 82, tables 0, padding 0)
# sha256:       3d88e96add455af1c9813119abc5350abbef168360bc326380b69c81e471102e
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40a75b_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40a75b_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x1cc), compares 4 bytes with the tag at 0x53ec6c; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec2e0; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40a75b_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040a75b - 0x401000
.globl FUN_0040a75b
FUN_0040a75b:
    # block 0x0040a75b: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a79f (forward)
    push ebp                                     # 0040a75b
    {load} mov ebp, esp                          # 0040a75c
    sub esp, 0x18                                # 0040a75e
    push esi                                     # 0040a761
    push edi                                     # 0040a762
    mov dword ptr [ebp - local_18], ecx          # 0040a763
    push 0x13                                    # 0040a766
    lea eax, [ebp - local_14]                    # 0040a768
    push eax                                     # 0040a76b
    mov ecx, dword ptr [ebp - local_18]          # 0040a76c
    add ecx, 0x1cc                               # 0040a76f
    call FUN_0051d5b2                            # 0040a775
    mov edi, 0x53ec6c                            # 0040a77a
    lea esi, [ebp - local_14]                    # 0040a77f
    mov ecx, 0x4                                 # 0040a782
    {load} xor edx, edx                          # 0040a787
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a789
    je.d8 L_0040a79f                             # 0040a78b
    # block 0x0040a78d: entered by fall-through of je at 0x0040a78b, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a79f
    lea eax, [ebp - local_14]                    # 0040a78d
    push eax                                     # 0040a790
    call FUN_0050cb1b                            # 0040a791
    add esp, 0x4                                 # 0040a796
    mov word ptr [0x5ec2e0], ax                  # 0040a799
L_0040a79f:
    # block 0x0040a79f: entered by je at 0x0040a78b, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a79f
    call FUN_004090ab                            # 0040a7a2
    pop edi                                      # 0040a7a7
    pop esi                                      # 0040a7a8
    {load} mov esp, ebp                          # 0040a7a9
    pop ebp                                      # 0040a7ab
    ret                                          # 0040a7ac

