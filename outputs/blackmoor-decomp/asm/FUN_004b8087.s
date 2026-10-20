# FUN_004b8087
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8087
# extent:       0x004b8087-0x004b80a5 (30 code bytes)
# span:         0x004b8087-0x004b80a5 (code 30, tables 0, padding 0)
# sha256:       a5c698aba2ff340807de48713b306002ca6d50098787de97d12fb076d9d46a0e
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         tqz_world_new_game
# naming:       native port src/action_family_f5_runtime.c:tqz_world_new_game (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with tqz_world_new_game (dword [0x5a4c0a] := 0, word [0x5a4c0e] := 0; widths read from the disassembly). The two process cells are fields of a TqzWorld parameter instead of absolute addresses.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:tqz_world_new_game (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004b8087 - 0x401000
.globl FUN_004b8087
FUN_004b8087:
    # block 0x004b8087: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004b8087
    {load} mov ebp, esp                          # 004b8088
    push ecx                                     # 004b808a
    mov dword ptr [ebp - local_4], ecx           # 004b808b
    mov dword ptr [0x5a4c0a], 0x0                # 004b808e
    mov word ptr [0x5a4c0e], 0x0                 # 004b8098
    {load} mov esp, ebp                          # 004b80a1
    pop ebp                                      # 004b80a3
    ret                                          # 004b80a4

