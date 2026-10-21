# FUN_00448820
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448820
# extent:       0x00448820-0x0044883f (31 code bytes)
# span:         0x00448820-0x0044883f (code 31, tables 0, padding 0)
# sha256:       9fedbc7081f929cdf4437b910efbf26b46d4c533f80124b1439c8ab0a0bee7f6
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m448820_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m448820_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cb58u at [this], calls 0x448853(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00448853
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m448820_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00448853, .text + (0x00448853 - 0x401000)

.org 0x00448820 - 0x401000
.globl FUN_00448820
FUN_00448820:
    # block 0x00448820: entry, 12 instruction(s), calls FUN_00448853, ends with ret
    push ebp                                     # 00448820
    {load} mov ebp, esp                          # 00448821
    push ecx                                     # 00448823
    mov dword ptr [ebp - local_4], ecx           # 00448824
    mov eax, dword ptr [ebp - local_4]           # 00448827
    mov dword ptr [eax], 0x52cb58                # 0044882a
    mov ecx, dword ptr [ebp - local_4]           # 00448830
    call FUN_00448853                            # 00448833
    mov eax, dword ptr [ebp - local_4]           # 00448838
    {load} mov esp, ebp                          # 0044883b
    pop ebp                                      # 0044883d
    ret                                          # 0044883e

