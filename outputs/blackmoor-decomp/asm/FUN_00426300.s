# FUN_00426300
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426300
# extent:       0x00426300-0x00426346 (70 code bytes)
# span:         0x00426300-0x00426346 (code 70, tables 0, padding 0)
# sha256:       82cce8c622610b53555e13237ae31200f4d49ce912a8d376d9717f91169eee30
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426300_lifted
# naming:       native port src/original_methods_fl40.c:m426300_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 23/23 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426300_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00426300 - 0x401000
.globl FUN_00426300
FUN_00426300:
    # block 0x00426300: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0042633f (forward)
    push ebp                                     # 00426300
    {load} mov ebp, esp                          # 00426301
    sub esp, 0x8                                 # 00426303
    mov dword ptr [ebp - local_8], ecx           # 00426306
    push 0x400                                   # 00426309
    call FUN_0051dc43                            # 0042630e
    add esp, 0x4                                 # 00426313
    mov dword ptr [ebp - local_4], eax           # 00426316
    mov eax, dword ptr [ebp - local_8]           # 00426319
    mov ecx, dword ptr [ebp - local_4]           # 0042631c
    mov dword ptr [eax], ecx                     # 0042631f
    cmp dword ptr [ebp - local_4], 0x0           # 00426321
    jne.d8 L_0042633f                            # 00426325
    # block 0x00426327: entered by fall-through of jne at 0x00426325, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0042633f
    push 0x0                                     # 00426327
    push 0x0                                     # 00426329
    push 0x545440                                # 0042632b
    call FUN_0052139c                            # 00426330
    mov ecx, 0x5cf659                            # 00426335
    call FUN_004c97b4                            # 0042633a
L_0042633f:
    # block 0x0042633f: entered by jne at 0x00426325, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 0042633f
    {load} mov esp, ebp                          # 00426342
    pop ebp                                      # 00426344
    ret                                          # 00426345

