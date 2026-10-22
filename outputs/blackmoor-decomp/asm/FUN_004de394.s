# FUN_004de394
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de394
# extent:       0x004de394-0x004de413 (127 code bytes)
# span:         0x004de394-0x004de413 (code 127, tables 0, padding 0)
# sha256:       71579cd2b86a00ad97641443593960982d99c04aeec8655050712bf28e8bebec
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de394_copy_block
# naming:       native port src/original_methods_fl39c.c:m4de394_copy_block (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Copies 0x300 bytes from src to [self+0x691]; when 0x300 > limit (signed) runs the diagnostic calls 0x50ca3e, 0x4264e8, 0x4c97b4. Limits below, at and above the size, negative and 0x7fffffff; All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4de394_copy_block (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004de394 - 0x401000
.globl FUN_004de394
FUN_004de394:
    # block 0x004de394: entry, 21 instruction(s), ends with jle to 0x004de40b (forward)
    push ebp                                     # 004de394
    {load} mov ebp, esp                          # 004de395
    sub esp, 0x8                                 # 004de397
    push esi                                     # 004de39a
    push edi                                     # 004de39b
    mov dword ptr [ebp - local_8], ecx           # 004de39c
    mov dword ptr [ebp - local_4], 0x0           # 004de39f
    mov edi, dword ptr [ebp - local_8]           # 004de3a6
    add edi, 0x691                               # 004de3a9
    mov ecx, 0xc0                                # 004de3af
    mov esi, dword ptr [ebp + arg_8]             # 004de3b4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004de3b7
    mov eax, dword ptr [ebp + arg_8]             # 004de3b9
    add eax, 0x300                               # 004de3bc
    mov dword ptr [ebp + arg_8], eax             # 004de3c1
    mov ecx, dword ptr [ebp - local_4]           # 004de3c4
    add ecx, 0x300                               # 004de3c7
    mov dword ptr [ebp - local_4], ecx           # 004de3cd
    mov edx, dword ptr [ebp - local_4]           # 004de3d0
    cmp edx, dword ptr [ebp + arg_c]             # 004de3d3
    jle.d8 L_004de40b                            # 004de3d6
    # block 0x004de3d8: entered by fall-through of jle at 0x004de3d6, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004de40b
    mov eax, dword ptr [ebp + arg_c]             # 004de3d8
    push eax                                     # 004de3db
    mov ecx, dword ptr [ebp - local_4]           # 004de3dc
    push ecx                                     # 004de3df
    push 0x55b87c                                # 004de3e0
    push 0x63888b                                # 004de3e5
    call FUN_0050ca3e                            # 004de3ea
    add esp, 0x10                                # 004de3ef
    push 0x63888b                                # 004de3f2
    mov ecx, 0x583979                            # 004de3f7
    call FUN_004264e8                            # 004de3fc
    mov ecx, 0x5cf659                            # 004de401
    call FUN_004c97b4                            # 004de406
L_004de40b:
    # block 0x004de40b: entered by jle at 0x004de3d6, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004de40b
    pop esi                                      # 004de40c
    {load} mov esp, ebp                          # 004de40d
    pop ebp                                      # 004de40f
    ret 0x8                                      # 004de410

