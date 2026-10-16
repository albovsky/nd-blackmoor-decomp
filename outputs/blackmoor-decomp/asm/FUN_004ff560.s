# FUN_004ff560
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff560
# extent:       0x004ff560-0x004ff58b (43 code bytes)
# span:         0x004ff560-0x004ff590 (code 43, tables 0, padding 5)
# sha256:       565f1003f06a17fcdbefec48ebad80dccdc026457a87bb9f231e56797e84b152
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ff560
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_18, field_34, field_38, field_3c, field_40; [esp + n] stk_8
# callees:      calls FUN_004fef70
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------
.set FUN_004fef70, .text + (0x004fef70 - 0x401000)

.org 0x004ff560 - 0x401000
.globl FUN_004ff560
FUN_004ff560:
    # block 0x004ff560: entry, 17 instruction(s), calls FUN_004fef70, ends with ret
    mov eax, dword ptr [esp + stk_8]             # 004ff560
    push esi                                     # 004ff564
    mov esi, dword ptr [esp + stk_8]             # 004ff565
    push 0x0                                     # 004ff569
    push eax                                     # 004ff56b
    push esi                                     # 004ff56c
    call FUN_004fef70                            # 004ff56d
    or eax, -0x1                                 # 004ff572
    add esp, 0xc                                 # 004ff575
    mov dword ptr [esi + field_34], eax          # 004ff578
    mov dword ptr [esi + field_3c], eax          # 004ff57b
    mov dword ptr [esi + field_18], eax          # 004ff57e
    mov dword ptr [esi + field_38], eax          # 004ff581
    mov dword ptr [esi + field_40], eax          # 004ff584
    {load} xor eax, eax                          # 004ff587
    pop esi                                      # 004ff589
    ret                                          # 004ff58a

# --- data items (not part of the function) -------------------------
.org 0x004ff58b - 0x401000
PAD_004ff58b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

