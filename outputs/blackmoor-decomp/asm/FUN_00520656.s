# FUN_00520656
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520656
# extent:       0x00520656-0x005206f4 (158 code bytes)
# span:         0x00520656-0x005206f4 (code 158, tables 0, padding 0)
# sha256:       bf00c8f1103a0253f48cc03050efbd060f06247a1c6f291f28c45a789bb02012
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520656
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_minus_8; [ebp + n] field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18; [edi + n] field_1; [esi + n] field_4, field_8, field_c, field_10
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_00525371, USER32.dll!wsprintfA, FUN_005262f7, FUN_0051e8a7, FUN_0051e7ba, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e8a7, .text + (0x0051e8a7 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_005262f7, .text + (0x005262f7 - 0x401000)

.org 0x00520656 - 0x401000
.globl FUN_00520656
FUN_00520656:
    # block 0x00520656: entry, 19 instruction(s), calls FUN_0050f978, FUN_0051dc43, FUN_00525371, ends with jle to 0x005206dd (forward)
    mov eax, 0x529228                            # 00520656
    call FUN_0050f978                            # 0052065b
    sub esp, 0xc                                 # 00520660
    push esi                                     # 00520663
    {load} mov esi, ecx                          # 00520664
    push edi                                     # 00520666
    mov eax, dword ptr [esi + field_10]          # 00520667
    mov eax, dword ptr [eax - field_minus_8]     # 0052066a
    add eax, 0x5                                 # 0052066d
    push eax                                     # 00520670
    call FUN_0051dc43                            # 00520671
    pop ecx                                      # 00520676
    mov dword ptr [ebp - field_minus_10], eax    # 00520677
    call FUN_00525371                            # 0052067a
    mov eax, dword ptr [eax + field_4]           # 0052067f
    {load} xor edi, edi                          # 00520682
    cmp dword ptr [esi + field_4], edi           # 00520684
    mov dword ptr [ebp - field_minus_14], eax    # 00520687
    jle.d8 L_005206dd                            # 0052068a
    # block 0x0052068c: entered by fall-through of jle at 0x0052068a, 1 instruction(s), falls into the block at 0x0052068d
    push ebx                                     # 0052068c
L_0052068d:
    # block 0x0052068d: entered by jl at 0x005206da, 26 instruction(s), calls USER32.dll!wsprintfA, FUN_005262f7, FUN_0051e8a7, FUN_0051e7ba, ends with jl to 0x0052068d (backward)
    mov eax, dword ptr [esi + field_10]          # 0052068d
    lea ebx, [edi + field_1]                     # 00520690
    push ebx                                     # 00520693
    push eax                                     # 00520694
    push dword ptr [ebp - field_minus_10]        # 00520695
    call dword ptr [0x52a3e8]                    # 00520698
    mov eax, dword ptr [esi + field_c]           # 0052069e
    add esp, 0xc                                 # 005206a1
    mov ecx, dword ptr [ebp - field_minus_14]    # 005206a4
    push 0x63c418                                # 005206a7
    push dword ptr [ebp - field_minus_10]        # 005206ac
    push eax                                     # 005206af
    lea eax, [ebp - field_minus_18]              # 005206b0
    push eax                                     # 005206b3
    call FUN_005262f7                            # 005206b4
    and dword ptr [ebp - field_minus_4], 0x0     # 005206b9
    push eax                                     # 005206bd
    mov eax, dword ptr [esi + field_8]           # 005206be
    lea ecx, [eax + 4*edi]                       # 005206c1
    call FUN_0051e8a7                            # 005206c4
    or dword ptr [ebp - field_minus_4], -0x1     # 005206c9
    lea ecx, [ebp - field_minus_18]              # 005206cd
    call FUN_0051e7ba                            # 005206d0
    {load} mov edi, ebx                          # 005206d5
    cmp edi, dword ptr [esi + field_4]           # 005206d7
    jl.d8 L_0052068d                             # 005206da
    # block 0x005206dc: entered by fall-through of jl at 0x005206da, 1 instruction(s), falls into the block at 0x005206dd
    pop ebx                                      # 005206dc
L_005206dd:
    # block 0x005206dd: entered by jle at 0x0052068a, 9 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp - field_minus_10]        # 005206dd
    call FUN_0051dc6c                            # 005206e0
    pop ecx                                      # 005206e5
    pop edi                                      # 005206e6
    mov ecx, dword ptr [ebp - field_minus_c]     # 005206e7
    pop esi                                      # 005206ea
    mov dword ptr fs:[0x0], ecx                  # 005206eb
    leave                                        # 005206f2
    ret                                          # 005206f3

