# FUN_004087dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004087dd
# extent:       0x004087dd-0x00408818 (59 code bytes)
# span:         0x004087dd-0x00408818 (code 59, tables 0, padding 0)
# sha256:       dd65b2f1c7bb907c16d4f527d473865079fb8c9bd8cafd30d3717af77db26c24
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4087dd_read_text_word
# naming:       native port src/original_methods_fl35b.c:m4087dd_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x7cc), stores the low word of 0x50cb1b(buf) to 0x5ec2c8, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m4087dd_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004087dd - 0x401000
.globl FUN_004087dd
FUN_004087dd:
    # block 0x004087dd: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004087dd
    {load} mov ebp, esp                          # 004087de
    sub esp, 0x18                                # 004087e0
    mov dword ptr [ebp - local_18], ecx          # 004087e3
    push 0x13                                    # 004087e6
    lea eax, [ebp - local_14]                    # 004087e8
    push eax                                     # 004087eb
    mov ecx, dword ptr [ebp - local_18]          # 004087ec
    add ecx, 0x7cc                               # 004087ef
    call FUN_0051d5b2                            # 004087f5
    lea ecx, [ebp - local_14]                    # 004087fa
    push ecx                                     # 004087fd
    call FUN_0050cb1b                            # 004087fe
    add esp, 0x4                                 # 00408803
    mov word ptr [0x5ec2c8], ax                  # 00408806
    mov ecx, dword ptr [ebp - local_18]          # 0040880c
    call FUN_00407ca7                            # 0040880f
    {load} mov esp, ebp                          # 00408814
    pop ebp                                      # 00408816
    ret                                          # 00408817

