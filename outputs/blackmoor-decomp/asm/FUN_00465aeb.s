# FUN_00465aeb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465aeb
# extent:       0x00465aeb-0x00465b07 (28 code bytes)
# span:         0x00465aeb-0x00465b07 (code 28, tables 0, padding 0)
# sha256:       d11e62caf26994735cb4f86b499d196056d0182f0187b7ee90c1fc88bdab326d
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465aeb_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m465aeb_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d190u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m465aeb_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00465aeb - 0x401000
.globl FUN_00465aeb
FUN_00465aeb:
    # block 0x00465aeb: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00465aeb
    {load} mov ebp, esp                          # 00465aec
    push ecx                                     # 00465aee
    mov dword ptr [ebp - local_4], ecx           # 00465aef
    mov eax, dword ptr [ebp - local_4]           # 00465af2
    mov dword ptr [eax], 0x52d190                # 00465af5
    mov ecx, dword ptr [ebp - local_4]           # 00465afb
    call FUN_0051d730                            # 00465afe
    {load} mov esp, ebp                          # 00465b03
    pop ebp                                      # 00465b05
    ret                                          # 00465b06

