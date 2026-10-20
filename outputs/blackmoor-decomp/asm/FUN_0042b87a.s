# FUN_0042b87a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042b87a
# extent:       0x0042b87a-0x0042ba22 (424 code bytes)
# span:         0x0042b87a-0x0042ba3a (code 424, tables 24, padding 0)
# sha256:       7d408c4cb1ab5f9324cd498d5e8837176eeb497f2291d42c0dfb32dacd070880
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42b87a_apply_record
# naming:       native port src/original_methods_fl20a.c:m42b87a_apply_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m42b87a_apply_record. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 424 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1, field_3
# callees:      calls FUN_004d3c5f, FUN_004d3c88, KERNEL32.dll!GetTickCount, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m42b87a_apply_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 89 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_3, 0x3  # offset +0x3
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004d3c5f, .text + (0x004d3c5f - 0x401000)
.set FUN_004d3c88, .text + (0x004d3c88 - 0x401000)

.org 0x0042b87a - 0x401000
.globl FUN_0042b87a
FUN_0042b87a:
    # block 0x0042b87a: entry, 14 instruction(s), ends with ja to 0x0042b9e4 (forward)
    push ebp                                     # 0042b87a
    {load} mov ebp, esp                          # 0042b87b
    push ecx                                     # 0042b87d
    movsx eax, word ptr [ebp + arg_8]            # 0042b87e
    imul eax, eax, 0x8d                          # 0042b882
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b888
    {load} xor edx, edx                          # 0042b88e
    mov dl, byte ptr [ecx]                       # 0042b890
    mov dword ptr [ebp - local_4], edx           # 0042b892
    mov eax, dword ptr [ebp - local_4]           # 0042b895
    sub eax, 0x1                                 # 0042b898
    mov dword ptr [ebp - local_4], eax           # 0042b89b
    cmp dword ptr [ebp - local_4], 0x5           # 0042b89e
    ja.d32 L_0042b9e4                            # 0042b8a2
    # block 0x0042b8a8: entered by fall-through of ja at 0x0042b8a2, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x42ba22]
    mov ecx, dword ptr [ebp - local_4]           # 0042b8a8
    jmp dword ptr [4*ecx + SWTAB_0042ba22_VA]    # 0042b8ab
L_0042b8b2:
    # block 0x0042b8b2: entered by switch case, 11 instruction(s), ends with forward jump to 0x0042b9e4
    movsx edx, word ptr [ebp + arg_8]            # 0042b8b2
    imul edx, edx, 0x8d                          # 0042b8b6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b8bc
    mov cx, word ptr [eax + field_1]             # 0042b8c2
    mov word ptr [0x585d51], cx                  # 0042b8c6
    movsx edx, word ptr [ebp + arg_8]            # 0042b8cd
    imul edx, edx, 0x8d                          # 0042b8d1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b8d7
    mov cx, word ptr [eax + field_3]             # 0042b8dd
    mov word ptr [0x585d4f], cx                  # 0042b8e1
    jmp.d32 L_0042b9e4                           # 0042b8e8
L_0042b8ed:
    # block 0x0042b8ed: entered by switch case, 13 instruction(s), ends with forward jump to 0x0042b9e4
    movsx edx, word ptr [ebp + arg_8]            # 0042b8ed
    imul edx, edx, 0x8d                          # 0042b8f1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b8f7
    mov cx, word ptr [0x585d51]                  # 0042b8fd
    add cx, word ptr [eax + field_1]             # 0042b904
    mov word ptr [0x585d51], cx                  # 0042b908
    movsx edx, word ptr [ebp + arg_8]            # 0042b90f
    imul edx, edx, 0x8d                          # 0042b913
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b919
    mov cx, word ptr [0x585d4f]                  # 0042b91f
    add cx, word ptr [eax + field_3]             # 0042b926
    mov word ptr [0x585d4f], cx                  # 0042b92a
    jmp.d32 L_0042b9e4                           # 0042b931
L_0042b936:
    # block 0x0042b936: entered by switch case, 3 instruction(s), calls FUN_004d3c5f, ends with forward jump to 0x0042b9e4
    mov ecx, 0x61c387                            # 0042b936
    call FUN_004d3c5f                            # 0042b93b
    jmp.d32 L_0042b9e4                           # 0042b940
