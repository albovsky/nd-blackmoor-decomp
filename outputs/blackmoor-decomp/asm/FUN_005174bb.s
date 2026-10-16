# FUN_005174bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005174bb
# extent:       0x005174bb-0x005175de (291 code bytes)
# span:         0x005174bb-0x005175de (code 291, tables 0, padding 0)
# sha256:       0d6eab16db1271a5fa56491e73e7bff562843eff74115e48ec0932d091a2a4d2
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005174bb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_5, field_8, field_480; [esi + n] field_4, field_8, field_c, field_480; [esp + n] stk_10, stk_14
# callees:      calls FUN_00512c18, KERNEL32.dll!InitializeCriticalSection, FUN_00512c79, KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!LeaveCriticalSection, FUN_0050ea90, FUN_0051771b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 103 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_480, 0x480  # offset +0x480

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)

.org 0x005174bb - 0x401000
.globl FUN_005174bb
FUN_005174bb:
    # block 0x005174bb: entry, 14 instruction(s), calls FUN_00512c18, falls into the block at 0x005174db
    push ecx                                     # 005174bb
    push ecx                                     # 005174bc
    push ebx                                     # 005174bd
    push ebp                                     # 005174be
    push esi                                     # 005174bf
    push edi                                     # 005174c0
    push 0x12                                    # 005174c1
    or edi, -0x1                                 # 005174c3
    call FUN_00512c18                            # 005174c6
    {load} xor ebx, ebx                          # 005174cb
    pop ecx                                      # 005174cd
    mov dword ptr [esp + stk_10], ebx            # 005174ce
    mov dword ptr [esp + stk_14], ebx            # 005174d2
    mov ebp, 0x63cde0                            # 005174d6
L_005174db:
    # block 0x005174db: entered by jl at 0x00517577, 3 instruction(s), ends with je to 0x0051757f (forward)
    {disp8} mov esi, dword ptr [ebp]             # 005174db
    test esi, esi                                # 005174de
    je.d32 L_0051757f                            # 005174e0
    # block 0x005174e6: entered by fall-through of je at 0x005174e0, 1 instruction(s), falls into the block at 0x005174ec
    lea eax, [esi + field_480]                   # 005174e6
L_005174ec:
    # block 0x005174ec: entered by jmp at 0x00517545, 2 instruction(s), ends with jae to 0x00517564 (forward)
    {load} cmp esi, eax                          # 005174ec
    jae.d8 L_00517564                            # 005174ee
    # block 0x005174f0: entered by fall-through of jae at 0x005174ee, 2 instruction(s), ends with jne to 0x0051753a (forward)
    test byte ptr [esi + field_4], 0x1           # 005174f0
    jne.d8 L_0051753a                            # 005174f4
    # block 0x005174f6: entered by fall-through of jne at 0x005174f4, 2 instruction(s), ends with jne to 0x0051751f (forward)
    cmp dword ptr [esi + field_8], 0x0           # 005174f6
    jne.d8 L_0051751f                            # 005174fa
    # block 0x005174fc: entered by fall-through of jne at 0x005174fa, 5 instruction(s), calls FUN_00512c18, ends with jne to 0x00517517 (forward)
    push 0x11                                    # 005174fc
    call FUN_00512c18                            # 005174fe
    cmp dword ptr [esi + field_8], 0x0           # 00517503
    pop ecx                                      # 00517507
    jne.d8 L_00517517                            # 00517508
    # block 0x0051750a: entered by fall-through of jne at 0x00517508, 4 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, falls into the block at 0x00517517
    lea eax, [esi + field_c]                     # 0051750a
    push eax                                     # 0051750d
    call dword ptr [0x52a0b4]                    # 0051750e
    inc dword ptr [esi + field_8]                # 00517514
L_00517517:
    # block 0x00517517: entered by jne at 0x00517508, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x0051751f
    push 0x11                                    # 00517517
    call FUN_00512c79                            # 00517519
    pop ecx                                      # 0051751e
L_0051751f:
    # block 0x0051751f: entered by jne at 0x005174fa, 5 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with je to 0x00517547 (forward)
    lea ebx, [esi + field_c]                     # 0051751f
    push ebx                                     # 00517522
    call dword ptr [0x52a0d0]                    # 00517523
    test byte ptr [esi + field_4], 0x1           # 00517529
    je.d8 L_00517547                             # 0051752d
    # block 0x0051752f: entered by fall-through of je at 0x0051752d, 3 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, falls into the block at 0x0051753a
    push ebx                                     # 0051752f
    call dword ptr [0x52a0c8]                    # 00517530
    mov ebx, dword ptr [esp + stk_10]            # 00517536
