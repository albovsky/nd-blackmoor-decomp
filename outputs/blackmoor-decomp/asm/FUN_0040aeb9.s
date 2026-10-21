# FUN_0040aeb9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040aeb9
# extent:       0x0040aeb9-0x0040af0b (82 code bytes)
# span:         0x0040aeb9-0x0040af0b (code 82, tables 0, padding 0)
# sha256:       c0784fc57fb1bb71a097edfa20dafd059dcaf47bf45cdc1284e74329445ede93
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40aeb9_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40aeb9_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x78c), compares 4 bytes with the tag at 0x53ecc8; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec30e; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40aeb9_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040aeb9 - 0x401000
.globl FUN_0040aeb9
FUN_0040aeb9:
    # block 0x0040aeb9: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aefd (forward)
    push ebp                                     # 0040aeb9
    {load} mov ebp, esp                          # 0040aeba
    sub esp, 0x18                                # 0040aebc
    push esi                                     # 0040aebf
    push edi                                     # 0040aec0
    mov dword ptr [ebp - local_18], ecx          # 0040aec1
    push 0x13                                    # 0040aec4
    lea eax, [ebp - local_14]                    # 0040aec6
    push eax                                     # 0040aec9
    mov ecx, dword ptr [ebp - local_18]          # 0040aeca
    add ecx, 0x78c                               # 0040aecd
    call FUN_0051d5b2                            # 0040aed3
    mov edi, 0x53ecc8                            # 0040aed8
    lea esi, [ebp - local_14]                    # 0040aedd
    mov ecx, 0x4                                 # 0040aee0
    {load} xor edx, edx                          # 0040aee5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040aee7
    je.d8 L_0040aefd                             # 0040aee9
    # block 0x0040aeeb: entered by fall-through of je at 0x0040aee9, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040aefd
    lea eax, [ebp - local_14]                    # 0040aeeb
    push eax                                     # 0040aeee
    call FUN_0050cb1b                            # 0040aeef
    add esp, 0x4                                 # 0040aef4
    mov word ptr [0x5ec30e], ax                  # 0040aef7
L_0040aefd:
    # block 0x0040aefd: entered by je at 0x0040aee9, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aefd
    call FUN_004090ab                            # 0040af00
    pop edi                                      # 0040af05
    pop esi                                      # 0040af06
    {load} mov esp, ebp                          # 0040af07
    pop ebp                                      # 0040af09
    ret                                          # 0040af0a

