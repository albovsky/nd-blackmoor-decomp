# FUN_00408290
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408290
# extent:       0x00408290-0x004082cb (59 code bytes)
# span:         0x00408290-0x004082cb (code 59, tables 0, padding 0)
# sha256:       f73208c253912b24afc5f11fedd16379c9cff6985906afda655e7e6fd76cf3bc
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m408290_read_text_word
# naming:       native port src/original_methods_fl35b.c:m408290_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x20c), stores the low word of 0x50cb1b(buf) to 0x5ec29a, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m408290_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00408290 - 0x401000
.globl FUN_00408290
FUN_00408290:
    # block 0x00408290: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408290
    {load} mov ebp, esp                          # 00408291
    sub esp, 0x18                                # 00408293
    mov dword ptr [ebp - local_18], ecx          # 00408296
    push 0x13                                    # 00408299
    lea eax, [ebp - local_14]                    # 0040829b
    push eax                                     # 0040829e
    mov ecx, dword ptr [ebp - local_18]          # 0040829f
    add ecx, 0x20c                               # 004082a2
    call FUN_0051d5b2                            # 004082a8
    lea ecx, [ebp - local_14]                    # 004082ad
    push ecx                                     # 004082b0
    call FUN_0050cb1b                            # 004082b1
    add esp, 0x4                                 # 004082b6
    mov word ptr [0x5ec29a], ax                  # 004082b9
    mov ecx, dword ptr [ebp - local_18]          # 004082bf
    call FUN_00407ca7                            # 004082c2
    {load} mov esp, ebp                          # 004082c7
    pop ebp                                      # 004082c9
    ret                                          # 004082ca

