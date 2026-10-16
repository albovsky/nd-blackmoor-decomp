# FUN_00522953
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522953
# extent:       0x00522953-0x00522979 (38 code bytes)
# span:         0x00522953-0x00522979 (code 38, tables 0, padding 0)
# sha256:       513f0bdcb85bfb53a0e55edb2fff6ebd61b95cf0839332d4b5da65726d1751f9
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522953
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esi + n] field_48; [esp + n] stk_8
# callees:      calls FUN_00525371, USER32.dll!LoadAcceleratorsA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00522979
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00522953 - 0x401000
.globl FUN_00522953
FUN_00522953:
    # block 0x00522953: entry, 14 instruction(s), calls FUN_00525371, USER32.dll!LoadAcceleratorsA, ends with ret 0x4
    push esi                                     # 00522953
    {load} mov esi, ecx                          # 00522954
    call FUN_00525371                            # 00522956
    push dword ptr [esp + stk_8]                 # 0052295b
    mov eax, dword ptr [eax + field_c]           # 0052295f
    push eax                                     # 00522962
    call dword ptr [0x52a378]                    # 00522963
    {load} xor ecx, ecx                          # 00522969
    mov dword ptr [esi + field_48], eax          # 0052296b
    test eax, eax                                # 0052296e
    setne cl                                     # 00522970
    {load} mov eax, ecx                          # 00522973
    pop esi                                      # 00522975
    ret 0x4                                      # 00522976

