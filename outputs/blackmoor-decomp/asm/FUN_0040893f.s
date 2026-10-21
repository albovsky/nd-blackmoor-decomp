# FUN_0040893f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040893f
# extent:       0x0040893f-0x0040897a (59 code bytes)
# span:         0x0040893f-0x00408980 (code 59, tables 0, padding 6)
# sha256:       07a241be64df94e16479cd66c9725c6d1c188954c14e1d31547a1d1794bb23f3
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40893f_read_word_setting
# naming:       native port src/original_methods_fl38c.c:m40893f_read_word_setting (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    String read by 0x51d5b2 (this+0x94c) into a local, converted by 0x50cb1b, low word stored at [0x5ec2d4], then 0x407ca7(this). 20/20 instructions, no jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m40893f_read_word_setting (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_00407ca7, .text + (0x00407ca7 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040893f - 0x401000
.globl FUN_0040893f
FUN_0040893f:
    # block 0x0040893f: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040893f
    {load} mov ebp, esp                          # 00408940
    sub esp, 0x18                                # 00408942
    mov dword ptr [ebp - local_18], ecx          # 00408945
    push 0x13                                    # 00408948
    lea eax, [ebp - local_14]                    # 0040894a
    push eax                                     # 0040894d
    mov ecx, dword ptr [ebp - local_18]          # 0040894e
    add ecx, 0x94c                               # 00408951
    call FUN_0051d5b2                            # 00408957
    lea ecx, [ebp - local_14]                    # 0040895c
    push ecx                                     # 0040895f
    call FUN_0050cb1b                            # 00408960
    add esp, 0x4                                 # 00408965
    mov word ptr [0x5ec2d4], ax                  # 00408968
    mov ecx, dword ptr [ebp - local_18]          # 0040896e
    call FUN_00407ca7                            # 00408971
    {load} mov esp, ebp                          # 00408976
    pop ebp                                      # 00408978
    ret                                          # 00408979

# --- data items (not part of the function) -------------------------
.org 0x0040897a - 0x401000
PAD_0040897a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

