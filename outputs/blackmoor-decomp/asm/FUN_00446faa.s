# FUN_00446faa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446faa
# extent:       0x00446faa-0x00446ffb (81 code bytes)
# span:         0x00446faa-0x00446ffb (code 81, tables 0, padding 0)
# sha256:       386e8b2e62c380c168fb2cfb6fc4227589098b41451ea0fd9570fb748d4efe60
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m446faa_lifted
# naming:       native port src/original_methods_fl40.c:m446faa_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 22/22 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447166, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m446faa_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00447166, .text + (0x00447166 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00446faa - 0x401000
.globl FUN_00446faa
FUN_00446faa:
    # block 0x00446faa: entry, 22 instruction(s), calls FUN_00447166, FUN_0051d730, ends with ret
    push ebp                                     # 00446faa
    {load} mov ebp, esp                          # 00446fab
    push -0x1                                    # 00446fad
    push 0x527edd                                # 00446faf
    mov eax, dword ptr fs:[0x0]                  # 00446fb4
    push eax                                     # 00446fba
    mov dword ptr fs:[0x0], esp                  # 00446fbb
    push ecx                                     # 00446fc2
    mov dword ptr [ebp - local_10], ecx          # 00446fc3
    mov eax, dword ptr [ebp - local_10]          # 00446fc6
    mov dword ptr [eax], 0x52ca58                # 00446fc9
    mov dword ptr [ebp - local_4], 0x0           # 00446fcf
    mov ecx, dword ptr [ebp - local_10]          # 00446fd6
    call FUN_00447166                            # 00446fd9
    mov dword ptr [ebp - local_4], 0xffffffff    # 00446fde
    mov ecx, dword ptr [ebp - local_10]          # 00446fe5
    call FUN_0051d730                            # 00446fe8
    mov ecx, dword ptr [ebp - local_c]           # 00446fed
    mov dword ptr fs:[0x0], ecx                  # 00446ff0
    {load} mov esp, ebp                          # 00446ff7
    pop ebp                                      # 00446ff9
    ret                                          # 00446ffa

