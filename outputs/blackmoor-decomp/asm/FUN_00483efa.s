# FUN_00483efa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483efa
# extent:       0x00483efa-0x00483f4e (84 code bytes)
# span:         0x00483efa-0x00483f4e (code 84, tables 0, padding 0)
# sha256:       426e08d791137fd266cf76668856f5200f6741b804e6c835eff24c55618e5181
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m483efa_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m483efa_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d740u at [this], calls 0x483f6a(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00483f6a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m483efa_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00483f6a, .text + (0x00483f6a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00483efa - 0x401000
.globl FUN_00483efa
FUN_00483efa:
    # block 0x00483efa: entry, 23 instruction(s), calls FUN_0051d716, FUN_00483f6a, ends with ret
    push ebp                                     # 00483efa
    {load} mov ebp, esp                          # 00483efb
    push -0x1                                    # 00483efd
    push 0x5283ed                                # 00483eff
    mov eax, dword ptr fs:[0x0]                  # 00483f04
    push eax                                     # 00483f0a
    mov dword ptr fs:[0x0], esp                  # 00483f0b
    push ecx                                     # 00483f12
    mov dword ptr [ebp - local_10], ecx          # 00483f13
    mov ecx, dword ptr [ebp - local_10]          # 00483f16
    call FUN_0051d716                            # 00483f19
    mov dword ptr [ebp - local_4], 0x0           # 00483f1e
    mov eax, dword ptr [ebp - local_10]          # 00483f25
    mov dword ptr [eax], 0x52d740                # 00483f28
    mov ecx, dword ptr [ebp - local_10]          # 00483f2e
    call FUN_00483f6a                            # 00483f31
    mov dword ptr [ebp - local_4], 0xffffffff    # 00483f36
    mov eax, dword ptr [ebp - local_10]          # 00483f3d
    mov ecx, dword ptr [ebp - local_c]           # 00483f40
    mov dword ptr fs:[0x0], ecx                  # 00483f43
    {load} mov esp, ebp                          # 00483f4a
    pop ebp                                      # 00483f4c
    ret                                          # 00483f4d

