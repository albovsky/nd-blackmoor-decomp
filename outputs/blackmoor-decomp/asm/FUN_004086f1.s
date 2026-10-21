# FUN_004086f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004086f1
# extent:       0x004086f1-0x0040872c (59 code bytes)
# span:         0x004086f1-0x0040872c (code 59, tables 0, padding 0)
# sha256:       d4118f706f7cd66b5528bb5111177ab15a482df0d42444cd21c80b2edea29263
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4086f1_read_text_word
# naming:       native port src/original_methods_fl35b.c:m4086f1_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x6cc), stores the low word of 0x50cb1b(buf) to 0x5ec2c0, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m4086f1_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004086f1 - 0x401000
.globl FUN_004086f1
FUN_004086f1:
    # block 0x004086f1: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004086f1
    {load} mov ebp, esp                          # 004086f2
    sub esp, 0x18                                # 004086f4
    mov dword ptr [ebp - local_18], ecx          # 004086f7
    push 0x13                                    # 004086fa
    lea eax, [ebp - local_14]                    # 004086fc
    push eax                                     # 004086ff
    mov ecx, dword ptr [ebp - local_18]          # 00408700
    add ecx, 0x6cc                               # 00408703
    call FUN_0051d5b2                            # 00408709
    lea ecx, [ebp - local_14]                    # 0040870e
    push ecx                                     # 00408711
    call FUN_0050cb1b                            # 00408712
    add esp, 0x4                                 # 00408717
    mov word ptr [0x5ec2c0], ax                  # 0040871a
    mov ecx, dword ptr [ebp - local_18]          # 00408720
    call FUN_00407ca7                            # 00408723
    {load} mov esp, ebp                          # 00408728
    pop ebp                                      # 0040872a
    ret                                          # 0040872b

