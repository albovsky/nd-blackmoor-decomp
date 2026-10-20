# FUN_0047f275
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047f275
# extent:       0x0047f275-0x0047f421 (428 code bytes)
# span:         0x0047f275-0x0047f421 (code 428, tables 0, padding 0)
# sha256:       a6636eadde63e888f92dbe53153a47cf804c321319e1089cc936510beca262f5
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         follow_pointer
# naming:       native port src/action_family_eb_runtime.c:follow_pointer (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with follow_pointer (prev copy, centre by half hand size, clamp). Native: host view seam can fail (EB_ERR_HOST); oracle is aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_136a, field_13d7, field_13db, field_13e3, field_13e5; [ecx + n] field_4, field_8, field_c, field_1356, field_1362, field_136e, field_13cf, field_13d3; [edx + n] field_4, field_8, field_c, field_135e, field_1362, field_1366, field_13cf, field_13d3, field_13e3, field_13e5
# callees:      calls FUN_0047f19d, FUN_0047e52f
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:follow_pointer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 126 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1356, 0x1356  # offset +0x1356
.equ field_135e, 0x135e  # offset +0x135e
.equ field_1362, 0x1362  # offset +0x1362
.equ field_1366, 0x1366  # offset +0x1366
.equ field_136a, 0x136a  # offset +0x136a
.equ field_136e, 0x136e  # offset +0x136e
.equ field_13cf, 0x13cf  # offset +0x13cf
.equ field_13d3, 0x13d3  # offset +0x13d3
.equ field_13d7, 0x13d7  # offset +0x13d7
.equ field_13db, 0x13db  # offset +0x13db
.equ field_13e3, 0x13e3  # offset +0x13e3
.equ field_13e5, 0x13e5  # offset +0x13e5

# --- external targets -----------------------------------------------
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047f19d, .text + (0x0047f19d - 0x401000)

