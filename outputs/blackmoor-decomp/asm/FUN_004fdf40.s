# FUN_004fdf40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdf40
# extent:       0x004fdf40-0x004fdf77 (55 code bytes)
# span:         0x004fdf40-0x004fdf80 (code 55, tables 0, padding 9)
# sha256:       931ff90a2e8216fec2f8d697a5a34de131cc86bdbf9e3b4111fe2cdd3edfd5a1
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdf40
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_58, field_64, field_68, field_6c, field_70, field_1da, field_242; [esp + n] stk_8
# callees:      calls FUN_004ff310, FUN_004fef10
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_58, 0x58  # offset +0x58
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_1da, 0x1da  # offset +0x1da
.equ field_242, 0x242  # offset +0x242

# --- external targets -----------------------------------------------
.set FUN_004fef10, .text + (0x004fef10 - 0x401000)
.set FUN_004ff310, .text + (0x004ff310 - 0x401000)

.org 0x004fdf40 - 0x401000
.globl FUN_004fdf40
FUN_004fdf40:
    # block 0x004fdf40: entry, 17 instruction(s), calls FUN_004ff310, FUN_004fef10, ends with ret
    push esi                                     # 004fdf40
    mov esi, dword ptr [esp + stk_8]             # 004fdf41
    lea eax, [esi + field_1da]                   # 004fdf45
    push eax                                     # 004fdf4b
    call FUN_004ff310                            # 004fdf4c
    lea ecx, [esi + field_242]                   # 004fdf51
    push ecx                                     # 004fdf57
    call FUN_004fef10                            # 004fdf58
    {load} xor eax, eax                          # 004fdf5d
    add esp, 0x8                                 # 004fdf5f
    mov dword ptr [esi + field_64], eax          # 004fdf62
    mov dword ptr [esi + field_6c], eax          # 004fdf65
    mov dword ptr [esi + field_58], 0x2          # 004fdf68
    mov dword ptr [esi + field_68], eax          # 004fdf6f
    mov dword ptr [esi + field_70], eax          # 004fdf72
    pop esi                                      # 004fdf75
    ret                                          # 004fdf76

# --- data items (not part of the function) -------------------------
.org 0x004fdf77 - 0x401000
PAD_004fdf77:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

