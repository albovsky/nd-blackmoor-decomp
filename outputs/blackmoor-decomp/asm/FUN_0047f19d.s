# FUN_0047f19d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047f19d
# extent:       0x0047f19d-0x0047f275 (216 code bytes)
# span:         0x0047f19d-0x0047f275 (code 216, tables 0, padding 0)
# sha256:       efe2f23539b342c092f2e420aec64754623d4d5435d8931b73ee0c408354c2be
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         clamp_rect
# naming:       native port src/action_family_eb_runtime.c:clamp_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    Compared the original clamp (16-bit width/height, top then bottom then left then right clamps against the four clip globals with the same signed comparisons and resizes) with clamp_rect; identical.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:clamp_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0047f19d - 0x401000
.globl FUN_0047f19d
FUN_0047f19d:
    # block 0x0047f19d: entry, 18 instruction(s), ends with jge to 0x0047f1f0 (forward)
    push ebp                                     # 0047f19d
    {load} mov ebp, esp                          # 0047f19e
    sub esp, 0xc                                 # 0047f1a0
    mov dword ptr [ebp - local_c], ecx           # 0047f1a3
    mov eax, dword ptr [ebp + arg_8]             # 0047f1a6
    mov ecx, dword ptr [ebp + arg_8]             # 0047f1a9
    mov edx, dword ptr [eax + field_8]           # 0047f1ac
    sub edx, dword ptr [ecx]                     # 0047f1af
    mov word ptr [ebp - local_8], dx             # 0047f1b1
    mov eax, dword ptr [ebp + arg_8]             # 0047f1b5
    mov ecx, dword ptr [ebp + arg_8]             # 0047f1b8
    mov edx, dword ptr [eax + field_c]           # 0047f1bb
    sub edx, dword ptr [ecx + field_4]           # 0047f1be
    mov word ptr [ebp - local_4], dx             # 0047f1c1
    mov eax, dword ptr [ebp + arg_8]             # 0047f1c5
    mov ecx, dword ptr [eax + field_4]           # 0047f1c8
    cmp ecx, dword ptr [0x58319a]                # 0047f1cb
    jge.d8 L_0047f1f0                            # 0047f1d1
    # block 0x0047f1d3: entered by fall-through of jge at 0x0047f1d1, 9 instruction(s), falls into the block at 0x0047f1f0
    mov edx, dword ptr [ebp + arg_8]             # 0047f1d3
    mov eax, dword ptr [0x58319a]                # 0047f1d6
    mov dword ptr [edx + field_4], eax           # 0047f1db
    movsx ecx, word ptr [ebp - local_4]          # 0047f1de
    mov edx, dword ptr [ebp + arg_8]             # 0047f1e2
    mov eax, dword ptr [edx + field_4]           # 0047f1e5
    {load} add eax, ecx                          # 0047f1e8
    mov ecx, dword ptr [ebp + arg_8]             # 0047f1ea
    mov dword ptr [ecx + field_c], eax           # 0047f1ed
L_0047f1f0:
    # block 0x0047f1f0: entered by jge at 0x0047f1d1, 4 instruction(s), ends with jle to 0x0047f21c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0047f1f0
    mov eax, dword ptr [edx + field_c]           # 0047f1f3
    cmp eax, dword ptr [0x5831a2]                # 0047f1f6
    jle.d8 L_0047f21c                            # 0047f1fc
    # block 0x0047f1fe: entered by fall-through of jle at 0x0047f1fc, 9 instruction(s), falls into the block at 0x0047f21c
    mov ecx, dword ptr [ebp + arg_8]             # 0047f1fe
    mov edx, dword ptr [0x5831a2]                # 0047f201
    mov dword ptr [ecx + field_c], edx           # 0047f207
    movsx eax, word ptr [ebp - local_4]          # 0047f20a
    mov ecx, dword ptr [ebp + arg_8]             # 0047f20e
    mov edx, dword ptr [ecx + field_c]           # 0047f211
    {load} sub edx, eax                          # 0047f214
    mov eax, dword ptr [ebp + arg_8]             # 0047f216
    mov dword ptr [eax + field_4], edx           # 0047f219
L_0047f21c:
    # block 0x0047f21c: entered by jle at 0x0047f1fc, 4 instruction(s), ends with jge to 0x0047f245 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0047f21c
    mov edx, dword ptr [ecx]                     # 0047f21f
    cmp edx, dword ptr [0x583196]                # 0047f221
    jge.d8 L_0047f245                            # 0047f227
    # block 0x0047f229: entered by fall-through of jge at 0x0047f227, 9 instruction(s), falls into the block at 0x0047f245
    mov eax, dword ptr [ebp + arg_8]             # 0047f229
    mov ecx, dword ptr [0x583196]                # 0047f22c
    mov dword ptr [eax], ecx                     # 0047f232
    movsx edx, word ptr [ebp - local_8]          # 0047f234
    mov eax, dword ptr [ebp + arg_8]             # 0047f238
    mov ecx, dword ptr [eax]                     # 0047f23b
    {load} add ecx, edx                          # 0047f23d
    mov edx, dword ptr [ebp + arg_8]             # 0047f23f
    mov dword ptr [edx + field_8], ecx           # 0047f242
L_0047f245:
    # block 0x0047f245: entered by jge at 0x0047f227, 4 instruction(s), ends with jle to 0x0047f26f (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0047f245
    mov ecx, dword ptr [eax + field_8]           # 0047f248
    cmp ecx, dword ptr [0x58319e]                # 0047f24b
    jle.d8 L_0047f26f                            # 0047f251
    # block 0x0047f253: entered by fall-through of jle at 0x0047f251, 9 instruction(s), falls into the block at 0x0047f26f
    mov edx, dword ptr [ebp + arg_8]             # 0047f253
    mov eax, dword ptr [0x58319e]                # 0047f256
    mov dword ptr [edx + field_8], eax           # 0047f25b
    movsx ecx, word ptr [ebp - local_8]          # 0047f25e
    mov edx, dword ptr [ebp + arg_8]             # 0047f262
    mov eax, dword ptr [edx + field_8]           # 0047f265
    {load} sub eax, ecx                          # 0047f268
    mov ecx, dword ptr [ebp + arg_8]             # 0047f26a
    mov dword ptr [ecx], eax                     # 0047f26d
L_0047f26f:
    # block 0x0047f26f: entered by jle at 0x0047f251, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0047f26f
    pop ebp                                      # 0047f271
    ret 0x4                                      # 0047f272

