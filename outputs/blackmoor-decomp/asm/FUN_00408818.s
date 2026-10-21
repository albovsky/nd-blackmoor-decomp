# FUN_00408818
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408818
# extent:       0x00408818-0x00408853 (59 code bytes)
# span:         0x00408818-0x00408853 (code 59, tables 0, padding 0)
# sha256:       ecf3f7fa7db969234e8ca9295c0e87f1de02f4c79d77c30263047fb32dab4474
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m408818_read_text_word
# naming:       native port src/original_methods_fl35b.c:m408818_read_text_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x80c), stores the low word of 0x50cb1b(buf) to 0x5ec2ca, returns 0x407ca7(self). No branch; all 20 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m408818_read_text_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00408818 - 0x401000
.globl FUN_00408818
FUN_00408818:
    # block 0x00408818: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408818
    {load} mov ebp, esp                          # 00408819
    sub esp, 0x18                                # 0040881b
    mov dword ptr [ebp - local_18], ecx          # 0040881e
    push 0x13                                    # 00408821
    lea eax, [ebp - local_14]                    # 00408823
    push eax                                     # 00408826
    mov ecx, dword ptr [ebp - local_18]          # 00408827
    add ecx, 0x80c                               # 0040882a
    call FUN_0051d5b2                            # 00408830
    lea ecx, [ebp - local_14]                    # 00408835
    push ecx                                     # 00408838
    call FUN_0050cb1b                            # 00408839
    add esp, 0x4                                 # 0040883e
    mov word ptr [0x5ec2ca], ax                  # 00408841
    mov ecx, dword ptr [ebp - local_18]          # 00408847
    call FUN_00407ca7                            # 0040884a
    {load} mov esp, ebp                          # 0040884f
    pop ebp                                      # 00408851
    ret                                          # 00408852

