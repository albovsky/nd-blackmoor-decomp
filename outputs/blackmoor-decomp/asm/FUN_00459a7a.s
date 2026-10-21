# FUN_00459a7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459a7a
# extent:       0x00459a7a-0x00459ace (84 code bytes)
# span:         0x00459a7a-0x00459ace (code 84, tables 0, padding 0)
# sha256:       201486919e9646c6ceaa80fc455e5b3eac60b8e98617e719a5f777eb9ce7b9a9
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m459a7a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m459a7a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52cee8u at [this], calls 0x459aea(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00459aea
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m459a7a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00459aea, .text + (0x00459aea - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00459a7a - 0x401000
.globl FUN_00459a7a
FUN_00459a7a:
    # block 0x00459a7a: entry, 23 instruction(s), calls FUN_0051d716, FUN_00459aea, ends with ret
    push ebp                                     # 00459a7a
    {load} mov ebp, esp                          # 00459a7b
    push -0x1                                    # 00459a7d
    push 0x52809d                                # 00459a7f
    mov eax, dword ptr fs:[0x0]                  # 00459a84
    push eax                                     # 00459a8a
    mov dword ptr fs:[0x0], esp                  # 00459a8b
    push ecx                                     # 00459a92
    mov dword ptr [ebp - local_10], ecx          # 00459a93
    mov ecx, dword ptr [ebp - local_10]          # 00459a96
    call FUN_0051d716                            # 00459a99
    mov dword ptr [ebp - local_4], 0x0           # 00459a9e
    mov eax, dword ptr [ebp - local_10]          # 00459aa5
    mov dword ptr [eax], 0x52cee8                # 00459aa8
    mov ecx, dword ptr [ebp - local_10]          # 00459aae
    call FUN_00459aea                            # 00459ab1
    mov dword ptr [ebp - local_4], 0xffffffff    # 00459ab6
    mov eax, dword ptr [ebp - local_10]          # 00459abd
    mov ecx, dword ptr [ebp - local_c]           # 00459ac0
    mov dword ptr fs:[0x0], ecx                  # 00459ac3
    {load} mov esp, ebp                          # 00459aca
    pop ebp                                      # 00459acc
    ret                                          # 00459acd

