# FUN_0040adc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040adc3
# extent:       0x0040adc3-0x0040ae15 (82 code bytes)
# span:         0x0040adc3-0x0040ae15 (code 82, tables 0, padding 0)
# sha256:       a2875d94eb4d4857b6d8740e36067429dde48d15857587e923d61cef1cf4b96d
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40adc3_read_tag_word
# naming:       native port src/original_methods_fl35a.c:m40adc3_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Fills a 0x13-byte local via 0x51d5b2(self+0x6cc), compares 4 bytes with the tag at 0x53ecbc; if they differ stores the low word of 0x50cb1b(buf) to 0x5ec308; returns 0x4090ab(self). je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35a.c:m40adc3_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040adc3 - 0x401000
.globl FUN_0040adc3
FUN_0040adc3:
    # block 0x0040adc3: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ae07 (forward)
    push ebp                                     # 0040adc3
    {load} mov ebp, esp                          # 0040adc4
    sub esp, 0x18                                # 0040adc6
    push esi                                     # 0040adc9
    push edi                                     # 0040adca
    mov dword ptr [ebp - local_18], ecx          # 0040adcb
    push 0x13                                    # 0040adce
    lea eax, [ebp - local_14]                    # 0040add0
    push eax                                     # 0040add3
    mov ecx, dword ptr [ebp - local_18]          # 0040add4
    add ecx, 0x6cc                               # 0040add7
    call FUN_0051d5b2                            # 0040addd
    mov edi, 0x53ecbc                            # 0040ade2
    lea esi, [ebp - local_14]                    # 0040ade7
    mov ecx, 0x4                                 # 0040adea
    {load} xor edx, edx                          # 0040adef
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040adf1
    je.d8 L_0040ae07                             # 0040adf3
    # block 0x0040adf5: entered by fall-through of je at 0x0040adf3, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ae07
    lea eax, [ebp - local_14]                    # 0040adf5
    push eax                                     # 0040adf8
    call FUN_0050cb1b                            # 0040adf9
    add esp, 0x4                                 # 0040adfe
    mov word ptr [0x5ec308], ax                  # 0040ae01
L_0040ae07:
    # block 0x0040ae07: entered by je at 0x0040adf3, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ae07
    call FUN_004090ab                            # 0040ae0a
    pop edi                                      # 0040ae0f
    pop esi                                      # 0040ae10
    {load} mov esp, ebp                          # 0040ae11
    pop ebp                                      # 0040ae13
    ret                                          # 0040ae14

