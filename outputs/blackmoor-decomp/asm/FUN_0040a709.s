# FUN_0040a709
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a709
# extent:       0x0040a709-0x0040a75b (82 code bytes)
# span:         0x0040a709-0x0040a75b (code 82, tables 0, padding 0)
# sha256:       2401c5de75a859bcdf97c397b1731b094f90bfad9af32ec99ba40af3dc00f8a3
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40a709_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40a709_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x18c), compares 4 bytes with the tag at 0x53ec68; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec2de; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40a709_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040a709 - 0x401000
.globl FUN_0040a709
FUN_0040a709:
    # block 0x0040a709: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a74d (forward)
    push ebp                                     # 0040a709
    {load} mov ebp, esp                          # 0040a70a
    sub esp, 0x18                                # 0040a70c
    push esi                                     # 0040a70f
    push edi                                     # 0040a710
    mov dword ptr [ebp - local_18], ecx          # 0040a711
    push 0x13                                    # 0040a714
    lea eax, [ebp - local_14]                    # 0040a716
    push eax                                     # 0040a719
    mov ecx, dword ptr [ebp - local_18]          # 0040a71a
    add ecx, 0x18c                               # 0040a71d
    call FUN_0051d5b2                            # 0040a723
    mov edi, 0x53ec68                            # 0040a728
    lea esi, [ebp - local_14]                    # 0040a72d
    mov ecx, 0x4                                 # 0040a730
    {load} xor edx, edx                          # 0040a735
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a737
    je.d8 L_0040a74d                             # 0040a739
    # block 0x0040a73b: entered by fall-through of je at 0x0040a739, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a74d
    lea eax, [ebp - local_14]                    # 0040a73b
    push eax                                     # 0040a73e
    call FUN_0050cb1b                            # 0040a73f
    add esp, 0x4                                 # 0040a744
    mov word ptr [0x5ec2de], ax                  # 0040a747
L_0040a74d:
    # block 0x0040a74d: entered by je at 0x0040a739, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a74d
    call FUN_004090ab                            # 0040a750
    pop edi                                      # 0040a755
    pop esi                                      # 0040a756
    {load} mov esp, ebp                          # 0040a757
    pop ebp                                      # 0040a759
    ret                                          # 0040a75a

