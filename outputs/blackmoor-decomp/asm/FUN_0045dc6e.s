# FUN_0045dc6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dc6e
# extent:       0x0045dc6e-0x0045dc8a (28 code bytes)
# span:         0x0045dc6e-0x0045dc8a (code 28, tables 0, padding 0)
# sha256:       68fdd94a3f71aba21af6831b168e46b159f5b200362d0b2677de9d5319d8aa61
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45dc6e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m45dc6e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cff8u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m45dc6e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0045dc6e - 0x401000
.globl FUN_0045dc6e
FUN_0045dc6e:
    # block 0x0045dc6e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0045dc6e
    {load} mov ebp, esp                          # 0045dc6f
    push ecx                                     # 0045dc71
    mov dword ptr [ebp - local_4], ecx           # 0045dc72
    mov eax, dword ptr [ebp - local_4]           # 0045dc75
    mov dword ptr [eax], 0x52cff8                # 0045dc78
    mov ecx, dword ptr [ebp - local_4]           # 0045dc7e
    call FUN_0051d730                            # 0045dc81
    {load} mov esp, ebp                          # 0045dc86
    pop ebp                                      # 0045dc88
    ret                                          # 0045dc89

