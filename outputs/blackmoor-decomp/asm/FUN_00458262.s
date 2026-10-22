# FUN_00458262
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458262
# extent:       0x00458262-0x0045839e (316 code bytes)
# span:         0x00458262-0x0045839e (code 316, tables 0, padding 0)
# sha256:       fbe2a570f784171769b8c7e2d2ae7e144312856b47f45dd163664a5863e8de04
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m458262_lifted
# naming:       native port src/original_methods_fl40.c:m458262_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 8 seeds; oracle 104/104 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_3e, field_42, field_46, field_4a, field_56, field_5e, field_62, field_66, field_6a, field_a6, field_aa, field_b0 and 1 more; [ecx + n] field_4e, field_52, field_56, field_5a, field_6e, field_72, field_76, field_7a, field_9e, field_a2; [edx + n] field_4e, field_52, field_9e, field_a2, field_b0
# callees:      calls FUN_0045818a, FUN_00458137
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m458262_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 104 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6e, 0x6e  # offset +0x6e
.equ field_72, 0x72  # offset +0x72
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_9e, 0x9e  # offset +0x9e
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_aa, 0xaa  # offset +0xaa
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2

# --- external targets -----------------------------------------------
.set FUN_00458137, .text + (0x00458137 - 0x401000)
.set FUN_0045818a, .text + (0x0045818a - 0x401000)

