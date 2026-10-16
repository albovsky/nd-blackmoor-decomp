# FUN_0051a316
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a316
# extent:       0x0051a316-0x0051a36e (88 code bytes)
# span:         0x0051a316-0x0051a36e (code 88, tables 0, padding 0)
# sha256:       bbc873d384ed2f5bb3726a9f67cbfc1bc146ca21d1280bac3235138bd68928a0
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a316
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_minus_c; [esi + n] field_c, field_10, field_14, field_18; [esp + n] stk_8, stk_c
# callees:      calls FUN_0051a3d4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0051a3d4, .text + (0x0051a3d4 - 0x401000)

.org 0x0051a316 - 0x401000
.globl FUN_0051a316
FUN_0051a316:
    # block 0x0051a316: entry, 4 instruction(s), ends with jne to 0x0051a34e (forward)
    push esi                                     # 0051a316
    {load} mov esi, ecx                          # 0051a317
    cmp dword ptr [esi + field_10], 0x0          # 0051a319
    jne.d8 L_0051a34e                            # 0051a31d
    # block 0x0051a31f: entered by fall-through of jne at 0x0051a31d, 12 instruction(s), calls FUN_0051a3d4, ends with jl to 0x0051a34e (forward)
    push 0xc                                     # 0051a31f
    lea eax, [esi + field_14]                    # 0051a321
    push dword ptr [esi + field_18]              # 0051a324
    push eax                                     # 0051a327
    call FUN_0051a3d4                            # 0051a328
    mov ecx, dword ptr [esi + field_18]          # 0051a32d
    add eax, 0x4                                 # 0051a330
    lea edx, [ecx + 2*ecx]                       # 0051a333
    dec ecx                                      # 0051a336
    test ecx, ecx                                # 0051a337
    lea eax, [eax + 4*edx - field_minus_c]       # 0051a339
    jl.d8 L_0051a34e                             # 0051a33d
    # block 0x0051a33f: entered by fall-through of jl at 0x0051a33d, 1 instruction(s), falls into the block at 0x0051a340
    inc ecx                                      # 0051a33f
L_0051a340:
    # block 0x0051a340: entered by jne at 0x0051a34c, 6 instruction(s), ends with jne to 0x0051a340 (backward)
    mov edx, dword ptr [esi + field_10]          # 0051a340
    mov dword ptr [eax], edx                     # 0051a343
    mov dword ptr [esi + field_10], eax          # 0051a345
    sub eax, 0xc                                 # 0051a348
    dec ecx                                      # 0051a34b
    jne.d8 L_0051a340                            # 0051a34c
L_0051a34e:
    # block 0x0051a34e: entered by jne at 0x0051a31d; jl at 0x0051a33d; fall-through of jne at 0x0051a34c, 11 instruction(s), ends with ret 0x8
    mov eax, dword ptr [esi + field_10]          # 0051a34e
    mov ecx, dword ptr [eax]                     # 0051a351
    mov dword ptr [esi + field_10], ecx          # 0051a353
    mov ecx, dword ptr [esp + stk_8]             # 0051a356
    mov dword ptr [eax + field_4], ecx           # 0051a35a
    mov ecx, dword ptr [esp + stk_c]             # 0051a35d
    mov dword ptr [eax], ecx                     # 0051a361
    inc dword ptr [esi + field_c]                # 0051a363
    and dword ptr [eax + field_8], 0x0           # 0051a366
    pop esi                                      # 0051a36a
    ret 0x8                                      # 0051a36b

