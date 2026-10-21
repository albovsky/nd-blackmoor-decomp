# FUN_00487aaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487aaa
# extent:       0x00487aaa-0x00487afe (84 code bytes)
# span:         0x00487aaa-0x00487afe (code 84, tables 0, padding 0)
# sha256:       bde9d4bcde8cd86630296e8eb17e6a3f263f69c83686a98ffb46979031322d3b
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487aaa_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m487aaa_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d7c8u at [this], calls 0x487b1a(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00487b1a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m487aaa_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00487b1a, .text + (0x00487b1a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00487aaa - 0x401000
.globl FUN_00487aaa
FUN_00487aaa:
    # block 0x00487aaa: entry, 23 instruction(s), calls FUN_0051d716, FUN_00487b1a, ends with ret
    push ebp                                     # 00487aaa
    {load} mov ebp, esp                          # 00487aab
    push -0x1                                    # 00487aad
    push 0x52841d                                # 00487aaf
    mov eax, dword ptr fs:[0x0]                  # 00487ab4
    push eax                                     # 00487aba
    mov dword ptr fs:[0x0], esp                  # 00487abb
    push ecx                                     # 00487ac2
    mov dword ptr [ebp - local_10], ecx          # 00487ac3
    mov ecx, dword ptr [ebp - local_10]          # 00487ac6
    call FUN_0051d716                            # 00487ac9
    mov dword ptr [ebp - local_4], 0x0           # 00487ace
    mov eax, dword ptr [ebp - local_10]          # 00487ad5
    mov dword ptr [eax], 0x52d7c8                # 00487ad8
    mov ecx, dword ptr [ebp - local_10]          # 00487ade
    call FUN_00487b1a                            # 00487ae1
    mov dword ptr [ebp - local_4], 0xffffffff    # 00487ae6
    mov eax, dword ptr [ebp - local_10]          # 00487aed
    mov ecx, dword ptr [ebp - local_c]           # 00487af0
    mov dword ptr fs:[0x0], ecx                  # 00487af3
    {load} mov esp, ebp                          # 00487afa
    pop ebp                                      # 00487afc
    ret                                          # 00487afd

