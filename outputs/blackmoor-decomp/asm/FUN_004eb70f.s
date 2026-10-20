# FUN_004eb70f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb70f
# extent:       0x004eb70f-0x004eb77d (110 code bytes)
# span:         0x004eb70f-0x004eb77d (code 110, tables 0, padding 0)
# sha256:       d86463bff0ef936e8280f6fe2915253b072e6b3f063733a8849a233d6c4e24f5
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         scene_restore_slot_save
# naming:       native port src/action_family_7d_runtime.c:scene_restore_slot_save (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with scene_restore_slot_save (five word stores, low word of the stack argument, dwords at +0x5c3a25/+0x5c3a29; the 0x5bb5ab store is overwritten by 0x5bb5af). Record and globals are struct parameters; NULL args ignored (native-only).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_7d_runtime.c:scene_restore_slot_save (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004eb70f - 0x401000
.globl FUN_004eb70f
FUN_004eb70f:
    # block 0x004eb70f: entry, 23 instruction(s), ends with ret 0x4
    push ebp                                     # 004eb70f
    {load} mov ebp, esp                          # 004eb710
    push ecx                                     # 004eb712
    mov dword ptr [ebp - local_4], ecx           # 004eb713
    mov ax, word ptr [0x5bb57b]                  # 004eb716
    mov word ptr [0x5c3a1b], ax                  # 004eb71c
    mov cx, word ptr [0x5bb57f]                  # 004eb722
    mov word ptr [0x5c3a1d], cx                  # 004eb729
    mov dx, word ptr [0x5bb50b]                  # 004eb730
    mov word ptr [0x5c3a1f], dx                  # 004eb737
    mov ax, word ptr [0x5bb593]                  # 004eb73e
    mov word ptr [0x5c3a21], ax                  # 004eb744
    mov cx, word ptr [ebp + arg_8]               # 004eb74a
    mov word ptr [0x5c3a23], cx                  # 004eb74e
    mov edx, dword ptr [0x5bb5a7]                # 004eb755
    mov dword ptr [0x5c3a25], edx                # 004eb75b
    mov eax, dword ptr [0x5bb5ab]                # 004eb761
    mov dword ptr [0x5c3a29], eax                # 004eb766
    mov ecx, dword ptr [0x5bb5af]                # 004eb76b
    mov dword ptr [0x5c3a29], ecx                # 004eb771
    {load} mov esp, ebp                          # 004eb777
    pop ebp                                      # 004eb779
    ret 0x4                                      # 004eb77a

