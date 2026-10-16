# FUN_0051a267
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a267
# extent:       0x0051a267-0x0051a28e (39 code bytes)
# span:         0x0051a267-0x0051a28e (code 39, tables 0, padding 0)
# sha256:       ec18a8fdae6eb4e5ab5a9d2f26850a735b66f998630ff3446a06ec497f871958
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a267
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8; [esi + n] field_1; [esp + n] stk_8, stk_10
# callees:      calls FUN_0051a14e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051a14e, .text + (0x0051a14e - 0x401000)

.org 0x0051a267 - 0x401000
.globl FUN_0051a267
FUN_0051a267:
    # block 0x0051a267: entry, 6 instruction(s), ends with jl to 0x0051a27f (forward)
    push esi                                     # 0051a267
    mov esi, dword ptr [esp + stk_8]             # 0051a268
    push edi                                     # 0051a26c
    {load} mov edi, ecx                          # 0051a26d
    cmp esi, dword ptr [edi + field_8]           # 0051a26f
    jl.d8 L_0051a27f                             # 0051a272
    # block 0x0051a274: entered by fall-through of jl at 0x0051a272, 4 instruction(s), calls FUN_0051a14e, falls into the block at 0x0051a27f
    lea eax, [esi + field_1]                     # 0051a274
    push -0x1                                    # 0051a277
    push eax                                     # 0051a279
    call FUN_0051a14e                            # 0051a27a
L_0051a27f:
    # block 0x0051a27f: entered by jl at 0x0051a272, 6 instruction(s), ends with ret 0x8
    mov eax, dword ptr [edi + field_4]           # 0051a27f
    mov ecx, dword ptr [esp + stk_10]            # 0051a282
    pop edi                                      # 0051a286
    mov dword ptr [eax + 4*esi], ecx             # 0051a287
    pop esi                                      # 0051a28a
    ret 0x8                                      # 0051a28b

