# FUN_0047b200
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b200
# extent:       0x0047b200-0x0047b21f (31 code bytes)
# span:         0x0047b200-0x0047b21f (code 31, tables 0, padding 0)
# sha256:       afff28070eb76b395ab88292f4f2964cb884aa1171a1aa0a8cd8ea9364e7027d
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47b200_construct
# naming:       native port src/original_methods_fl31a.c:m47b200_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Constructor: stores the table pointer 0x52d568 into the object, calls 0x47b23b with ecx = this and returns this; every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047b23b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31a.c:m47b200_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0047b23b, .text + (0x0047b23b - 0x401000)

.org 0x0047b200 - 0x401000
.globl FUN_0047b200
FUN_0047b200:
    # block 0x0047b200: entry, 12 instruction(s), calls FUN_0047b23b, ends with ret
    push ebp                                     # 0047b200
    {load} mov ebp, esp                          # 0047b201
    push ecx                                     # 0047b203
    mov dword ptr [ebp - local_4], ecx           # 0047b204
    mov eax, dword ptr [ebp - local_4]           # 0047b207
    mov dword ptr [eax], 0x52d568                # 0047b20a
    mov ecx, dword ptr [ebp - local_4]           # 0047b210
    call FUN_0047b23b                            # 0047b213
    mov eax, dword ptr [ebp - local_4]           # 0047b218
    {load} mov esp, ebp                          # 0047b21b
    pop ebp                                      # 0047b21d
    ret                                          # 0047b21e

