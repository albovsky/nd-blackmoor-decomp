# FUN_004e2940
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2940
# extent:       0x004e2940-0x004e2956 (22 code bytes)
# span:         0x004e2940-0x004e2956 (code 22, tables 0, padding 0)
# sha256:       a9959efb0c428ec19993476bcaa0675da92eb9d5eeeb64a3dd6fd6ca22fc211d
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_button_state_setter
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.c:75 says "0x4e2940: unconditional store of the state."
# name-note:    Unconditional store of a task bar button state.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_30
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x004e2940 - 0x401000
.globl FUN_004e2940
FUN_004e2940:
    # block 0x004e2940: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004e2940
    {load} mov ebp, esp                          # 004e2941
    push ecx                                     # 004e2943
    mov dword ptr [ebp - local_4], ecx           # 004e2944
    mov eax, dword ptr [ebp - local_4]           # 004e2947
    mov ecx, dword ptr [ebp + arg_8]             # 004e294a
    mov dword ptr [eax + field_30], ecx          # 004e294d
    {load} mov esp, ebp                          # 004e2950
    pop ebp                                      # 004e2952
    ret 0x4                                      # 004e2953

