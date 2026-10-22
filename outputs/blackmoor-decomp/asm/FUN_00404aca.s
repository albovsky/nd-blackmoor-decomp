# FUN_00404aca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404aca
# extent:       0x00404aca-0x00404af0 (38 code bytes)
# span:         0x00404aca-0x00404af0 (code 38, tables 0, padding 0)
# sha256:       228c569dea1b10f24cacda84b3338223105f2a7fa22190f6079886992404e579
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404aca_lifted
# naming:       native port src/original_methods_fl40.c:m404aca_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 14/14 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005217e4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404aca_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_005217e4, .text + (0x005217e4 - 0x401000)

.org 0x00404aca - 0x401000
.globl FUN_00404aca
FUN_00404aca:
    # block 0x00404aca: entry, 14 instruction(s), calls FUN_005217e4, ends with ret
    push ebp                                     # 00404aca
    {load} mov ebp, esp                          # 00404acb
    push ecx                                     # 00404acd
    mov dword ptr [ebp - local_4], ecx           # 00404ace
    push 0x0                                     # 00404ad1
    push 0x87                                    # 00404ad3
    mov ecx, dword ptr [ebp - local_4]           # 00404ad8
    call FUN_005217e4                            # 00404adb
    mov eax, dword ptr [ebp - local_4]           # 00404ae0
    mov dword ptr [eax], 0x52ba38                # 00404ae3
    mov eax, dword ptr [ebp - local_4]           # 00404ae9
    {load} mov esp, ebp                          # 00404aec
    pop ebp                                      # 00404aee
    ret                                          # 00404aef