.org 0x00458262 - 0x401000
.globl FUN_00458262
FUN_00458262:
    # block 0x00458262: entry, 104 instruction(s), calls FUN_0045818a, FUN_00458137, ends with ret
    push ebp                                     # 00458262
    {load} mov ebp, esp                          # 00458263
    sub esp, 0xc                                 # 00458265
    mov dword ptr [ebp - local_c], ecx           # 00458268
    mov eax, dword ptr [ebp - local_c]           # 0045826b
    mov ecx, dword ptr [ebp - local_c]           # 0045826e
    mov eax, dword ptr [eax + field_a6]          # 00458271
    sub eax, dword ptr [ecx + field_9e]          # 00458277
    cdq                                          # 0045827d
    {load} sub eax, edx                          # 0045827e
    sar eax                                      # 00458280
    mov edx, dword ptr [ebp - local_c]           # 00458282
    add eax, dword ptr [edx + field_9e]          # 00458285
    mov dword ptr [ebp - local_8], eax           # 0045828b
    mov eax, dword ptr [ebp - local_c]           # 0045828e
    mov ecx, dword ptr [ebp - local_c]           # 00458291
    mov eax, dword ptr [eax + field_aa]          # 00458294
    sub eax, dword ptr [ecx + field_a2]          # 0045829a
    cdq                                          # 004582a0
    {load} sub eax, edx                          # 004582a1
    sar eax                                      # 004582a3
    mov edx, dword ptr [ebp - local_c]           # 004582a5
    add eax, dword ptr [edx + field_a2]          # 004582a8
    mov dword ptr [ebp - local_4], eax           # 004582ae
    mov eax, dword ptr [ebp - local_c]           # 004582b1
    mov ecx, dword ptr [ebp - local_c]           # 004582b4
    mov edx, dword ptr [ecx + field_52]          # 004582b7
    mov dword ptr [eax + field_42], edx          # 004582ba
    mov eax, dword ptr [ebp - local_c]           # 004582bd
    mov ecx, dword ptr [ebp - local_c]           # 004582c0
    mov edx, dword ptr [ecx + field_5a]          # 004582c3
    mov dword ptr [eax + field_4a], edx          # 004582c6
    mov eax, dword ptr [ebp - local_c]           # 004582c9
    mov ecx, dword ptr [ebp - local_c]           # 004582cc
    mov edx, dword ptr [ecx + field_4e]          # 004582cf
    mov dword ptr [eax + field_3e], edx          # 004582d2
    mov eax, dword ptr [ebp - local_c]           # 004582d5
    mov ecx, dword ptr [ebp - local_c]           # 004582d8
    mov edx, dword ptr [ecx + field_56]          # 004582db
    mov dword ptr [eax + field_46], edx          # 004582de
    mov eax, dword ptr [ebp - local_c]           # 004582e1
    mov ecx, dword ptr [ebp - local_c]           # 004582e4
    mov edx, dword ptr [ecx + field_72]          # 004582e7
    mov dword ptr [eax + field_62], edx          # 004582ea
    mov eax, dword ptr [ebp - local_c]           # 004582ed
    mov ecx, dword ptr [ebp - local_c]           # 004582f0
    mov edx, dword ptr [ecx + field_7a]          # 004582f3
    mov dword ptr [eax + field_6a], edx          # 004582f6
    mov eax, dword ptr [ebp - local_c]           # 004582f9
    mov ecx, dword ptr [ebp - local_c]           # 004582fc
    mov edx, dword ptr [ecx + field_6e]          # 004582ff
    mov dword ptr [eax + field_5e], edx          # 00458302
    mov eax, dword ptr [ebp - local_c]           # 00458305
    mov ecx, dword ptr [ebp - local_c]           # 00458308
    mov edx, dword ptr [ecx + field_76]          # 0045830b
    mov dword ptr [eax + field_66], edx          # 0045830e
    mov eax, dword ptr [ebp - local_c]           # 00458311
    movsx eax, word ptr [eax + field_b2]         # 00458314
    cdq                                          # 0045831b
    {load} sub eax, edx                          # 0045831c
    sar eax                                      # 0045831e
    mov ecx, dword ptr [ebp - local_4]           # 00458320
    {load} sub ecx, eax                          # 00458323
    mov edx, dword ptr [ebp - local_c]           # 00458325
    mov dword ptr [edx + field_52], ecx          # 00458328
    mov eax, dword ptr [ebp - local_c]           # 0045832b
    movsx eax, word ptr [eax + field_b0]         # 0045832e
    cdq                                          # 00458335
    {load} sub eax, edx                          # 00458336
    sar eax                                      # 00458338
    mov ecx, dword ptr [ebp - local_8]           # 0045833a
    {load} sub ecx, eax                          # 0045833d
    mov edx, dword ptr [ebp - local_c]           # 0045833f
    mov dword ptr [edx + field_4e], ecx          # 00458342
    mov eax, dword ptr [ebp - local_c]           # 00458345
    movsx ecx, word ptr [eax + field_b2]         # 00458348
    mov edx, dword ptr [ebp - local_c]           # 0045834f
    mov eax, dword ptr [edx + field_52]          # 00458352
    {load} add eax, ecx                          # 00458355
    mov ecx, dword ptr [ebp - local_c]           # 00458357
    mov dword ptr [ecx + field_5a], eax          # 0045835a
    mov edx, dword ptr [ebp - local_c]           # 0045835d
    movsx eax, word ptr [edx + field_b0]         # 00458360
    mov ecx, dword ptr [ebp - local_c]           # 00458367
    mov edx, dword ptr [ecx + field_4e]          # 0045836a
    {load} add edx, eax                          # 0045836d
    mov eax, dword ptr [ebp - local_c]           # 0045836f
    mov dword ptr [eax + field_56], edx          # 00458372
    mov ecx, dword ptr [ebp - local_c]           # 00458375
    add ecx, 0x4e                                # 00458378
    push ecx                                     # 0045837b
    mov ecx, dword ptr [ebp - local_c]           # 0045837c
    call FUN_0045818a                            # 0045837f
    mov edx, dword ptr [ebp - local_c]           # 00458384
    add edx, 0x6e                                # 00458387
    push edx                                     # 0045838a
    mov eax, dword ptr [ebp - local_c]           # 0045838b
    add eax, 0x4e                                # 0045838e
    push eax                                     # 00458391
    mov ecx, dword ptr [ebp - local_c]           # 00458392
    call FUN_00458137                            # 00458395
    {load} mov esp, ebp                          # 0045839a
    pop ebp                                      # 0045839c
    ret                                          # 0045839d

