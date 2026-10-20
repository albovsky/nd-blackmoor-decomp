# FUN_004eac4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eac4c
# extent:       0x004eac4c-0x004eaca8 (92 code bytes)
# span:         0x004eac4c-0x004eaca8 (code 92, tables 0, padding 0)
# sha256:       882b9be7aafb84490a96381ec2c62b04742a47195fc9fe3a6ad94744fff5a81b
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eac4c_use_item
# naming:       native port src/original_methods_fl17.c:m4eac4c_use_item (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4eac4c_use_item. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 92 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ea06c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4eac4c_use_item (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)

.org 0x004eac4c - 0x401000
.globl FUN_004eac4c
FUN_004eac4c:
    # block 0x004eac4c: entry, 17 instruction(s), calls FUN_004ea06c, ends with jne to 0x004eac91 (forward)
    push ebp                                     # 004eac4c
    {load} mov ebp, esp                          # 004eac4d
    sub esp, 0x8                                 # 004eac4f
    mov dword ptr [ebp - local_8], ecx           # 004eac52
    movsx eax, word ptr [ebp + arg_8]            # 004eac55
    imul eax, eax, 0x8d                          # 004eac59
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eac5f
    mov dx, word ptr [ecx]                       # 004eac65
    mov word ptr [ebp - local_4], dx             # 004eac68
    mov ax, word ptr [ebp - local_4]             # 004eac6c
    push eax                                     # 004eac70
    mov ecx, dword ptr [ebp - local_8]           # 004eac71
    call FUN_004ea06c                            # 004eac74
    movsx ecx, word ptr [0x583a29]               # 004eac79
    movsx edx, word ptr [ebp - local_4]          # 004eac80
    {load} cmp ecx, edx                          # 004eac84
    jne.d8 L_004eac91                            # 004eac86
    # block 0x004eac88: entered by fall-through of jne at 0x004eac86, 1 instruction(s), falls into the block at 0x004eac91
    mov word ptr [0x583a29], 0xffff              # 004eac88
L_004eac91:
    # block 0x004eac91: entered by jne at 0x004eac86, 6 instruction(s), ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 004eac91
    imul eax, eax, 0x8d                          # 004eac95
    mov byte ptr [eax + 0x5bb625], 0x1           # 004eac9b
    {load} mov esp, ebp                          # 004eaca2
    pop ebp                                      # 004eaca4
    ret 0x4                                      # 004eaca5

