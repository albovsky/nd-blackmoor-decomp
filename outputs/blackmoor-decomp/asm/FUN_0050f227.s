# FUN_0050f227
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f227
# extent:       0x0050f227-0x0050f253 (44 code bytes)
# span:         0x0050f227-0x0050f253 (code 44, tables 0, padding 0)
# sha256:       8cc073e4161c512ba0dc2a7bb381d401f4f08e67cba8d2176b495fd552a36df1
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f227
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_1; [esp + n] stk_4, stk_8, stk_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050f227 - 0x401000
.globl FUN_0050f227
FUN_0050f227:
    # block 0x0050f227: entry, 5 instruction(s), ends with je to 0x0050f251 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050f227
    mov ecx, dword ptr [esp + stk_8]             # 0050f22b
    {load} cmp eax, ecx                          # 0050f22f
    push esi                                     # 0050f231
    je.d8 L_0050f251                             # 0050f232
    # block 0x0050f234: entered by fall-through of je at 0x0050f232, 5 instruction(s), ends with je to 0x0050f251 (forward)
    mov edx, dword ptr [esp + stk_10]            # 0050f234
    {load} mov esi, edx                          # 0050f238
    dec edx                                      # 0050f23a
    test esi, esi                                # 0050f23b
    je.d8 L_0050f251                             # 0050f23d
    # block 0x0050f23f: entered by fall-through of je at 0x0050f23d, 2 instruction(s), falls into the block at 0x0050f243
    push ebx                                     # 0050f23f
    lea esi, [edx + field_1]                     # 0050f240
L_0050f243:
    # block 0x0050f243: entered by jne at 0x0050f24e, 8 instruction(s), ends with jne to 0x0050f243 (backward)
    mov bl, byte ptr [ecx]                       # 0050f243
    mov dl, byte ptr [eax]                       # 0050f245
    mov byte ptr [eax], bl                       # 0050f247
    inc eax                                      # 0050f249
    mov byte ptr [ecx], dl                       # 0050f24a
    inc ecx                                      # 0050f24c
    dec esi                                      # 0050f24d
    jne.d8 L_0050f243                            # 0050f24e
    # block 0x0050f250: entered by fall-through of jne at 0x0050f24e, 1 instruction(s), falls into the block at 0x0050f251
    pop ebx                                      # 0050f250
L_0050f251:
    # block 0x0050f251: entered by je at 0x0050f232; je at 0x0050f23d, 2 instruction(s), ends with ret
    pop esi                                      # 0050f251
    ret                                          # 0050f252

