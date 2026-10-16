# FUN_00503ba0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503ba0
# extent:       0x00503ba0-0x00503bfd (93 code bytes)
# span:         0x00503ba0-0x00503c00 (code 93, tables 0, padding 3)
# sha256:       880b9eabca6bd3c8cfdd1b5bcffe82f71e5e60438baa199e41f643435e30bb83
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503ba0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_10, field_24, field_30, field_98, field_a0; [esp + n] stk_10
# callees:      calls FUN_00505580, FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_24, 0x24  # offset +0x24
.equ field_30, 0x30  # offset +0x30
.equ field_98, 0x98  # offset +0x98
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_00505580, .text + (0x00505580 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00503ba0 - 0x401000
.globl FUN_00503ba0
FUN_00503ba0:
    # block 0x00503ba0: entry, 10 instruction(s), calls FUN_00505580, falls into the block at 0x00503bbb
    push ebx                                     # 00503ba0
    push esi                                     # 00503ba1
    push edi                                     # 00503ba2
    mov edi, dword ptr [esp + stk_10]            # 00503ba3
    lea eax, [edi + field_10]                    # 00503ba7
    push eax                                     # 00503baa
    call FUN_00505580                            # 00503bab
    add esp, 0x4                                 # 00503bb0
    lea esi, [edi + field_30]                    # 00503bb3
    mov ebx, 0x7                                 # 00503bb6
L_00503bbb:
    # block 0x00503bbb: entered by jne at 0x00503bca, 7 instruction(s), calls FUN_0050e936, ends with jne to 0x00503bbb (backward)
    mov ecx, dword ptr [esi]                     # 00503bbb
    push ecx                                     # 00503bbd
    call FUN_0050e936                            # 00503bbe
    add esp, 0x4                                 # 00503bc3
    add esi, 0x10                                # 00503bc6
    dec ebx                                      # 00503bc9
    jne.d8 L_00503bbb                            # 00503bca
    # block 0x00503bcc: entered by fall-through of jne at 0x00503bca, 17 instruction(s), calls FUN_0050e936, ends with ret
    mov edx, dword ptr [edi + field_24]          # 00503bcc
    push edx                                     # 00503bcf
    call FUN_0050e936                            # 00503bd0
    mov eax, dword ptr [edi + field_98]          # 00503bd5
    push eax                                     # 00503bdb
    call FUN_0050e936                            # 00503bdc
    mov ecx, dword ptr [edi + field_a0]          # 00503be1
    push ecx                                     # 00503be7
    call FUN_0050e936                            # 00503be8
    mov ecx, 0x2d                                # 00503bed
    {load} xor eax, eax                          # 00503bf2
    add esp, 0xc                                 # 00503bf4
    rep stosd dword ptr es:[edi], eax            # 00503bf7
    pop edi                                      # 00503bf9
    pop esi                                      # 00503bfa
    pop ebx                                      # 00503bfb
    ret                                          # 00503bfc

# --- data items (not part of the function) -------------------------
.org 0x00503bfd - 0x401000
PAD_00503bfd:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

