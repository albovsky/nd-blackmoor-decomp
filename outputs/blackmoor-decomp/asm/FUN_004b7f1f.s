# FUN_004b7f1f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7f1f
# extent:       0x004b7f1f-0x004b7f3b (28 code bytes)
# span:         0x004b7f1f-0x004b7f3b (code 28, tables 0, padding 0)
# sha256:       4d3e1b0e291bff9093dd856aa0d2c3629c2be7ac61066ea9528511ff1f8e3439
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7f1f_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4b7f1f_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e1f8u at [this], returns 0x4b7ff4(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b7ff4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4b7f1f_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004b7ff4, .text + (0x004b7ff4 - 0x401000)

.org 0x004b7f1f - 0x401000
.globl FUN_004b7f1f
FUN_004b7f1f:
    # block 0x004b7f1f: entry, 11 instruction(s), calls FUN_004b7ff4, ends with ret
    push ebp                                     # 004b7f1f
    {load} mov ebp, esp                          # 004b7f20
    push ecx                                     # 004b7f22
    mov dword ptr [ebp - local_4], ecx           # 004b7f23
    mov eax, dword ptr [ebp - local_4]           # 004b7f26
    mov dword ptr [eax], 0x52e1f8                # 004b7f29
    mov ecx, dword ptr [ebp - local_4]           # 004b7f2f
    call FUN_004b7ff4                            # 004b7f32
    {load} mov esp, ebp                          # 004b7f37
    pop ebp                                      # 004b7f39
    ret                                          # 004b7f3a

