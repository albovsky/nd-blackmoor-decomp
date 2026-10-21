# FUN_004cc927
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc927
# extent:       0x004cc927-0x004cc946 (31 code bytes)
# span:         0x004cc927-0x004cc946 (code 31, tables 0, padding 0)
# sha256:       41c5a6978548afca14d547d526945664fbd9bfd7671d1b339a80bae2f1b9e797
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cc927_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m4cc927_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), then stores 0x52e278u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4cc927_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004cc927 - 0x401000
.globl FUN_004cc927
FUN_004cc927:
    # block 0x004cc927: entry, 12 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 004cc927
    {load} mov ebp, esp                          # 004cc928
    push ecx                                     # 004cc92a
    mov dword ptr [ebp - local_4], ecx           # 004cc92b
    mov ecx, dword ptr [ebp - local_4]           # 004cc92e
    call FUN_0051d716                            # 004cc931
    mov eax, dword ptr [ebp - local_4]           # 004cc936
    mov dword ptr [eax], 0x52e278                # 004cc939
    mov eax, dword ptr [ebp - local_4]           # 004cc93f
    {load} mov esp, ebp                          # 004cc942
    pop ebp                                      # 004cc944
    ret                                          # 004cc945

