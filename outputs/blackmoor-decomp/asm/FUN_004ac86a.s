# FUN_004ac86a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac86a
# extent:       0x004ac86a-0x004ac8be (84 code bytes)
# span:         0x004ac86a-0x004ac8be (code 84, tables 0, padding 0)
# sha256:       50be48fa25365007110c3da634ed6a9554c0446b9ce86c03b83eb665480b234c
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac86a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4ac86a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52df88u at [this], calls 0x4ac8da(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004ac8da
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4ac86a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004ac8da, .text + (0x004ac8da - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004ac86a - 0x401000
.globl FUN_004ac86a
FUN_004ac86a:
    # block 0x004ac86a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004ac8da, ends with ret
    push ebp                                     # 004ac86a
    {load} mov ebp, esp                          # 004ac86b
    push -0x1                                    # 004ac86d
    push 0x5286bd                                # 004ac86f
    mov eax, dword ptr fs:[0x0]                  # 004ac874
    push eax                                     # 004ac87a
    mov dword ptr fs:[0x0], esp                  # 004ac87b
    push ecx                                     # 004ac882
    mov dword ptr [ebp - local_10], ecx          # 004ac883
    mov ecx, dword ptr [ebp - local_10]          # 004ac886
    call FUN_0051d716                            # 004ac889
    mov dword ptr [ebp - local_4], 0x0           # 004ac88e
    mov eax, dword ptr [ebp - local_10]          # 004ac895
    mov dword ptr [eax], 0x52df88                # 004ac898
    mov ecx, dword ptr [ebp - local_10]          # 004ac89e
    call FUN_004ac8da                            # 004ac8a1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ac8a6
    mov eax, dword ptr [ebp - local_10]          # 004ac8ad
    mov ecx, dword ptr [ebp - local_c]           # 004ac8b0
    mov dword ptr fs:[0x0], ecx                  # 004ac8b3
    {load} mov esp, ebp                          # 004ac8ba
    pop ebp                                      # 004ac8bc
    ret                                          # 004ac8bd

