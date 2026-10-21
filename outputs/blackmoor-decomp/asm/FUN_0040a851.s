# FUN_0040a851
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a851
# extent:       0x0040a851-0x0040a8a3 (82 code bytes)
# span:         0x0040a851-0x0040a8a3 (code 82, tables 0, padding 0)
# sha256:       319916875f2ee609938e0d6761a08ecb1ae41a9f420d0d62eb130ae007f25811
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40a851_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40a851_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x28c), compares 4 bytes with the tag at 0x53ec78; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec2e6; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40a851_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040a851 - 0x401000
.globl FUN_0040a851
FUN_0040a851:
    # block 0x0040a851: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a895 (forward)
    push ebp                                     # 0040a851
    {load} mov ebp, esp                          # 0040a852
    sub esp, 0x18                                # 0040a854
    push esi                                     # 0040a857
    push edi                                     # 0040a858
    mov dword ptr [ebp - local_18], ecx          # 0040a859
    push 0x13                                    # 0040a85c
    lea eax, [ebp - local_14]                    # 0040a85e
    push eax                                     # 0040a861
    mov ecx, dword ptr [ebp - local_18]          # 0040a862
    add ecx, 0x28c                               # 0040a865
    call FUN_0051d5b2                            # 0040a86b
    mov edi, 0x53ec78                            # 0040a870
    lea esi, [ebp - local_14]                    # 0040a875
    mov ecx, 0x4                                 # 0040a878
    {load} xor edx, edx                          # 0040a87d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a87f
    je.d8 L_0040a895                             # 0040a881
    # block 0x0040a883: entered by fall-through of je at 0x0040a881, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a895
    lea eax, [ebp - local_14]                    # 0040a883
    push eax                                     # 0040a886
    call FUN_0050cb1b                            # 0040a887
    add esp, 0x4                                 # 0040a88c
    mov word ptr [0x5ec2e6], ax                  # 0040a88f
L_0040a895:
    # block 0x0040a895: entered by je at 0x0040a881, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a895
    call FUN_004090ab                            # 0040a898
    pop edi                                      # 0040a89d
    pop esi                                      # 0040a89e
    {load} mov esp, ebp                          # 0040a89f
    pop ebp                                      # 0040a8a1
    ret                                          # 0040a8a2

