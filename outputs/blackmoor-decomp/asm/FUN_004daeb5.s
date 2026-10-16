# FUN_004daeb5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daeb5
# extent:       0x004daeb5-0x004daef1 (60 code bytes)
# span:         0x004daeb5-0x004daef1 (code 60, tables 0, padding 0)
# sha256:       326d41316d7ec99cb51918c1223f22d25c085b1b9fd2a076dc6fbd5b36c4036d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004daeb5
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c; [ecx + n] field_18; [edx + n] field_4
# callees:      calls USER32.dll!GetCursorPos
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:slider_update (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x004daeb5 - 0x401000
.globl FUN_004daeb5
FUN_004daeb5:
    # block 0x004daeb5: entry, 22 instruction(s), calls USER32.dll!GetCursorPos, ends with ret 0x4
    push ebp                                     # 004daeb5
    {load} mov ebp, esp                          # 004daeb6
    sub esp, 0xc                                 # 004daeb8
    mov dword ptr [ebp - local_c], ecx           # 004daebb
    lea eax, [ebp - local_8]                     # 004daebe
    push eax                                     # 004daec1
    call dword ptr [0x52a484]                    # 004daec2
    mov ecx, dword ptr [ebp - local_c]           # 004daec8
    mov edx, dword ptr [ebp - local_8]           # 004daecb
    mov dword ptr [ecx + field_18], edx          # 004daece
    mov eax, dword ptr [ebp - local_c]           # 004daed1
    mov ecx, dword ptr [ebp - local_4]           # 004daed4
    mov dword ptr [eax + field_1c], ecx          # 004daed7
    mov edx, dword ptr [ebp + arg_8]             # 004daeda
    mov eax, dword ptr [ebp - local_8]           # 004daedd
    mov dword ptr [edx], eax                     # 004daee0
    mov ecx, dword ptr [ebp - local_4]           # 004daee2
    mov dword ptr [edx + field_4], ecx           # 004daee5
    mov eax, dword ptr [ebp + arg_8]             # 004daee8
    {load} mov esp, ebp                          # 004daeeb
    pop ebp                                      # 004daeed
    ret 0x4                                      # 004daeee

