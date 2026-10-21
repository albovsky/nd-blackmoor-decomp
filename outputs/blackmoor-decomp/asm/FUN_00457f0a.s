# FUN_00457f0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457f0a
# extent:       0x00457f0a-0x00457f5e (84 code bytes)
# span:         0x00457f0a-0x00457f5e (code 84, tables 0, padding 0)
# sha256:       b579eb78511a9081eaa1e407233f7b6d910f2a05f639acdd698f7c94f845fd49
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457f0a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m457f0a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52ce60u at [this], calls 0x457f7a(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00457f7a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m457f0a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00457f7a, .text + (0x00457f7a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00457f0a - 0x401000
.globl FUN_00457f0a
FUN_00457f0a:
    # block 0x00457f0a: entry, 23 instruction(s), calls FUN_0051d716, FUN_00457f7a, ends with ret
    push ebp                                     # 00457f0a
    {load} mov ebp, esp                          # 00457f0b
    push -0x1                                    # 00457f0d
    push 0x52806d                                # 00457f0f
    mov eax, dword ptr fs:[0x0]                  # 00457f14
    push eax                                     # 00457f1a
    mov dword ptr fs:[0x0], esp                  # 00457f1b
    push ecx                                     # 00457f22
    mov dword ptr [ebp - local_10], ecx          # 00457f23
    mov ecx, dword ptr [ebp - local_10]          # 00457f26
    call FUN_0051d716                            # 00457f29
    mov dword ptr [ebp - local_4], 0x0           # 00457f2e
    mov eax, dword ptr [ebp - local_10]          # 00457f35
    mov dword ptr [eax], 0x52ce60                # 00457f38
    mov ecx, dword ptr [ebp - local_10]          # 00457f3e
    call FUN_00457f7a                            # 00457f41
    mov dword ptr [ebp - local_4], 0xffffffff    # 00457f46
    mov eax, dword ptr [ebp - local_10]          # 00457f4d
    mov ecx, dword ptr [ebp - local_c]           # 00457f50
    mov dword ptr fs:[0x0], ecx                  # 00457f53
    {load} mov esp, ebp                          # 00457f5a
    pop ebp                                      # 00457f5c
    ret                                          # 00457f5d

