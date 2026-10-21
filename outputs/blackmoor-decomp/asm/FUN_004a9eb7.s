# FUN_004a9eb7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9eb7
# extent:       0x004a9eb7-0x004a9f0b (84 code bytes)
# span:         0x004a9eb7-0x004a9f0b (code 84, tables 0, padding 0)
# sha256:       a025bcd538aca0823bb437b7d2c9379e90890227edcce9ddcc107e4530f867b3
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9eb7_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4a9eb7_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52de78u at [this], calls 0x4a9f27(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004a9f27
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4a9eb7_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a9f27, .text + (0x004a9f27 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004a9eb7 - 0x401000
.globl FUN_004a9eb7
FUN_004a9eb7:
    # block 0x004a9eb7: entry, 23 instruction(s), calls FUN_0051d716, FUN_004a9f27, ends with ret
    push ebp                                     # 004a9eb7
    {load} mov ebp, esp                          # 004a9eb8
    push -0x1                                    # 004a9eba
    push 0x52865d                                # 004a9ebc
    mov eax, dword ptr fs:[0x0]                  # 004a9ec1
    push eax                                     # 004a9ec7
    mov dword ptr fs:[0x0], esp                  # 004a9ec8
    push ecx                                     # 004a9ecf
    mov dword ptr [ebp - local_10], ecx          # 004a9ed0
    mov ecx, dword ptr [ebp - local_10]          # 004a9ed3
    call FUN_0051d716                            # 004a9ed6
    mov dword ptr [ebp - local_4], 0x0           # 004a9edb
    mov eax, dword ptr [ebp - local_10]          # 004a9ee2
    mov dword ptr [eax], 0x52de78                # 004a9ee5
    mov ecx, dword ptr [ebp - local_10]          # 004a9eeb
    call FUN_004a9f27                            # 004a9eee
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a9ef3
    mov eax, dword ptr [ebp - local_10]          # 004a9efa
    mov ecx, dword ptr [ebp - local_c]           # 004a9efd
    mov dword ptr fs:[0x0], ecx                  # 004a9f00
    {load} mov esp, ebp                          # 004a9f07
    pop ebp                                      # 004a9f09
    ret                                          # 004a9f0a