.org 0x0047f275 - 0x401000
.globl FUN_0047f275
FUN_0047f275:
    # block 0x0047f275: entry, 96 instruction(s), calls FUN_0047f19d, FUN_0047e52f, ends with jne to 0x0047f41d (forward)
    push ebp                                     # 0047f275
    {load} mov ebp, esp                          # 0047f276
    sub esp, 0xc                                 # 0047f278
    mov dword ptr [ebp - local_c], ecx           # 0047f27b
    mov eax, dword ptr [ebp - local_c]           # 0047f27e
    mov ecx, dword ptr [ebp - local_c]           # 0047f281
    mov eax, dword ptr [eax + field_13d7]        # 0047f284
    sub eax, dword ptr [ecx + field_13cf]        # 0047f28a
    cdq                                          # 0047f290
    {load} sub eax, edx                          # 0047f291
    sar eax                                      # 0047f293
    mov edx, dword ptr [ebp - local_c]           # 0047f295
    add eax, dword ptr [edx + field_13cf]        # 0047f298
    mov dword ptr [ebp - local_8], eax           # 0047f29e
    mov eax, dword ptr [ebp - local_c]           # 0047f2a1
    mov ecx, dword ptr [ebp - local_c]           # 0047f2a4
    mov eax, dword ptr [eax + field_13db]        # 0047f2a7
    sub eax, dword ptr [ecx + field_13d3]        # 0047f2ad
    cdq                                          # 0047f2b3
    {load} sub eax, edx                          # 0047f2b4
    sar eax                                      # 0047f2b6
    mov edx, dword ptr [ebp - local_c]           # 0047f2b8
    add eax, dword ptr [edx + field_13d3]        # 0047f2bb
    mov dword ptr [ebp - local_4], eax           # 0047f2c1
    mov eax, dword ptr [ebp - local_c]           # 0047f2c4
    add eax, 0x1362                              # 0047f2c7
    mov ecx, dword ptr [ebp - local_c]           # 0047f2cc
    add ecx, 0x1352                              # 0047f2cf
    mov edx, dword ptr [eax]                     # 0047f2d5
    mov dword ptr [ecx], edx                     # 0047f2d7
    mov edx, dword ptr [eax + field_4]           # 0047f2d9
    mov dword ptr [ecx + field_4], edx           # 0047f2dc
    mov edx, dword ptr [eax + field_8]           # 0047f2df
    mov dword ptr [ecx + field_8], edx           # 0047f2e2
    mov eax, dword ptr [eax + field_c]           # 0047f2e5
    mov dword ptr [ecx + field_c], eax           # 0047f2e8
    mov ecx, dword ptr [ebp - local_c]           # 0047f2eb
    add ecx, 0x1382                              # 0047f2ee
    mov edx, dword ptr [ebp - local_c]           # 0047f2f4
    add edx, 0x1372                              # 0047f2f7
    mov eax, dword ptr [ecx]                     # 0047f2fd
    mov dword ptr [edx], eax                     # 0047f2ff
    mov eax, dword ptr [ecx + field_4]           # 0047f301
    mov dword ptr [edx + field_4], eax           # 0047f304
    mov eax, dword ptr [ecx + field_8]           # 0047f307
    mov dword ptr [edx + field_8], eax           # 0047f30a
    mov ecx, dword ptr [ecx + field_c]           # 0047f30d
    mov dword ptr [edx + field_c], ecx           # 0047f310
    mov edx, dword ptr [ebp - local_c]           # 0047f313
    movsx eax, word ptr [edx + field_13e5]       # 0047f316
    cdq                                          # 0047f31d
    {load} sub eax, edx                          # 0047f31e
    sar eax                                      # 0047f320
    mov ecx, dword ptr [ebp - local_4]           # 0047f322
    {load} sub ecx, eax                          # 0047f325
    mov edx, dword ptr [ebp - local_c]           # 0047f327
    mov dword ptr [edx + field_1366], ecx        # 0047f32a
    mov eax, dword ptr [ebp - local_c]           # 0047f330
    movsx eax, word ptr [eax + field_13e3]       # 0047f333
    cdq                                          # 0047f33a
    {load} sub eax, edx                          # 0047f33b
    sar eax                                      # 0047f33d
    mov ecx, dword ptr [ebp - local_8]           # 0047f33f
    {load} sub ecx, eax                          # 0047f342
    mov edx, dword ptr [ebp - local_c]           # 0047f344
    mov dword ptr [edx + field_1362], ecx        # 0047f347
    mov eax, dword ptr [ebp - local_c]           # 0047f34d
    movsx ecx, word ptr [eax + field_13e5]       # 0047f350
    mov edx, dword ptr [ebp - local_c]           # 0047f357
    mov eax, dword ptr [edx + field_1366]        # 0047f35a
    {load} add eax, ecx                          # 0047f360
    mov ecx, dword ptr [ebp - local_c]           # 0047f362
    mov dword ptr [ecx + field_136e], eax        # 0047f365
    mov edx, dword ptr [ebp - local_c]           # 0047f36b
    movsx eax, word ptr [edx + field_13e3]       # 0047f36e
    mov ecx, dword ptr [ebp - local_c]           # 0047f375
    mov edx, dword ptr [ecx + field_1362]        # 0047f378
    {load} add edx, eax                          # 0047f37e
    mov eax, dword ptr [ebp - local_c]           # 0047f380
    mov dword ptr [eax + field_136a], edx        # 0047f383
    mov ecx, dword ptr [ebp - local_c]           # 0047f389
    add ecx, 0x1362                              # 0047f38c
    push ecx                                     # 0047f392
    mov ecx, dword ptr [ebp - local_c]           # 0047f393
    call FUN_0047f19d                            # 0047f396
    mov edx, dword ptr [ebp - local_c]           # 0047f39b
    add edx, 0x1382                              # 0047f39e
    push edx                                     # 0047f3a4
    mov eax, dword ptr [ebp - local_c]           # 0047f3a5
    add eax, 0x1362                              # 0047f3a8
    push eax                                     # 0047f3ad
    mov ecx, dword ptr [ebp - local_c]           # 0047f3ae
    call FUN_0047e52f                            # 0047f3b1
    mov ecx, dword ptr [ebp - local_c]           # 0047f3b6
    cmp dword ptr [ecx + field_1356], 0x0        # 0047f3b9
    jne.d8 L_0047f41d                            # 0047f3c0
    # block 0x0047f3c2: entered by fall-through of jne at 0x0047f3c0, 3 instruction(s), ends with jne to 0x0047f41d (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047f3c2
    cmp dword ptr [edx + field_135e], 0x0        # 0047f3c5
    jne.d8 L_0047f41d                            # 0047f3cc
    # block 0x0047f3ce: entered by fall-through of jne at 0x0047f3cc, 24 instruction(s), falls into the block at 0x0047f41d
    mov eax, dword ptr [ebp - local_c]           # 0047f3ce
    add eax, 0x1362                              # 0047f3d1
    mov ecx, dword ptr [ebp - local_c]           # 0047f3d6
    add ecx, 0x1352                              # 0047f3d9
    mov edx, dword ptr [eax]                     # 0047f3df
    mov dword ptr [ecx], edx                     # 0047f3e1
    mov edx, dword ptr [eax + field_4]           # 0047f3e3
    mov dword ptr [ecx + field_4], edx           # 0047f3e6
    mov edx, dword ptr [eax + field_8]           # 0047f3e9
    mov dword ptr [ecx + field_8], edx           # 0047f3ec
    mov eax, dword ptr [eax + field_c]           # 0047f3ef
    mov dword ptr [ecx + field_c], eax           # 0047f3f2
    mov ecx, dword ptr [ebp - local_c]           # 0047f3f5
    add ecx, 0x1382                              # 0047f3f8
    mov edx, dword ptr [ebp - local_c]           # 0047f3fe
    add edx, 0x1372                              # 0047f401
    mov eax, dword ptr [ecx]                     # 0047f407
    mov dword ptr [edx], eax                     # 0047f409
    mov eax, dword ptr [ecx + field_4]           # 0047f40b
    mov dword ptr [edx + field_4], eax           # 0047f40e
    mov eax, dword ptr [ecx + field_8]           # 0047f411
    mov dword ptr [edx + field_8], eax           # 0047f414
    mov ecx, dword ptr [ecx + field_c]           # 0047f417
    mov dword ptr [edx + field_c], ecx           # 0047f41a
L_0047f41d:
    # block 0x0047f41d: entered by jne at 0x0047f3c0; jne at 0x0047f3cc, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047f41d
    pop ebp                                      # 0047f41f
    ret                                          # 0047f420

