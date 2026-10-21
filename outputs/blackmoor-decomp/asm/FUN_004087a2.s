# FUN_004087a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004087a2
# extent:       0x004087a2-0x004087dd (59 code bytes)
# span:         0x004087a2-0x004087dd (code 59, tables 0, padding 0)
# sha256:       f2d4e6d1509533a3dfd433d82d7e93326bdb4a37889e97131451a3e0f32bc989
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4087a2_read_text_word
# naming:       native port src/original_methods_fl35b.c:m4087a2_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x78c), stores the low word of 0x50cb1b(buf) to 0x5ec2c6, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m4087a2_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004087a2 - 0x401000
.globl FUN_004087a2
FUN_004087a2:
    # block 0x004087a2: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004087a2
    {load} mov ebp, esp                          # 004087a3
    sub esp, 0x18                                # 004087a5
    mov dword ptr [ebp - local_18], ecx          # 004087a8
    push 0x13                                    # 004087ab
    lea eax, [ebp - local_14]                    # 004087ad
    push eax                                     # 004087b0
    mov ecx, dword ptr [ebp - local_18]          # 004087b1
    add ecx, 0x78c                               # 004087b4
    call FUN_0051d5b2                            # 004087ba
    lea ecx, [ebp - local_14]                    # 004087bf
    push ecx                                     # 004087c2
    call FUN_0050cb1b                            # 004087c3
    add esp, 0x4                                 # 004087c8
    mov word ptr [0x5ec2c6], ax                  # 004087cb
    mov ecx, dword ptr [ebp - local_18]          # 004087d1
    call FUN_00407ca7                            # 004087d4
    {load} mov esp, ebp                          # 004087d9
    pop ebp                                      # 004087db
    ret                                          # 004087dc