L_0051753a:
    # block 0x0051753a: entered by jne at 0x005174f4, 4 instruction(s), ends with backward jump to 0x005174ec
    {disp8} mov eax, dword ptr [ebp]             # 0051753a
    add esi, 0x24                                # 0051753d
    add eax, 0x480                               # 00517540
    jmp.d8 L_005174ec                            # 00517545
L_00517547:
    # block 0x00517547: entered by je at 0x0051752d, 11 instruction(s), ends with jne to 0x005175cd (forward)
    or dword ptr [esi], -0x1                     # 00517547
    {load} mov eax, esi                          # 0051754a
    {disp8} sub eax, dword ptr [ebp]             # 0051754c
    push 0x24                                    # 0051754f
    pop ecx                                      # 00517551
    cdq                                          # 00517552
    idiv ecx                                     # 00517553
    {load} mov edi, eax                          # 00517555
    add edi, dword ptr [esp + stk_14]            # 00517557
    cmp edi, -0x1                                # 0051755b
    jne.d8 L_005175cd                            # 0051755e
    # block 0x00517560: entered by fall-through of jne at 0x0051755e, 1 instruction(s), falls into the block at 0x00517564
    mov ebx, dword ptr [esp + stk_10]            # 00517560
L_00517564:
    # block 0x00517564: entered by jae at 0x005174ee, 6 instruction(s), ends with jl to 0x005174db (backward)
    add dword ptr [esp + stk_14], 0x20           # 00517564
    add ebp, 0x4                                 # 00517569
    inc ebx                                      # 0051756c
    cmp ebp, 0x63cee0                            # 0051756d
    mov dword ptr [esp + stk_10], ebx            # 00517573
    jl.d32 L_005174db                            # 00517577
    # block 0x0051757d: entered by fall-through of jl at 0x00517577, 1 instruction(s), ends with forward jump to 0x005175cd
    jmp.d8 L_005175cd                            # 0051757d
L_0051757f:
    # block 0x0051757f: entered by je at 0x005174e0, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x005175cd (forward)
    mov esi, 0x480                               # 0051757f
    push esi                                     # 00517584
    call FUN_0050ea90                            # 00517585
    test eax, eax                                # 0051758a
    pop ecx                                      # 0051758c
    je.d8 L_005175cd                             # 0051758d
    # block 0x0051758f: entered by fall-through of je at 0x0051758d, 4 instruction(s), falls into the block at 0x005175a5
    add dword ptr [0x63cee0], 0x20               # 0051758f
    lea ecx, [4*ebx + 0x63cde0]                  # 00517596
    lea edx, [eax + field_480]                   # 0051759d
    mov dword ptr [ecx], eax                     # 005175a3
L_005175a5:
    # block 0x005175a5: entered by jmp at 0x005175bf, 2 instruction(s), ends with jae to 0x005175c1 (forward)
    {load} cmp eax, edx                          # 005175a5
    jae.d8 L_005175c1                            # 005175a7
    # block 0x005175a9: entered by fall-through of jae at 0x005175a7, 8 instruction(s), ends with backward jump to 0x005175a5
    and byte ptr [eax + field_4], 0x0            # 005175a9
    or dword ptr [eax], -0x1                     # 005175ad
    and dword ptr [eax + field_8], 0x0           # 005175b0
    mov byte ptr [eax + field_5], 0xa            # 005175b4
    mov edx, dword ptr [ecx]                     # 005175b8
    add eax, 0x24                                # 005175ba
    {load} add edx, esi                          # 005175bd
    jmp.d8 L_005175a5                            # 005175bf
L_005175c1:
    # block 0x005175c1: entered by jae at 0x005175a7, 5 instruction(s), calls FUN_0051771b, falls into the block at 0x005175cd
    shl ebx, 0x5                                 # 005175c1
    {load} mov edi, ebx                          # 005175c4
    push edi                                     # 005175c6
    call FUN_0051771b                            # 005175c7
    pop ecx                                      # 005175cc
L_005175cd:
    # block 0x005175cd: entered by jne at 0x0051755e; jmp at 0x0051757d; je at 0x0051758d, 11 instruction(s), calls FUN_00512c79, ends with ret
    push 0x12                                    # 005175cd
    call FUN_00512c79                            # 005175cf
    pop ecx                                      # 005175d4
    {load} mov eax, edi                          # 005175d5
    pop edi                                      # 005175d7
    pop esi                                      # 005175d8
    pop ebp                                      # 005175d9
    pop ebx                                      # 005175da
    pop ecx                                      # 005175db
    pop ecx                                      # 005175dc
    ret                                          # 005175dd

