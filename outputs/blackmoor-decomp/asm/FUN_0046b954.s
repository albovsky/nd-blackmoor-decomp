# FUN_0046b954
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b954
# extent:       0x0046b954-0x0046bca9 (853 code bytes)
# span:         0x0046b954-0x0046bca9 (code 853, tables 0, padding 0)
# sha256:       8b5a6f2762ce544ab6c19b8dd9a61512e46b48834323a42a676fd23c657ad3c1
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46b954_lifted
# naming:       native port src/original_methods_fl40.c:m46b954_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 11 seeds; oracle 197/197 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_49fc, field_4a00, field_4a04, field_4a08, field_4a0c, field_4a10, field_4a14, field_4a18, field_4a1c, field_4a20, field_4a4c, field_4a62 and 1 more; [ecx + n] field_49e4, field_49e8, field_49ec, field_49f0, field_49f4, field_49f8, field_49fc, field_4a00, field_4a04, field_4a08, field_4a0c, field_4a10 and 5 more; [edx + n] field_49f4, field_49f8, field_49fc, field_4a00, field_4a14, field_4a18, field_4a1c, field_4a20, field_4a5a, field_4a5e, field_816a, field_816c
# callees:      calls FUN_0046b855
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46b954_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 197 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_49e4, 0x49e4  # offset +0x49e4
.equ field_49e8, 0x49e8  # offset +0x49e8
.equ field_49ec, 0x49ec  # offset +0x49ec
.equ field_49f0, 0x49f0  # offset +0x49f0
.equ field_49f4, 0x49f4  # offset +0x49f4
.equ field_49f8, 0x49f8  # offset +0x49f8
.equ field_49fc, 0x49fc  # offset +0x49fc
.equ field_4a00, 0x4a00  # offset +0x4a00
.equ field_4a04, 0x4a04  # offset +0x4a04
.equ field_4a08, 0x4a08  # offset +0x4a08
.equ field_4a0c, 0x4a0c  # offset +0x4a0c
.equ field_4a10, 0x4a10  # offset +0x4a10
.equ field_4a14, 0x4a14  # offset +0x4a14
.equ field_4a18, 0x4a18  # offset +0x4a18
.equ field_4a1c, 0x4a1c  # offset +0x4a1c
.equ field_4a20, 0x4a20  # offset +0x4a20
.equ field_4a4c, 0x4a4c  # offset +0x4a4c
.equ field_4a5a, 0x4a5a  # offset +0x4a5a
.equ field_4a5e, 0x4a5e  # offset +0x4a5e
.equ field_4a62, 0x4a62  # offset +0x4a62
.equ field_4a66, 0x4a66  # offset +0x4a66
.equ field_816a, 0x816a  # offset +0x816a
.equ field_816c, 0x816c  # offset +0x816c
.equ field_816e, 0x816e  # offset +0x816e
.equ field_8170, 0x8170  # offset +0x8170

# --- external targets -----------------------------------------------
.set FUN_0046b855, .text + (0x0046b855 - 0x401000)

