# FUN_004de2d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de2d8
# extent:       0x004de2d8-0x004de322 (74 code bytes)
# span:         0x004de2d8-0x004de322 (code 74, tables 0, padding 0)
# sha256:       67a06f4f718125de269a25794f8a757c4ae0e530c34ffc851d57ff9f0cf3c0fb
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de2d8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991
# callees:      calls FUN_004e053f, FUN_004e1113, FUN_004de214
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.h:caption_ctb_close (function ledger class candidate_port; also caption_scene_reset; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004de214, .text + (0x004de214 - 0x401000)
.set FUN_004e053f, .text + (0x004e053f - 0x401000)
.set FUN_004e1113, .text + (0x004e1113 - 0x401000)

.org 0x004de2d8 - 0x401000
.globl FUN_004de2d8
FUN_004de2d8:
    # block 0x004de2d8: entry, 18 instruction(s), calls FUN_004e053f, FUN_004e1113, FUN_004de214, ends with ret
    push ebp                                     # 004de2d8
    {load} mov ebp, esp                          # 004de2d9
    push ecx                                     # 004de2db
    mov dword ptr [ebp - local_4], ecx           # 004de2dc
    mov eax, dword ptr [ebp - local_4]           # 004de2df
    mov dword ptr [eax + field_991], 0x1         # 004de2e2
    push 0x1                                     # 004de2ec
    mov ecx, 0x570508                            # 004de2ee
    call FUN_004e053f                            # 004de2f3
    mov ecx, 0x570508                            # 004de2f8
    call FUN_004e1113                            # 004de2fd
    mov dword ptr [0x5b15d6], 0x0                # 004de302
    mov dword ptr [0x5d17f5], 0x0                # 004de30c
    mov ecx, dword ptr [ebp - local_4]           # 004de316
    call FUN_004de214                            # 004de319
    {load} mov esp, ebp                          # 004de31e
    pop ebp                                      # 004de320
    ret                                          # 004de321

