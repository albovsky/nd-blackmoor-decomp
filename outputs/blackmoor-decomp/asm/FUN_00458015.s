# FUN_00458015
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458015
# extent:       0x00458015-0x00458045 (48 code bytes)
# span:         0x00458015-0x00458045 (code 48, tables 0, padding 0)
# sha256:       f3ae0152d92f52e7d3ce083da51d42fe9e32366ed459771782c65d24e5f0909f
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m458015_lifted
# naming:       native port src/original_methods_fl40.c:m458015_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 16/16 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m458015_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00458015 - 0x401000
.globl FUN_00458015
FUN_00458015:
    # block 0x00458015: entry, 16 instruction(s), ends with ret
    push ebp                                     # 00458015
    {load} mov ebp, esp                          # 00458016
    push ecx                                     # 00458018
    push edi                                     # 00458019
    mov dword ptr [ebp - local_4], ecx           # 0045801a
    mov dword ptr [0x5a4bd2], 0x0                # 0045801d
    mov ecx, 0x6                                 # 00458027
    or eax, -0x1                                 # 0045802c
    mov edi, 0x5a4bd6                            # 0045802f
    rep stosd dword ptr es:[edi], eax            # 00458034
    stosb byte ptr es:[edi], al                  # 00458036
    mov word ptr [0x5a4c08], 0x0                 # 00458037
    pop edi                                      # 00458040
    {load} mov esp, ebp                          # 00458041
    pop ebp                                      # 00458043
    ret                                          # 00458044

