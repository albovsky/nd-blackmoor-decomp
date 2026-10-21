# FUN_00408169
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408169
# extent:       0x00408169-0x004081a4 (59 code bytes)
# span:         0x00408169-0x004081a4 (code 59, tables 0, padding 0)
# sha256:       4787849fae57157e545a9a33bb8f092b066b2062a1d58e7f7a8777c90417e06f
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m408169_read_text_word
# naming:       native port src/original_methods_fl35b.c:m408169_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0xcc), stores the low word of 0x50cb1b(buf) to 0x5ec290, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m408169_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00408169 - 0x401000
.globl FUN_00408169
FUN_00408169:
    # block 0x00408169: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408169
    {load} mov ebp, esp                          # 0040816a
    sub esp, 0x18                                # 0040816c
    mov dword ptr [ebp - local_18], ecx          # 0040816f
    push 0x13                                    # 00408172
    lea eax, [ebp - local_14]                    # 00408174
    push eax                                     # 00408177
    mov ecx, dword ptr [ebp - local_18]          # 00408178
    add ecx, 0xcc                                # 0040817b
    call FUN_0051d5b2                            # 00408181
    lea ecx, [ebp - local_14]                    # 00408186
    push ecx                                     # 00408189
    call FUN_0050cb1b                            # 0040818a
    add esp, 0x4                                 # 0040818f
    mov word ptr [0x5ec290], ax                  # 00408192
    mov ecx, dword ptr [ebp - local_18]          # 00408198
    call FUN_00407ca7                            # 0040819b
    {load} mov esp, ebp                          # 004081a0
    pop ebp                                      # 004081a2
    ret                                          # 004081a3

