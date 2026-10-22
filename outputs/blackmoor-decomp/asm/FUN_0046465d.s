# FUN_0046465d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046465d
# extent:       0x0046465d-0x00464792 (309 code bytes)
# span:         0x0046465d-0x00464792 (code 309, tables 0, padding 0)
# sha256:       1e7059da459fba46f603abcf357ce3d05b95e42b74932364b6c8bf2a3f1ec3e9
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46465d_lifted
# naming:       native port src/original_methods_fl40.c:m46465d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 101/101 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_3a, field_3e, field_42, field_46, field_52, field_5a, field_5e, field_62, field_66, field_ca, field_ce, field_d2 and 1 more; [ecx + n] field_4a, field_4e, field_52, field_56, field_6a, field_6e, field_72, field_76, field_c2, field_c6; [edx + n] field_4a, field_4e, field_c2, field_c6, field_d2
# callees:      calls FUN_0046458e, FUN_0046453b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46465d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 101 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_3a, 0x3a  # offset +0x3a
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
.equ field_c2, 0xc2  # offset +0xc2
.equ field_c6, 0xc6  # offset +0xc6
.equ field_ca, 0xca  # offset +0xca
.equ field_ce, 0xce  # offset +0xce
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d4, 0xd4  # offset +0xd4

# --- external targets -----------------------------------------------
.set FUN_0046453b, .text + (0x0046453b - 0x401000)
.set FUN_0046458e, .text + (0x0046458e - 0x401000)

