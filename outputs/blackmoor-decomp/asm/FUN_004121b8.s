# FUN_004121b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004121b8
# extent:       0x004121b8-0x00412234 (124 code bytes)
# span:         0x004121b8-0x00412234 (code 124, tables 0, padding 0)
# sha256:       820a18022e9054dbce130344a7b0725e5391f7547e54a726b810dfe22d91125a
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4121b8_start_piece
# naming:       native port src/original_methods_fl18.c:m4121b8_start_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4121b8_start_piece. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 124 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_102a
# callees:      calls FUN_00413187, FUN_0042ba3a, FUN_00411b16
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_102a, 0x102a  # offset +0x102a

# --- external targets -----------------------------------------------
.set FUN_00411b16, .text + (0x00411b16 - 0x401000)
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x004121b8 - 0x401000
.globl FUN_004121b8
FUN_004121b8:
    # block 0x004121b8: entry, 37 instruction(s), calls FUN_00413187, FUN_0042ba3a, FUN_00411b16, ends with ret 0x4
    push ebp                                     # 004121b8
    {load} mov ebp, esp                          # 004121b9
    sub esp, 0xc                                 # 004121bb
    mov dword ptr [ebp - local_c], ecx           # 004121be
    movsx eax, word ptr [ebp + arg_8]            # 004121c1
    imul eax, eax, 0x8d                          # 004121c5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004121cb
    mov dword ptr [ebp - local_8], ecx           # 004121d1
    movsx edx, word ptr [ebp + arg_8]            # 004121d4
    imul edx, edx, 0x8d                          # 004121d8
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004121de
    mov dword ptr [ebp - local_4], eax           # 004121e4
    mov ecx, dword ptr [ebp - local_c]           # 004121e7
    mov dword ptr [ecx + field_102a], 0x0        # 004121ea
    push 0x0                                     # 004121f4
    push 0x0                                     # 004121f6
    mov edx, dword ptr [ebp - local_8]           # 004121f8
    add edx, 0x210                               # 004121fb
    push edx                                     # 00412201
    mov eax, dword ptr [ebp - local_4]           # 00412202
    push eax                                     # 00412205
    mov ecx, dword ptr [ebp - local_c]           # 00412206
    call FUN_00413187                            # 00412209
    mov cx, word ptr [ebp + arg_8]               # 0041220e
    push ecx                                     # 00412212
    call FUN_0042ba3a                            # 00412213
    add esp, 0x4                                 # 00412218
    push 0x0                                     # 0041221b
    mov dx, word ptr [ebp + arg_8]               # 0041221d
    push edx                                     # 00412221
    mov eax, dword ptr [ebp - local_4]           # 00412222
    push eax                                     # 00412225
    mov ecx, dword ptr [ebp - local_c]           # 00412226
    call FUN_00411b16                            # 00412229
    {load} mov esp, ebp                          # 0041222e
    pop ebp                                      # 00412230
    ret 0x4                                      # 00412231

