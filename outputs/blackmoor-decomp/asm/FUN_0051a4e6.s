# FUN_0051a4e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a4e6
# extent:       0x0051a4e6-0x0051a533 (77 code bytes)
# span:         0x0051a4e6-0x0051a533 (code 77, tables 0, padding 0)
# sha256:       d646f5658fb7229d17622c4f1a1b3ac066ce1626d444956511dcd05b693b3ac1
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a4e6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_minus_c; [esi + n] field_c, field_10, field_14, field_18
# callees:      calls FUN_0051a3d4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0051a3d4, .text + (0x0051a3d4 - 0x401000)

.org 0x0051a4e6 - 0x401000
.globl FUN_0051a4e6
FUN_0051a4e6:
    # block 0x0051a4e6: entry, 4 instruction(s), ends with jne to 0x0051a51e (forward)
    push esi                                     # 0051a4e6
    {load} mov esi, ecx                          # 0051a4e7
    cmp dword ptr [esi + field_10], 0x0          # 0051a4e9
    jne.d8 L_0051a51e                            # 0051a4ed
    # block 0x0051a4ef: entered by fall-through of jne at 0x0051a4ed, 12 instruction(s), calls FUN_0051a3d4, ends with jl to 0x0051a51e (forward)
    push 0xc                                     # 0051a4ef
    lea eax, [esi + field_14]                    # 0051a4f1
    push dword ptr [esi + field_18]              # 0051a4f4
    push eax                                     # 0051a4f7
    call FUN_0051a3d4                            # 0051a4f8
    mov ecx, dword ptr [esi + field_18]          # 0051a4fd
    add eax, 0x4                                 # 0051a500
    lea edx, [ecx + 2*ecx]                       # 0051a503
    dec ecx                                      # 0051a506
    test ecx, ecx                                # 0051a507
    lea eax, [eax + 4*edx - field_minus_c]       # 0051a509
    jl.d8 L_0051a51e                             # 0051a50d
    # block 0x0051a50f: entered by fall-through of jl at 0x0051a50d, 1 instruction(s), falls into the block at 0x0051a510
    inc ecx                                      # 0051a50f
L_0051a510:
    # block 0x0051a510: entered by jne at 0x0051a51c, 6 instruction(s), ends with jne to 0x0051a510 (backward)
    mov edx, dword ptr [esi + field_10]          # 0051a510
    mov dword ptr [eax], edx                     # 0051a513
    mov dword ptr [esi + field_10], eax          # 0051a515
    sub eax, 0xc                                 # 0051a518
    dec ecx                                      # 0051a51b
    jne.d8 L_0051a510                            # 0051a51c
L_0051a51e:
    # block 0x0051a51e: entered by jne at 0x0051a4ed; jl at 0x0051a50d; fall-through of jne at 0x0051a51c, 8 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_10]          # 0051a51e
    mov ecx, dword ptr [eax]                     # 0051a521
    inc dword ptr [esi + field_c]                # 0051a523
    mov dword ptr [esi + field_10], ecx          # 0051a526
    and dword ptr [eax + field_4], 0x0           # 0051a529
    and dword ptr [eax + field_8], 0x0           # 0051a52d
    pop esi                                      # 0051a531
    ret                                          # 0051a532

