# FUN_004caed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caed0
# extent:       0x004caed0-0x004caeef (31 code bytes)
# span:         0x004caed0-0x004caeef (code 31, tables 0, padding 0)
# sha256:       d2d4789eff300982b581af529fc0cc02c94ab4875fc75b45825761ec0486758f
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_movie_1c_object_constructor
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_1c_runtime.h:137 says "the state the constructor 0x4caed0 leaves through 0x4caf03"
# name-note:    Constructor of the 0x1c movie object; leaves slot -1 and last index -1 through 0x4caf03.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004caf03
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004caf03, .text + (0x004caf03 - 0x401000)

.org 0x004caed0 - 0x401000
.globl FUN_004caed0
FUN_004caed0:
    # block 0x004caed0: entry, 12 instruction(s), calls FUN_004caf03, ends with ret
    push ebp                                     # 004caed0
    {load} mov ebp, esp                          # 004caed1
    push ecx                                     # 004caed3
    mov dword ptr [ebp - local_4], ecx           # 004caed4
    mov eax, dword ptr [ebp - local_4]           # 004caed7
    mov dword ptr [eax], 0x52e23c                # 004caeda
    mov ecx, dword ptr [ebp - local_4]           # 004caee0
    call FUN_004caf03                            # 004caee3
    mov eax, dword ptr [ebp - local_4]           # 004caee8
    {load} mov esp, ebp                          # 004caeeb
    pop ebp                                      # 004caeed
    ret                                          # 004caeee

