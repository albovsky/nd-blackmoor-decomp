# FUN_0044655e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044655e
# extent:       0x0044655e-0x00446598 (58 code bytes)
# span:         0x0044655e-0x00446598 (code 58, tables 0, padding 0)
# sha256:       3e9beb00d4e6932214089bc1acc4c1a9ee55364008ca58a80ac1b20951c34d5c
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044655e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_23c; [edx + n] field_23c
# callees:      calls FUN_0050ca3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_23c, 0x23c  # offset +0x23c

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0044655e - 0x401000
.globl FUN_0044655e
FUN_0044655e:
    # block 0x0044655e: entry, 19 instruction(s), calls FUN_0050ca3e, ends with ret 0x4
    push ebp                                     # 0044655e
    {load} mov ebp, esp                          # 0044655f
    push ecx                                     # 00446561
    mov dword ptr [ebp - local_4], ecx           # 00446562
    mov eax, dword ptr [ebp - local_4]           # 00446565
    mov ecx, dword ptr [ebp + arg_8]             # 00446568
    mov dword ptr [eax + field_23c], ecx         # 0044656b
    mov edx, dword ptr [ebp - local_4]           # 00446571
    mov eax, dword ptr [edx + field_23c]         # 00446574
    push eax                                     # 0044657a
    push 0x548238                                # 0044657b
    mov ecx, dword ptr [ebp - local_4]           # 00446580
    add ecx, 0x25c                               # 00446583
    push ecx                                     # 00446589
    call FUN_0050ca3e                            # 0044658a
    add esp, 0xc                                 # 0044658f
    {load} mov esp, ebp                          # 00446592
    pop ebp                                      # 00446594
    ret 0x4                                      # 00446595

