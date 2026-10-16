# FUN_0050bc20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bc20
# extent:       0x0050bc20-0x0050bc43 (35 code bytes)
# span:         0x0050bc20-0x0050bc50 (code 35, tables 0, padding 13)
# sha256:       4dd54569453d1bd156f885b243e87df2469f8565266641aa1e93a8625444bbbd
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bc20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x0050bc20 - 0x401000
.globl FUN_0050bc20
FUN_0050bc20:
    # block 0x0050bc20: entry, 14 instruction(s), calls FUN_0050e936, ends with ret
    push esi                                     # 0050bc20
    mov esi, dword ptr [esp + stk_8]             # 0050bc21
    mov eax, dword ptr [esi + field_8]           # 0050bc25
    push eax                                     # 0050bc28
    call FUN_0050e936                            # 0050bc29
    {load} xor ecx, ecx                          # 0050bc2e
    add esp, 0x4                                 # 0050bc30
    mov dword ptr [esi], ecx                     # 0050bc33
    mov dword ptr [esi + field_4], ecx           # 0050bc35
    mov dword ptr [esi + field_8], ecx           # 0050bc38
    mov dword ptr [esi + field_c], ecx           # 0050bc3b
    mov dword ptr [esi + field_10], ecx          # 0050bc3e
    pop esi                                      # 0050bc41
    ret                                          # 0050bc42

# --- data items (not part of the function) -------------------------
.org 0x0050bc43 - 0x401000
PAD_0050bc43:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

