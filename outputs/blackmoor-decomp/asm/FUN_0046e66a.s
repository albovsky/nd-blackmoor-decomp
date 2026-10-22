# FUN_0046e66a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e66a
# extent:       0x0046e66a-0x0046e6c1 (87 code bytes)
# span:         0x0046e66a-0x0046e6c1 (code 87, tables 0, padding 0)
# sha256:       905b436e4eddba7722a59d470a35c962f2930b63a2ac44794e20791945583e20
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46e66a_lifted
# naming:       native port src/original_methods_fl40.c:m46e66a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 23/23 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e7ba, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46e66a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0046e66a - 0x401000
.globl FUN_0046e66a
FUN_0046e66a:
    # block 0x0046e66a: entry, 23 instruction(s), calls FUN_0051e7ba, FUN_0051d730, ends with ret
    push ebp                                     # 0046e66a
    {load} mov ebp, esp                          # 0046e66b
    push -0x1                                    # 0046e66d
    push 0x52823f                                # 0046e66f
    mov eax, dword ptr fs:[0x0]                  # 0046e674
    push eax                                     # 0046e67a
    mov dword ptr fs:[0x0], esp                  # 0046e67b
    push ecx                                     # 0046e682
    mov dword ptr [ebp - local_10], ecx          # 0046e683
    mov eax, dword ptr [ebp - local_10]          # 0046e686
    mov dword ptr [eax], 0x52d370                # 0046e689
    mov dword ptr [ebp - local_4], 0x0           # 0046e68f
    mov ecx, dword ptr [ebp - local_10]          # 0046e696
    add ecx, 0x8d                                # 0046e699
    call FUN_0051e7ba                            # 0046e69f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046e6a4
    mov ecx, dword ptr [ebp - local_10]          # 0046e6ab
    call FUN_0051d730                            # 0046e6ae
    mov ecx, dword ptr [ebp - local_c]           # 0046e6b3
    mov dword ptr fs:[0x0], ecx                  # 0046e6b6
    {load} mov esp, ebp                          # 0046e6bd
    pop ebp                                      # 0046e6bf
    ret                                          # 0046e6c0

