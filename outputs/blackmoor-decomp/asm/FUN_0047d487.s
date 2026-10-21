# FUN_0047d487
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d487
# extent:       0x0047d487-0x0047d4db (84 code bytes)
# span:         0x0047d487-0x0047d4db (code 84, tables 0, padding 0)
# sha256:       1f1aaa6a1798f38e98de92fc1c5d6ffa1e8dc0c013520d65278ca70444dbaa73
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d487_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m47d487_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d5a8u at [this], calls 0x47d4f7(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0047d4f7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m47d487_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0047d4f7, .text + (0x0047d4f7 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0047d487 - 0x401000
.globl FUN_0047d487
FUN_0047d487:
    # block 0x0047d487: entry, 23 instruction(s), calls FUN_0051d716, FUN_0047d4f7, ends with ret
    push ebp                                     # 0047d487
    {load} mov ebp, esp                          # 0047d488
    push -0x1                                    # 0047d48a
    push 0x52833d                                # 0047d48c
    mov eax, dword ptr fs:[0x0]                  # 0047d491
    push eax                                     # 0047d497
    mov dword ptr fs:[0x0], esp                  # 0047d498
    push ecx                                     # 0047d49f
    mov dword ptr [ebp - local_10], ecx          # 0047d4a0
    mov ecx, dword ptr [ebp - local_10]          # 0047d4a3
    call FUN_0051d716                            # 0047d4a6
    mov dword ptr [ebp - local_4], 0x0           # 0047d4ab
    mov eax, dword ptr [ebp - local_10]          # 0047d4b2
    mov dword ptr [eax], 0x52d5a8                # 0047d4b5
    mov ecx, dword ptr [ebp - local_10]          # 0047d4bb
    call FUN_0047d4f7                            # 0047d4be
    mov dword ptr [ebp - local_4], 0xffffffff    # 0047d4c3
    mov eax, dword ptr [ebp - local_10]          # 0047d4ca
    mov ecx, dword ptr [ebp - local_c]           # 0047d4cd
    mov dword ptr fs:[0x0], ecx                  # 0047d4d0
    {load} mov esp, ebp                          # 0047d4d7
    pop ebp                                      # 0047d4d9
    ret                                          # 0047d4da

