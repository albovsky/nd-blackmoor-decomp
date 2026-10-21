# FUN_0048a69a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a69a
# extent:       0x0048a69a-0x0048a6ee (84 code bytes)
# span:         0x0048a69a-0x0048a6ee (code 84, tables 0, padding 0)
# sha256:       657dcc8a368bb411e92f5a801fa2278a3d9ebd3c99e4f522f229b73ce10ce12b
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a69a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m48a69a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d8d8u at [this], calls 0x48a70a(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0048a70a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m48a69a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048a70a, .text + (0x0048a70a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0048a69a - 0x401000
.globl FUN_0048a69a
FUN_0048a69a:
    # block 0x0048a69a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0048a70a, ends with ret
    push ebp                                     # 0048a69a
    {load} mov ebp, esp                          # 0048a69b
    push -0x1                                    # 0048a69d
    push 0x52846d                                # 0048a69f
    mov eax, dword ptr fs:[0x0]                  # 0048a6a4
    push eax                                     # 0048a6aa
    mov dword ptr fs:[0x0], esp                  # 0048a6ab
    push ecx                                     # 0048a6b2
    mov dword ptr [ebp - local_10], ecx          # 0048a6b3
    mov ecx, dword ptr [ebp - local_10]          # 0048a6b6
    call FUN_0051d716                            # 0048a6b9
    mov dword ptr [ebp - local_4], 0x0           # 0048a6be
    mov eax, dword ptr [ebp - local_10]          # 0048a6c5
    mov dword ptr [eax], 0x52d8d8                # 0048a6c8
    mov ecx, dword ptr [ebp - local_10]          # 0048a6ce
    call FUN_0048a70a                            # 0048a6d1
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048a6d6
    mov eax, dword ptr [ebp - local_10]          # 0048a6dd
    mov ecx, dword ptr [ebp - local_c]           # 0048a6e0
    mov dword ptr fs:[0x0], ecx                  # 0048a6e3
    {load} mov esp, ebp                          # 0048a6ea
    pop ebp                                      # 0048a6ec
    ret                                          # 0048a6ed

