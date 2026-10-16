# FUN_00519daa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519daa
# extent:       0x00519daa-0x00519dc9 (31 code bytes)
# span:         0x00519daa-0x00519dc9 (code 31, tables 0, padding 0)
# sha256:       8731300b8d62095c1c25721246b11ab650d4d1408e8e54c175e39365563c53a1
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519daa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_5c; [esp + n] stk_8
# callees:      calls FUN_0051e08b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0051e08b, .text + (0x0051e08b - 0x401000)

.org 0x00519daa - 0x401000
.globl FUN_00519daa
FUN_00519daa:
    # block 0x00519daa: entry, 11 instruction(s), calls FUN_0051e08b, ends with ret 0x4
    push esi                                     # 00519daa
    push 0x0                                     # 00519dab
    {load} mov esi, ecx                          # 00519dad
    push 0x0                                     # 00519daf
    call FUN_0051e08b                            # 00519db1
    mov eax, dword ptr [esp + stk_8]             # 00519db6
    mov dword ptr [esi], 0x52ffec                # 00519dba
    mov dword ptr [esi + field_5c], eax          # 00519dc0
    {load} mov eax, esi                          # 00519dc3
    pop esi                                      # 00519dc5
    ret 0x4                                      # 00519dc6