.org 0x0046b954 - 0x401000
.globl FUN_0046b954
FUN_0046b954:
    # block 0x0046b954: entry, 27 instruction(s), ends with je to 0x0046bb1c (forward)
    push ebp                                     # 0046b954
    {load} mov ebp, esp                          # 0046b955
    sub esp, 0xc                                 # 0046b957
    mov dword ptr [ebp - local_c], ecx           # 0046b95a
    mov eax, dword ptr [ebp - local_c]           # 0046b95d
    mov ecx, dword ptr [ebp - local_c]           # 0046b960
    mov eax, dword ptr [eax + field_4a62]        # 0046b963
    sub eax, dword ptr [ecx + field_4a5a]        # 0046b969
    cdq                                          # 0046b96f
    {load} sub eax, edx                          # 0046b970
    sar eax                                      # 0046b972
    mov edx, dword ptr [ebp - local_c]           # 0046b974
    add eax, dword ptr [edx + field_4a5a]        # 0046b977
    mov dword ptr [ebp - local_8], eax           # 0046b97d
    mov eax, dword ptr [ebp - local_c]           # 0046b980
    mov ecx, dword ptr [ebp - local_c]           # 0046b983
    mov eax, dword ptr [eax + field_4a66]        # 0046b986
    sub eax, dword ptr [ecx + field_4a5e]        # 0046b98c
    cdq                                          # 0046b992
    {load} sub eax, edx                          # 0046b993
    sar eax                                      # 0046b995
    mov edx, dword ptr [ebp - local_c]           # 0046b997
    add eax, dword ptr [edx + field_4a5e]        # 0046b99a
    mov dword ptr [ebp - local_4], eax           # 0046b9a0
    mov eax, dword ptr [ebp - local_c]           # 0046b9a3
    cmp dword ptr [eax + field_4a4c], 0x0        # 0046b9a6
    je.d32 L_0046bb1c                            # 0046b9ad
    # block 0x0046b9b3: entered by fall-through of je at 0x0046b9ad, 81 instruction(s), calls FUN_0046b855, ends with forward jump to 0x0046bca5
    mov ecx, dword ptr [ebp - local_c]           # 0046b9b3
    mov edx, dword ptr [ebp - local_c]           # 0046b9b6
    mov eax, dword ptr [edx + field_49f8]        # 0046b9b9
    mov dword ptr [ecx + field_49e8], eax        # 0046b9bf
    mov ecx, dword ptr [ebp - local_c]           # 0046b9c5
    mov edx, dword ptr [ebp - local_c]           # 0046b9c8
    mov eax, dword ptr [edx + field_4a00]        # 0046b9cb
    mov dword ptr [ecx + field_49f0], eax        # 0046b9d1
    mov ecx, dword ptr [ebp - local_c]           # 0046b9d7
    mov edx, dword ptr [ebp - local_c]           # 0046b9da
    mov eax, dword ptr [edx + field_49f4]        # 0046b9dd
    mov dword ptr [ecx + field_49e4], eax        # 0046b9e3
    mov ecx, dword ptr [ebp - local_c]           # 0046b9e9
    mov edx, dword ptr [ebp - local_c]           # 0046b9ec
    mov eax, dword ptr [edx + field_49fc]        # 0046b9ef
    mov dword ptr [ecx + field_49ec], eax        # 0046b9f5
    mov ecx, dword ptr [ebp - local_c]           # 0046b9fb
    mov edx, dword ptr [ebp - local_c]           # 0046b9fe
    mov eax, dword ptr [edx + field_4a18]        # 0046ba01
    mov dword ptr [ecx + field_4a08], eax        # 0046ba07
    mov ecx, dword ptr [ebp - local_c]           # 0046ba0d
    mov edx, dword ptr [ebp - local_c]           # 0046ba10
    mov eax, dword ptr [edx + field_4a20]        # 0046ba13
    mov dword ptr [ecx + field_4a10], eax        # 0046ba19
    mov ecx, dword ptr [ebp - local_c]           # 0046ba1f
    mov edx, dword ptr [ebp - local_c]           # 0046ba22
    mov eax, dword ptr [edx + field_4a14]        # 0046ba25
    mov dword ptr [ecx + field_4a04], eax        # 0046ba2b
    mov ecx, dword ptr [ebp - local_c]           # 0046ba31
    mov edx, dword ptr [ebp - local_c]           # 0046ba34
    mov eax, dword ptr [edx + field_4a1c]        # 0046ba37
    mov dword ptr [ecx + field_4a0c], eax        # 0046ba3d
    mov ecx, dword ptr [ebp - local_c]           # 0046ba43
    movsx edx, word ptr [ecx + field_8170]       # 0046ba46
    mov eax, dword ptr [ebp - local_4]           # 0046ba4d
    {load} sub eax, edx                          # 0046ba50
    mov ecx, dword ptr [ebp - local_c]           # 0046ba52
    mov dword ptr [ecx + field_49f8], eax        # 0046ba55
    mov edx, dword ptr [ebp - local_c]           # 0046ba5b
    movsx eax, word ptr [edx + field_816c]       # 0046ba5e
    mov ecx, dword ptr [ebp - local_c]           # 0046ba65
    mov edx, dword ptr [ecx + field_49f8]        # 0046ba68
    {load} add edx, eax                          # 0046ba6e
    mov eax, dword ptr [ebp - local_c]           # 0046ba70
    mov dword ptr [eax + field_4a00], edx        # 0046ba73
    mov ecx, dword ptr [ebp - local_c]           # 0046ba79
    movsx edx, word ptr [ecx + field_816e]       # 0046ba7c
    mov eax, dword ptr [ebp - local_8]           # 0046ba83
    {load} sub eax, edx                          # 0046ba86
    mov ecx, dword ptr [ebp - local_c]           # 0046ba88
    mov dword ptr [ecx + field_49f4], eax        # 0046ba8b
    mov edx, dword ptr [ebp - local_c]           # 0046ba91
    movsx eax, word ptr [edx + field_816a]       # 0046ba94
    mov ecx, dword ptr [ebp - local_c]           # 0046ba9b
    mov edx, dword ptr [ecx + field_49f4]        # 0046ba9e
    {load} add edx, eax                          # 0046baa4
    mov eax, dword ptr [ebp - local_c]           # 0046baa6
    mov dword ptr [eax + field_49fc], edx        # 0046baa9
    mov ecx, dword ptr [ebp - local_c]           # 0046baaf
    call FUN_0046b855                            # 0046bab2
    mov ecx, dword ptr [ebp - local_c]           # 0046bab7
    mov edx, dword ptr [ecx + field_49f8]        # 0046baba
    add edx, dword ptr [0x58318a]                # 0046bac0
    mov eax, dword ptr [ebp - local_c]           # 0046bac6
    mov dword ptr [eax + field_4a18], edx        # 0046bac9
    mov ecx, dword ptr [ebp - local_c]           # 0046bacf
    mov edx, dword ptr [ecx + field_4a00]        # 0046bad2
    add edx, dword ptr [0x58318a]                # 0046bad8
    mov eax, dword ptr [ebp - local_c]           # 0046bade
    mov dword ptr [eax + field_4a20], edx        # 0046bae1
    mov ecx, dword ptr [ebp - local_c]           # 0046bae7
    mov edx, dword ptr [ecx + field_49f4]        # 0046baea
    add edx, dword ptr [0x583186]                # 0046baf0
    mov eax, dword ptr [ebp - local_c]           # 0046baf6
    mov dword ptr [eax + field_4a14], edx        # 0046baf9
    mov ecx, dword ptr [ebp - local_c]           # 0046baff
    mov edx, dword ptr [ecx + field_49fc]        # 0046bb02
    add edx, dword ptr [0x583186]                # 0046bb08
    mov eax, dword ptr [ebp - local_c]           # 0046bb0e
    mov dword ptr [eax + field_4a1c], edx        # 0046bb11
    jmp.d32 L_0046bca5                           # 0046bb17
