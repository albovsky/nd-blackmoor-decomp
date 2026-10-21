# FUN_00463faa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463faa
# extent:       0x00463faa-0x00463ffe (84 code bytes)
# span:         0x00463faa-0x00463ffe (code 84, tables 0, padding 0)
# sha256:       234df3117437ce275c66123c8287fe3c1d791bb510be4ff3149f5ac1b5b82a71
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463faa_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m463faa_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d108u at [this], calls 0x46402e(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0046402e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m463faa_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0046402e, .text + (0x0046402e - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00463faa - 0x401000
.globl FUN_00463faa
FUN_00463faa:
    # block 0x00463faa: entry, 23 instruction(s), calls FUN_0051d716, FUN_0046402e, ends with ret
    push ebp                                     # 00463faa
    {load} mov ebp, esp                          # 00463fab
    push -0x1                                    # 00463fad
    push 0x52815d                                # 00463faf
    mov eax, dword ptr fs:[0x0]                  # 00463fb4
    push eax                                     # 00463fba
    mov dword ptr fs:[0x0], esp                  # 00463fbb
    push ecx                                     # 00463fc2
    mov dword ptr [ebp - local_10], ecx          # 00463fc3
    mov ecx, dword ptr [ebp - local_10]          # 00463fc6
    call FUN_0051d716                            # 00463fc9
    mov dword ptr [ebp - local_4], 0x0           # 00463fce
    mov eax, dword ptr [ebp - local_10]          # 00463fd5
    mov dword ptr [eax], 0x52d108                # 00463fd8
    mov ecx, dword ptr [ebp - local_10]          # 00463fde
    call FUN_0046402e                            # 00463fe1
    mov dword ptr [ebp - local_4], 0xffffffff    # 00463fe6
    mov eax, dword ptr [ebp - local_10]          # 00463fed
    mov ecx, dword ptr [ebp - local_c]           # 00463ff0
    mov dword ptr fs:[0x0], ecx                  # 00463ff3
    {load} mov esp, ebp                          # 00463ffa
    pop ebp                                      # 00463ffc
    ret                                          # 00463ffd

