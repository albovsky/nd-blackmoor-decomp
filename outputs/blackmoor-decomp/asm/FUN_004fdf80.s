# FUN_004fdf80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdf80
# extent:       0x004fdf80-0x004fdfce (78 code bytes)
# span:         0x004fdf80-0x004fdfd0 (code 78, tables 0, padding 2)
# sha256:       22c52bfc8f34d5587d807ffbc26c50a38523ee02d68356d9ce73ef7b474fae47
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdf80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_48, field_58, field_60, field_1da, field_242; [esp + n] stk_8
# callees:      calls FUN_004ff560, FUN_004fede0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60
.equ field_1da, 0x1da  # offset +0x1da
.equ field_242, 0x242  # offset +0x242

# --- external targets -----------------------------------------------
.set FUN_004fede0, .text + (0x004fede0 - 0x401000)
.set FUN_004ff560, .text + (0x004ff560 - 0x401000)

.org 0x004fdf80 - 0x401000
.globl FUN_004fdf80
FUN_004fdf80:
    # block 0x004fdf80: entry, 4 instruction(s), ends with jne to 0x004fdfcc (forward)
    push esi                                     # 004fdf80
    mov esi, dword ptr [esp + stk_8]             # 004fdf81
    cmp dword ptr [esi + field_58], 0x3          # 004fdf85
    jne.d8 L_004fdfcc                            # 004fdf89
    # block 0x004fdf8b: entered by fall-through of jne at 0x004fdf89, 5 instruction(s), ends with je to 0x004fdfa7 (forward)
    mov eax, dword ptr [esi + field_4]           # 004fdf8b
    push edi                                     # 004fdf8e
    test eax, eax                                # 004fdf8f
    lea edi, [esi + field_1da]                   # 004fdf91
    je.d8 L_004fdfa7                             # 004fdf97
    # block 0x004fdf99: entered by fall-through of je at 0x004fdf97, 6 instruction(s), ends with forward jump to 0x004fdfab
    mov eax, dword ptr [esi + field_60]          # 004fdf99
    mov ecx, dword ptr [esi + field_48]          # 004fdf9c
    shl eax, 0x5                                 # 004fdf9f
    {load} add eax, ecx                          # 004fdfa2
    push eax                                     # 004fdfa4
    jmp.d8 L_004fdfab                            # 004fdfa5
L_004fdfa7:
    # block 0x004fdfa7: entered by je at 0x004fdf97, 2 instruction(s), falls into the block at 0x004fdfab
    mov ecx, dword ptr [esi + field_48]          # 004fdfa7
    push ecx                                     # 004fdfaa
L_004fdfab:
    # block 0x004fdfab: entered by jmp at 0x004fdfa5, 10 instruction(s), calls FUN_004ff560, FUN_004fede0, falls into the block at 0x004fdfcc
    push edi                                     # 004fdfab
    call FUN_004ff560                            # 004fdfac
    add esp, 0x8                                 # 004fdfb1
    lea edx, [esi + field_242]                   # 004fdfb4
    push edx                                     # 004fdfba
    push edi                                     # 004fdfbb
    call FUN_004fede0                            # 004fdfbc
    add esp, 0x8                                 # 004fdfc1
    mov dword ptr [esi + field_58], 0x4          # 004fdfc4
    pop edi                                      # 004fdfcb
L_004fdfcc:
    # block 0x004fdfcc: entered by jne at 0x004fdf89, 2 instruction(s), ends with ret
    pop esi                                      # 004fdfcc
    ret                                          # 004fdfcd

# --- data items (not part of the function) -------------------------
.org 0x004fdfce - 0x401000
PAD_004fdfce:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

