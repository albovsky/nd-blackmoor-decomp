# FUN_0040a613
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a613
# extent:       0x0040a613-0x0040a665 (82 code bytes)
# span:         0x0040a613-0x0040a665 (code 82, tables 0, padding 0)
# sha256:       ce4dfa42228e1b0a9a83065ef3846ccdf9c3cce316c702a7cbf8fa8f64266da5
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40a613_read_tag_word
# naming:       native port src/original_methods_fl32b.c:m40a613_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0xcc), compares 4 bytes with the tag at 0x53ec5c; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec2d8; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32b.c:m40a613_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040a613 - 0x401000
.globl FUN_0040a613
FUN_0040a613:
    # block 0x0040a613: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a657 (forward)
    push ebp                                     # 0040a613
    {load} mov ebp, esp                          # 0040a614
    sub esp, 0x18                                # 0040a616
    push esi                                     # 0040a619
    push edi                                     # 0040a61a
    mov dword ptr [ebp - local_18], ecx          # 0040a61b
    push 0x13                                    # 0040a61e
    lea eax, [ebp - local_14]                    # 0040a620
    push eax                                     # 0040a623
    mov ecx, dword ptr [ebp - local_18]          # 0040a624
    add ecx, 0xcc                                # 0040a627
    call FUN_0051d5b2                            # 0040a62d
    mov edi, 0x53ec5c                            # 0040a632
    lea esi, [ebp - local_14]                    # 0040a637
    mov ecx, 0x4                                 # 0040a63a
    {load} xor edx, edx                          # 0040a63f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a641
    je.d8 L_0040a657                             # 0040a643
    # block 0x0040a645: entered by fall-through of je at 0x0040a643, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a657
    lea eax, [ebp - local_14]                    # 0040a645
    push eax                                     # 0040a648
    call FUN_0050cb1b                            # 0040a649
    add esp, 0x4                                 # 0040a64e
    mov word ptr [0x5ec2d8], ax                  # 0040a651
L_0040a657:
    # block 0x0040a657: entered by je at 0x0040a643, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a657
    call FUN_004090ab                            # 0040a65a
    pop edi                                      # 0040a65f
    pop esi                                      # 0040a660
    {load} mov esp, ebp                          # 0040a661
    pop ebp                                      # 0040a663
    ret                                          # 0040a664

