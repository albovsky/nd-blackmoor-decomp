# FUN_004e053f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e053f
# extent:       0x004e053f-0x004e0559 (26 code bytes)
# span:         0x004e053f-0x004e0559 (code 26, tables 0, padding 0)
# sha256:       393452f0d3f0d5c0efdb0ac1a9f069a1c63aa93bdda1a7a03fd355d1e3c96d9c
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_mode_setter
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.c:872 says "taskbar_mode = 2; / * 0x4e053f(2) * /"; src/caption_lifecycle.c:884 says "taskbar_mode = 1; / * 0x4e053f(1) * /"
# name-note:    Sets the task bar mode (called with 1 or 2 when the text box closes or opens).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_f2a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_f2a, 0xf2a  # offset +0xf2a

# --- external targets -----------------------------------------------

.org 0x004e053f - 0x401000
.globl FUN_004e053f
FUN_004e053f:
    # block 0x004e053f: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004e053f
    {load} mov ebp, esp                          # 004e0540
    push ecx                                     # 004e0542
    mov dword ptr [ebp - local_4], ecx           # 004e0543
    movsx eax, word ptr [ebp + arg_8]            # 004e0546
    mov ecx, dword ptr [ebp - local_4]           # 004e054a
    mov dword ptr [ecx + field_f2a], eax         # 004e054d
    {load} mov esp, ebp                          # 004e0553
    pop ebp                                      # 004e0555
    ret 0x4                                      # 004e0556

