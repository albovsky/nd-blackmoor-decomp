# FUN_0051a2cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a2cd
# extent:       0x0051a2cd-0x0051a2ed (32 code bytes)
# span:         0x0051a2cd-0x0051a2ed (code 32, tables 0, padding 0)
# sha256:       88720531559382271f4beb30b115fe78c9025fd426a3b3ab0d49ba972214acdf
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a2cd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10, field_14
# callees:      calls FUN_0051a3f4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051a3f4, .text + (0x0051a3f4 - 0x401000)

.org 0x0051a2cd - 0x401000
.globl FUN_0051a2cd
FUN_0051a2cd:
    # block 0x0051a2cd: entry, 14 instruction(s), calls FUN_0051a3f4, ends with ret
    push esi                                     # 0051a2cd
    {load} mov esi, ecx                          # 0051a2ce
    push edi                                     # 0051a2d0
    {load} xor edi, edi                          # 0051a2d1
    mov ecx, dword ptr [esi + field_14]          # 0051a2d3
    mov dword ptr [esi + field_c], edi           # 0051a2d6
    mov dword ptr [esi + field_10], edi          # 0051a2d9
    mov dword ptr [esi + field_8], edi           # 0051a2dc
    mov dword ptr [esi + field_4], edi           # 0051a2df
    call FUN_0051a3f4                            # 0051a2e2
    mov dword ptr [esi + field_14], edi          # 0051a2e7
    pop edi                                      # 0051a2ea
    pop esi                                      # 0051a2eb
    ret                                          # 0051a2ec

