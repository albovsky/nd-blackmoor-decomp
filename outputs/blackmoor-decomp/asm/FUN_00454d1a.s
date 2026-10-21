# FUN_00454d1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d1a
# extent:       0x00454d1a-0x00454d6e (84 code bytes)
# span:         0x00454d1a-0x00454d6e (code 84, tables 0, padding 0)
# sha256:       e268cba815014d2075b9cbdc47c1ad8d02fc64079fe52d9187ca4a00812d6de6
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454d1a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m454d1a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52cd50u at [this], calls 0x454d9e(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00454d9e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m454d1a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00454d9e, .text + (0x00454d9e - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00454d1a - 0x401000
.globl FUN_00454d1a
FUN_00454d1a:
    # block 0x00454d1a: entry, 23 instruction(s), calls FUN_0051d716, FUN_00454d9e, ends with ret
    push ebp                                     # 00454d1a
    {load} mov ebp, esp                          # 00454d1b
    push -0x1                                    # 00454d1d
    push 0x52800d                                # 00454d1f
    mov eax, dword ptr fs:[0x0]                  # 00454d24
    push eax                                     # 00454d2a
    mov dword ptr fs:[0x0], esp                  # 00454d2b
    push ecx                                     # 00454d32
    mov dword ptr [ebp - local_10], ecx          # 00454d33
    mov ecx, dword ptr [ebp - local_10]          # 00454d36
    call FUN_0051d716                            # 00454d39
    mov dword ptr [ebp - local_4], 0x0           # 00454d3e
    mov eax, dword ptr [ebp - local_10]          # 00454d45
    mov dword ptr [eax], 0x52cd50                # 00454d48
    mov ecx, dword ptr [ebp - local_10]          # 00454d4e
    call FUN_00454d9e                            # 00454d51
    mov dword ptr [ebp - local_4], 0xffffffff    # 00454d56
    mov eax, dword ptr [ebp - local_10]          # 00454d5d
    mov ecx, dword ptr [ebp - local_c]           # 00454d60
    mov dword ptr fs:[0x0], ecx                  # 00454d63
    {load} mov esp, ebp                          # 00454d6a
    pop ebp                                      # 00454d6c
    ret                                          # 00454d6d

