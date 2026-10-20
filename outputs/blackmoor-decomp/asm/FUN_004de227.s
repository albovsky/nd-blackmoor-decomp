# FUN_004de227
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de227
# extent:       0x004de227-0x004de24f (40 code bytes)
# span:         0x004de227-0x004de24f (code 40, tables 0, padding 0)
# sha256:       5762ec1cb15540539f9c8aabe51330559737b21f41d966ed19c2aee439dd6d9c
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_caption_text_box_init
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.h:246 says "0x4de227: 0x4edcb1(+0x691, 1) then 0x4ee6c7(0)."
# name-note:    Init of the caption text box at boot: 0x4edcb1(+0x691, 1) then 0x4ee6c7(0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edcb1, FUN_004ee6c7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004edcb1, .text + (0x004edcb1 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)

.org 0x004de227 - 0x401000
.globl FUN_004de227
FUN_004de227:
    # block 0x004de227: entry, 16 instruction(s), calls FUN_004edcb1, FUN_004ee6c7, ends with ret
    push ebp                                     # 004de227
    {load} mov ebp, esp                          # 004de228
    push ecx                                     # 004de22a
    mov dword ptr [ebp - local_4], ecx           # 004de22b
    push 0x1                                     # 004de22e
    mov eax, dword ptr [ebp - local_4]           # 004de230
    add eax, 0x691                               # 004de233
    push eax                                     # 004de238
    mov ecx, dword ptr [ebp - local_4]           # 004de239
    call FUN_004edcb1                            # 004de23c
    push 0x0                                     # 004de241
    mov ecx, dword ptr [ebp - local_4]           # 004de243
    call FUN_004ee6c7                            # 004de246
    {load} mov esp, ebp                          # 004de24b
    pop ebp                                      # 004de24d
    ret                                          # 004de24e