L_0042b945:
    # block 0x0042b945: entered by switch case, 3 instruction(s), calls FUN_004d3c88, ends with forward jump to 0x0042b9e4
    mov ecx, 0x61c387                            # 0042b945
    call FUN_004d3c88                            # 0042b94a
    jmp.d32 L_0042b9e4                           # 0042b94f
L_0042b954:
    # block 0x0042b954: entered by switch case, 13 instruction(s), calls FUN_004d3c88, ends with forward jump to 0x0042b9e4
    mov ecx, 0x61c387                            # 0042b954
    call FUN_004d3c88                            # 0042b959
    movsx edx, word ptr [ebp + arg_8]            # 0042b95e
    imul edx, edx, 0x8d                          # 0042b962
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b968
    mov cx, word ptr [eax + field_1]             # 0042b96e
    mov word ptr [0x585d51], cx                  # 0042b972
    movsx edx, word ptr [ebp + arg_8]            # 0042b979
    imul edx, edx, 0x8d                          # 0042b97d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b983
    mov cx, word ptr [eax + field_3]             # 0042b989
    mov word ptr [0x585d4f], cx                  # 0042b98d
    jmp.d8 L_0042b9e4                            # 0042b994
L_0042b996:
    # block 0x0042b996: entered by switch case, 14 instruction(s), calls FUN_004d3c88, falls into the block at 0x0042b9e4
    mov ecx, 0x61c387                            # 0042b996
    call FUN_004d3c88                            # 0042b99b
    movsx edx, word ptr [ebp + arg_8]            # 0042b9a0
    imul edx, edx, 0x8d                          # 0042b9a4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b9aa
    mov cx, word ptr [0x585d51]                  # 0042b9b0
    add cx, word ptr [eax + field_1]             # 0042b9b7
    mov word ptr [0x585d51], cx                  # 0042b9bb
    movsx edx, word ptr [ebp + arg_8]            # 0042b9c2
    imul edx, edx, 0x8d                          # 0042b9c6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b9cc
    mov cx, word ptr [0x585d4f]                  # 0042b9d2
    add cx, word ptr [eax + field_3]             # 0042b9d9
    mov word ptr [0x585d4f], cx                  # 0042b9dd
L_0042b9e4:
    # block 0x0042b9e4: entered by ja at 0x0042b8a2; jmp at 0x0042b8e8; jmp at 0x0042b931; jmp at 0x0042b940; more, 16 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0042ba3a, ends with ret
    movsx edx, word ptr [0x585d51]               # 0042b9e4
    imul edx, edx, 0x3c                          # 0042b9eb
    movsx eax, word ptr [0x585d4f]               # 0042b9ee
    {load} add edx, eax                          # 0042b9f5
    mov dword ptr [0x585d4b], edx                # 0042b9f7
    call dword ptr [0x52a23c]                    # 0042b9fd
    movsx ecx, word ptr [0x5b0280]               # 0042ba03
    {load} add eax, ecx                          # 0042ba0a
    mov dword ptr [0x585d55], eax                # 0042ba0c
    mov dx, word ptr [ebp + arg_8]               # 0042ba11
    push edx                                     # 0042ba15
    call FUN_0042ba3a                            # 0042ba16
    add esp, 0x4                                 # 0042ba1b
    {load} mov esp, ebp                          # 0042ba1e
    pop ebp                                      # 0042ba20
    ret                                          # 0042ba21

# --- data items (not part of the function) -------------------------
.org 0x0042ba22 - 0x401000
SWTAB_0042ba22:  # 6 case address(es)
    .long L_0042b8b2 - .text + 0x401000
    .long L_0042b8ed - .text + 0x401000
    .long L_0042b936 - .text + 0x401000
    .long L_0042b945 - .text + 0x401000
    .long L_0042b954 - .text + 0x401000
    .long L_0042b996 - .text + 0x401000
.set SWTAB_0042ba22_VA, SWTAB_0042ba22 - .text + 0x401000

