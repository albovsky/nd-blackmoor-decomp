# FUN_004c946b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c946b
# extent:       0x004c946b-0x004c948f (36 code bytes)
# span:         0x004c946b-0x004c948f (code 36, tables 0, padding 0)
# sha256:       c885b7addfd0698e7365495d4d099c2d5a17d55f71aa7690a6c2c76f31140a49
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_surface_cache_slot_release
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:327 says "REQUIRED when a slot was acquired. 0x4c946b(slot)."
# name-note:    Releases an acquired surface cache slot.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_c72
# callees:      calls FUN_004c2dfb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c72, 0xc72  # offset +0xc72

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004c946b - 0x401000
.globl FUN_004c946b
FUN_004c946b:
    # block 0x004c946b: entry, 13 instruction(s), calls FUN_004c2dfb, ends with ret 0x4
    push ebp                                     # 004c946b
    {load} mov ebp, esp                          # 004c946c
    push ecx                                     # 004c946e
    mov dword ptr [ebp - local_4], ecx           # 004c946f
    movsx eax, word ptr [ebp + arg_8]            # 004c9472
    mov ecx, dword ptr [ebp - local_4]           # 004c9476
    lea edx, [ecx + 4*eax + field_c72]           # 004c9479
    push edx                                     # 004c9480
    mov ecx, dword ptr [ebp - local_4]           # 004c9481
    call FUN_004c2dfb                            # 004c9484
    {load} mov esp, ebp                          # 004c9489
    pop ebp                                      # 004c948b
    ret 0x4                                      # 004c948c