.org 0x0046465d - 0x401000
.globl FUN_0046465d
FUN_0046465d:
    # block 0x0046465d: entry, 101 instruction(s), calls FUN_0046458e, FUN_0046453b, ends with ret
    push ebp                                     # 0046465d
    {load} mov ebp, esp                          # 0046465e
    sub esp, 0xc                                 # 00464660
    mov dword ptr [ebp - local_c], ecx           # 00464663
    mov eax, dword ptr [ebp - local_c]           # 00464666
    mov ecx, dword ptr [ebp - local_c]           # 00464669
    mov eax, dword ptr [eax + field_ca]          # 0046466c
    sub eax, dword ptr [ecx + field_c2]          # 00464672
    cdq                                          # 00464678
    {load} sub eax, edx                          # 00464679
    sar eax                                      # 0046467b
    mov edx, dword ptr [ebp - local_c]           # 0046467d
    add eax, dword ptr [edx + field_c2]          # 00464680
    mov dword ptr [ebp - local_8], eax           # 00464686
    mov eax, dword ptr [ebp - local_c]           # 00464689
    mov ecx, dword ptr [ebp - local_c]           # 0046468c
    mov eax, dword ptr [eax + field_ce]          # 0046468f
    sub eax, dword ptr [ecx + field_c6]          # 00464695
    cdq                                          # 0046469b
    {load} sub eax, edx                          # 0046469c
    sar eax                                      # 0046469e
    mov edx, dword ptr [ebp - local_c]           # 004646a0
    add eax, dword ptr [edx + field_c6]          # 004646a3
    mov dword ptr [ebp - local_4], eax           # 004646a9
    mov eax, dword ptr [ebp - local_c]           # 004646ac
    mov ecx, dword ptr [ebp - local_c]           # 004646af
    mov edx, dword ptr [ecx + field_4e]          # 004646b2
    mov dword ptr [eax + field_3e], edx          # 004646b5
    mov eax, dword ptr [ebp - local_c]           # 004646b8
    mov ecx, dword ptr [ebp - local_c]           # 004646bb
    mov edx, dword ptr [ecx + field_56]          # 004646be
    mov dword ptr [eax + field_46], edx          # 004646c1
    mov eax, dword ptr [ebp - local_c]           # 004646c4
    mov ecx, dword ptr [ebp - local_c]           # 004646c7
    mov edx, dword ptr [ecx + field_4a]          # 004646ca
    mov dword ptr [eax + field_3a], edx          # 004646cd
    mov eax, dword ptr [ebp - local_c]           # 004646d0
    mov ecx, dword ptr [ebp - local_c]           # 004646d3
    mov edx, dword ptr [ecx + field_52]          # 004646d6
    mov dword ptr [eax + field_42], edx          # 004646d9
    mov eax, dword ptr [ebp - local_c]           # 004646dc
    mov ecx, dword ptr [ebp - local_c]           # 004646df
    mov edx, dword ptr [ecx + field_6e]          # 004646e2
    mov dword ptr [eax + field_5e], edx          # 004646e5
    mov eax, dword ptr [ebp - local_c]           # 004646e8
    mov ecx, dword ptr [ebp - local_c]           # 004646eb
    mov edx, dword ptr [ecx + field_76]          # 004646ee
    mov dword ptr [eax + field_66], edx          # 004646f1
    mov eax, dword ptr [ebp - local_c]           # 004646f4
    mov ecx, dword ptr [ebp - local_c]           # 004646f7
    mov edx, dword ptr [ecx + field_6a]          # 004646fa
    mov dword ptr [eax + field_5a], edx          # 004646fd
    mov eax, dword ptr [ebp - local_c]           # 00464700
    mov ecx, dword ptr [ebp - local_c]           # 00464703
    mov edx, dword ptr [ecx + field_72]          # 00464706
    mov dword ptr [eax + field_62], edx          # 00464709
    mov eax, dword ptr [ebp - local_c]           # 0046470c
    movsx eax, word ptr [eax + field_d4]         # 0046470f
    cdq                                          # 00464716
    {load} sub eax, edx                          # 00464717
    sar eax                                      # 00464719
    mov ecx, dword ptr [ebp - local_4]           # 0046471b
    {load} sub ecx, eax                          # 0046471e
    mov edx, dword ptr [ebp - local_c]           # 00464720
    mov dword ptr [edx + field_4e], ecx          # 00464723
    mov eax, dword ptr [ebp - local_c]           # 00464726
    movsx eax, word ptr [eax + field_d2]         # 00464729
    cdq                                          # 00464730
    {load} sub eax, edx                          # 00464731
    sar eax                                      # 00464733
    mov ecx, dword ptr [ebp - local_8]           # 00464735
    {load} sub ecx, eax                          # 00464738
    mov edx, dword ptr [ebp - local_c]           # 0046473a
    mov dword ptr [edx + field_4a], ecx          # 0046473d
    mov eax, dword ptr [ebp - local_c]           # 00464740
    movsx ecx, word ptr [eax + field_d4]         # 00464743
    mov edx, dword ptr [ebp - local_c]           # 0046474a
    mov eax, dword ptr [edx + field_4e]          # 0046474d
    {load} add eax, ecx                          # 00464750
    mov ecx, dword ptr [ebp - local_c]           # 00464752
    mov dword ptr [ecx + field_56], eax          # 00464755
    mov edx, dword ptr [ebp - local_c]           # 00464758
    movsx eax, word ptr [edx + field_d2]         # 0046475b
    mov ecx, dword ptr [ebp - local_c]           # 00464762
    mov edx, dword ptr [ecx + field_4a]          # 00464765
    {load} add edx, eax                          # 00464768
    mov eax, dword ptr [ebp - local_c]           # 0046476a
    mov dword ptr [eax + field_52], edx          # 0046476d
    mov ecx, dword ptr [ebp - local_c]           # 00464770
    call FUN_0046458e                            # 00464773
    mov ecx, dword ptr [ebp - local_c]           # 00464778
    add ecx, 0x6a                                # 0046477b
    push ecx                                     # 0046477e
    mov edx, dword ptr [ebp - local_c]           # 0046477f
    add edx, 0x4a                                # 00464782
    push edx                                     # 00464785
    mov ecx, dword ptr [ebp - local_c]           # 00464786
    call FUN_0046453b                            # 00464789
    {load} mov esp, ebp                          # 0046478e
    pop ebp                                      # 00464790
    ret                                          # 00464791