L_0046bb1c:
    # block 0x0046bb1c: entered by je at 0x0046b9ad, 86 instruction(s), calls FUN_0046b855, falls into the block at 0x0046bca5
    mov ecx, dword ptr [ebp - local_c]           # 0046bb1c
    movsx edx, word ptr [ecx + field_8170]       # 0046bb1f
    mov eax, dword ptr [ebp - local_4]           # 0046bb26
    {load} sub eax, edx                          # 0046bb29
    mov ecx, dword ptr [ebp - local_c]           # 0046bb2b
    mov dword ptr [ecx + field_49f8], eax        # 0046bb2e
    mov edx, dword ptr [ebp - local_c]           # 0046bb34
    movsx eax, word ptr [edx + field_816c]       # 0046bb37
    mov ecx, dword ptr [ebp - local_c]           # 0046bb3e
    mov edx, dword ptr [ecx + field_49f8]        # 0046bb41
    {load} add edx, eax                          # 0046bb47
    mov eax, dword ptr [ebp - local_c]           # 0046bb49
    mov dword ptr [eax + field_4a00], edx        # 0046bb4c
    mov ecx, dword ptr [ebp - local_c]           # 0046bb52
    movsx edx, word ptr [ecx + field_816e]       # 0046bb55
    mov eax, dword ptr [ebp - local_8]           # 0046bb5c
    {load} sub eax, edx                          # 0046bb5f
    mov ecx, dword ptr [ebp - local_c]           # 0046bb61
    mov dword ptr [ecx + field_49f4], eax        # 0046bb64
    mov edx, dword ptr [ebp - local_c]           # 0046bb6a
    movsx eax, word ptr [edx + field_816a]       # 0046bb6d
    mov ecx, dword ptr [ebp - local_c]           # 0046bb74
    mov edx, dword ptr [ecx + field_49f4]        # 0046bb77
    {load} add edx, eax                          # 0046bb7d
    mov eax, dword ptr [ebp - local_c]           # 0046bb7f
    mov dword ptr [eax + field_49fc], edx        # 0046bb82
    mov ecx, dword ptr [ebp - local_c]           # 0046bb88
    call FUN_0046b855                            # 0046bb8b
    mov ecx, dword ptr [ebp - local_c]           # 0046bb90
    mov edx, dword ptr [ebp - local_c]           # 0046bb93
    mov eax, dword ptr [edx + field_49f8]        # 0046bb96
    mov dword ptr [ecx + field_49e8], eax        # 0046bb9c
    mov ecx, dword ptr [ebp - local_c]           # 0046bba2
    mov edx, dword ptr [ebp - local_c]           # 0046bba5
    mov eax, dword ptr [edx + field_4a00]        # 0046bba8
    mov dword ptr [ecx + field_49f0], eax        # 0046bbae
    mov ecx, dword ptr [ebp - local_c]           # 0046bbb4
    mov edx, dword ptr [ebp - local_c]           # 0046bbb7
    mov eax, dword ptr [edx + field_49f4]        # 0046bbba
    mov dword ptr [ecx + field_49e4], eax        # 0046bbc0
    mov ecx, dword ptr [ebp - local_c]           # 0046bbc6
    mov edx, dword ptr [ebp - local_c]           # 0046bbc9
    mov eax, dword ptr [edx + field_49fc]        # 0046bbcc
    mov dword ptr [ecx + field_49ec], eax        # 0046bbd2
    mov ecx, dword ptr [ebp - local_c]           # 0046bbd8
    mov edx, dword ptr [ecx + field_49f8]        # 0046bbdb
    add edx, dword ptr [0x58318a]                # 0046bbe1
    mov eax, dword ptr [ebp - local_c]           # 0046bbe7
    mov dword ptr [eax + field_4a18], edx        # 0046bbea
    mov ecx, dword ptr [ebp - local_c]           # 0046bbf0
    mov edx, dword ptr [ecx + field_4a00]        # 0046bbf3
    add edx, dword ptr [0x58318a]                # 0046bbf9
    mov eax, dword ptr [ebp - local_c]           # 0046bbff
    mov dword ptr [eax + field_4a20], edx        # 0046bc02
    mov ecx, dword ptr [ebp - local_c]           # 0046bc08
    mov edx, dword ptr [ecx + field_49f4]        # 0046bc0b
    add edx, dword ptr [0x583186]                # 0046bc11
    mov eax, dword ptr [ebp - local_c]           # 0046bc17
    mov dword ptr [eax + field_4a14], edx        # 0046bc1a
    mov ecx, dword ptr [ebp - local_c]           # 0046bc20
    mov edx, dword ptr [ecx + field_49fc]        # 0046bc23
    add edx, dword ptr [0x583186]                # 0046bc29
    mov eax, dword ptr [ebp - local_c]           # 0046bc2f
    mov dword ptr [eax + field_4a1c], edx        # 0046bc32
    mov ecx, dword ptr [ebp - local_c]           # 0046bc38
    mov edx, dword ptr [ecx + field_49e8]        # 0046bc3b
    add edx, dword ptr [0x58318a]                # 0046bc41
    mov eax, dword ptr [ebp - local_c]           # 0046bc47
    mov dword ptr [eax + field_4a08], edx        # 0046bc4a
    mov ecx, dword ptr [ebp - local_c]           # 0046bc50
    mov edx, dword ptr [ecx + field_49f0]        # 0046bc53
    add edx, dword ptr [0x58318a]                # 0046bc59
    mov eax, dword ptr [ebp - local_c]           # 0046bc5f
    mov dword ptr [eax + field_4a10], edx        # 0046bc62
    mov ecx, dword ptr [ebp - local_c]           # 0046bc68
    mov edx, dword ptr [ecx + field_49e4]        # 0046bc6b
    add edx, dword ptr [0x583186]                # 0046bc71
    mov eax, dword ptr [ebp - local_c]           # 0046bc77
    mov dword ptr [eax + field_4a04], edx        # 0046bc7a
    mov ecx, dword ptr [ebp - local_c]           # 0046bc80
    mov edx, dword ptr [ecx + field_49ec]        # 0046bc83
    add edx, dword ptr [0x583186]                # 0046bc89
    mov eax, dword ptr [ebp - local_c]           # 0046bc8f
    mov dword ptr [eax + field_4a0c], edx        # 0046bc92
    mov ecx, dword ptr [ebp - local_c]           # 0046bc98
    mov dword ptr [ecx + field_4a4c], 0x1        # 0046bc9b
L_0046bca5:
    # block 0x0046bca5: entered by jmp at 0x0046bb17, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046bca5
    pop ebp                                      # 0046bca7
    ret                                          # 0046bca8

