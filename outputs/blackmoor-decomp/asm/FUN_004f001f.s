# FUN_004f001f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f001f
# extent:       0x004f001f-0x004f003b (28 code bytes)
# span:         0x004f001f-0x004f003b (code 28, tables 0, padding 0)
# sha256:       9ae3c66c07192e7a88c883260bf73f793f7c6ed2a22dff7adb2db26265dd5570
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f001f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f0046
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004f0046, .text + (0x004f0046 - 0x401000)

.org 0x004f001f - 0x401000
.globl FUN_004f001f
FUN_004f001f:
    # block 0x004f001f: entry, 11 instruction(s), calls FUN_004f0046, ends with ret
    push ebp                                     # 004f001f
    {load} mov ebp, esp                          # 004f0020
    push ecx                                     # 004f0022
    mov dword ptr [ebp - local_4], ecx           # 004f0023
    mov eax, dword ptr [ebp - local_4]           # 004f0026
    mov dword ptr [eax], 0x52e504                # 004f0029
    mov ecx, dword ptr [ebp - local_4]           # 004f002f
    call FUN_004f0046                            # 004f0032
    {load} mov esp, ebp                          # 004f0037
    pop ebp                                      # 004f0039
    ret                                          # 004f003a

