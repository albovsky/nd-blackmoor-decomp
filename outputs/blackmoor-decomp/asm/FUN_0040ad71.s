# FUN_0040ad71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ad71
# extent:       0x0040ad71-0x0040adc3 (82 code bytes)
# span:         0x0040ad71-0x0040adc3 (code 82, tables 0, padding 0)
# sha256:       d484c47a7f9050ab7c0468aae3595ead17d59698a82070a26a6f23078007e805
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40ad71_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40ad71_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x68c), compares 4 bytes with the tag at 0x53ecb8; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec306; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40ad71_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040ad71 - 0x401000
.globl FUN_0040ad71
FUN_0040ad71:
    # block 0x0040ad71: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040adb5 (forward)
    push ebp                                     # 0040ad71
    {load} mov ebp, esp                          # 0040ad72
    sub esp, 0x18                                # 0040ad74
    push esi                                     # 0040ad77
    push edi                                     # 0040ad78
    mov dword ptr [ebp - local_18], ecx          # 0040ad79
    push 0x13                                    # 0040ad7c
    lea eax, [ebp - local_14]                    # 0040ad7e
    push eax                                     # 0040ad81
    mov ecx, dword ptr [ebp - local_18]          # 0040ad82
    add ecx, 0x68c                               # 0040ad85
    call FUN_0051d5b2                            # 0040ad8b
    mov edi, 0x53ecb8                            # 0040ad90
    lea esi, [ebp - local_14]                    # 0040ad95
    mov ecx, 0x4                                 # 0040ad98
    {load} xor edx, edx                          # 0040ad9d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ad9f
    je.d8 L_0040adb5                             # 0040ada1
    # block 0x0040ada3: entered by fall-through of je at 0x0040ada1, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040adb5
    lea eax, [ebp - local_14]                    # 0040ada3
    push eax                                     # 0040ada6
    call FUN_0050cb1b                            # 0040ada7
    add esp, 0x4                                 # 0040adac
    mov word ptr [0x5ec306], ax                  # 0040adaf
L_0040adb5:
    # block 0x0040adb5: entered by je at 0x0040ada1, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040adb5
    call FUN_004090ab                            # 0040adb8
    pop edi                                      # 0040adbd
    pop esi                                      # 0040adbe
    {load} mov esp, ebp                          # 0040adbf
    pop ebp                                      # 0040adc1
    ret                                          # 0040adc2

