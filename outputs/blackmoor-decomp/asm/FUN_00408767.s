# FUN_00408767
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408767
# extent:       0x00408767-0x004087a2 (59 code bytes)
# span:         0x00408767-0x004087a2 (code 59, tables 0, padding 0)
# sha256:       01c7a5a8980fef11cfc0ced1ba096db9e06142f78743ee79cc9806d12c923bf5
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m408767_read_text_word
# naming:       native port src/original_methods_fl35b.c:m408767_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x74c), stores the low word of 0x50cb1b(buf) to 0x5ec2c4, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m408767_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00408767 - 0x401000
.globl FUN_00408767
FUN_00408767:
    # block 0x00408767: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408767
    {load} mov ebp, esp                          # 00408768
    sub esp, 0x18                                # 0040876a
    mov dword ptr [ebp - local_18], ecx          # 0040876d
    push 0x13                                    # 00408770
    lea eax, [ebp - local_14]                    # 00408772
    push eax                                     # 00408775
    mov ecx, dword ptr [ebp - local_18]          # 00408776
    add ecx, 0x74c                               # 00408779
    call FUN_0051d5b2                            # 0040877f
    lea ecx, [ebp - local_14]                    # 00408784
    push ecx                                     # 00408787
    call FUN_0050cb1b                            # 00408788
    add esp, 0x4                                 # 0040878d
    mov word ptr [0x5ec2c4], ax                  # 00408790
    mov ecx, dword ptr [ebp - local_18]          # 00408796
    call FUN_00407ca7                            # 00408799
    {load} mov esp, ebp                          # 0040879e
    pop ebp                                      # 004087a0
    ret                                          # 004087a1

