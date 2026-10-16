# FUN_0051fb2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fb2e
# extent:       0x0051fb2e-0x0051fb55 (39 code bytes)
# span:         0x0051fb2e-0x0051fb55 (code 39, tables 0, padding 0)
# sha256:       89fe77f85ae3388846689f482fd165a28a9a387f66ee86bfcb29feeda0f59e7f
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fb2e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esp + n] stk_10
# callees:      calls FUN_00525371, USER32.dll!LoadStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051fb2e - 0x401000
.globl FUN_0051fb2e
FUN_0051fb2e:
    # block 0x0051fb2e: entry, 11 instruction(s), calls FUN_00525371, USER32.dll!LoadStringA, ends with jne to 0x0051fb51 (forward)
    push esi                                     # 0051fb2e
    call FUN_00525371                            # 0051fb2f
    push dword ptr [esp + stk_10]                # 0051fb34
    mov esi, dword ptr [esp + stk_10]            # 0051fb38
    mov eax, dword ptr [eax + field_c]           # 0051fb3c
    push esi                                     # 0051fb3f
    push dword ptr [esp + stk_10]                # 0051fb40
    push eax                                     # 0051fb44
    call dword ptr [0x52a4d4]                    # 0051fb45
    test eax, eax                                # 0051fb4b
    jne.d8 L_0051fb51                            # 0051fb4d
    # block 0x0051fb4f: entered by fall-through of jne at 0x0051fb4d, 1 instruction(s), falls into the block at 0x0051fb51
    and byte ptr [esi], al                       # 0051fb4f
L_0051fb51:
    # block 0x0051fb51: entered by jne at 0x0051fb4d, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 0051fb51
    ret 0xc                                      # 0051fb52

