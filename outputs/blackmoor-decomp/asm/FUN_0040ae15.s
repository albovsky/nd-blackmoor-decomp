# FUN_0040ae15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ae15
# extent:       0x0040ae15-0x0040ae67 (82 code bytes)
# span:         0x0040ae15-0x0040ae67 (code 82, tables 0, padding 0)
# sha256:       84e51326e3f5ce357a2f0de3f048515f14e8930b4f846afd206a635e3e643581
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40ae15_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40ae15_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x70c), compares 4 bytes with the tag at 0x53ecc0; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec30a; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40ae15_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040ae15 - 0x401000
.globl FUN_0040ae15
FUN_0040ae15:
    # block 0x0040ae15: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ae59 (forward)
    push ebp                                     # 0040ae15
    {load} mov ebp, esp                          # 0040ae16
    sub esp, 0x18                                # 0040ae18
    push esi                                     # 0040ae1b
    push edi                                     # 0040ae1c
    mov dword ptr [ebp - local_18], ecx          # 0040ae1d
    push 0x13                                    # 0040ae20
    lea eax, [ebp - local_14]                    # 0040ae22
    push eax                                     # 0040ae25
    mov ecx, dword ptr [ebp - local_18]          # 0040ae26
    add ecx, 0x70c                               # 0040ae29
    call FUN_0051d5b2                            # 0040ae2f
    mov edi, 0x53ecc0                            # 0040ae34
    lea esi, [ebp - local_14]                    # 0040ae39
    mov ecx, 0x4                                 # 0040ae3c
    {load} xor edx, edx                          # 0040ae41
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ae43
    je.d8 L_0040ae59                             # 0040ae45
    # block 0x0040ae47: entered by fall-through of je at 0x0040ae45, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ae59
    lea eax, [ebp - local_14]                    # 0040ae47
    push eax                                     # 0040ae4a
    call FUN_0050cb1b                            # 0040ae4b
    add esp, 0x4                                 # 0040ae50
    mov word ptr [0x5ec30a], ax                  # 0040ae53
L_0040ae59:
    # block 0x0040ae59: entered by je at 0x0040ae45, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ae59
    call FUN_004090ab                            # 0040ae5c
    pop edi                                      # 0040ae61
    pop esi                                      # 0040ae62
    {load} mov esp, ebp                          # 0040ae63
    pop ebp                                      # 0040ae65
    ret                                          # 0040ae66

