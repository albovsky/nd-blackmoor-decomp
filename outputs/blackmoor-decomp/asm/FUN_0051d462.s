# FUN_0051d462
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d462
# extent:       0x0051d462-0x0051d48c (42 code bytes)
# span:         0x0051d462-0x0051d48c (code 42, tables 0, padding 0)
# sha256:       f9c355ef78f1a4ca37f64c0f2db8d43ae840a884f83db61cd60a2f888c8efe88
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d462
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_34; [edx + n] field_70; [esp + n] stk_4
# callees:      calls USER32.dll!GetDlgItem, FUN_0051abe4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0051d462 - 0x401000
.globl FUN_0051d462
FUN_0051d462:
    # block 0x0051d462: entry, 3 instruction(s), ends with jne to 0x0051d47e (forward)
    mov eax, dword ptr [ecx + field_34]          # 0051d462
    test eax, eax                                # 0051d465
    jne.d8 L_0051d47e                            # 0051d467
    # block 0x0051d469: entered by fall-through of jne at 0x0051d467, 6 instruction(s), calls USER32.dll!GetDlgItem, FUN_0051abe4, ends with forward jump to 0x0051d489
    push dword ptr [esp + stk_4]                 # 0051d469
    push dword ptr [ecx + field_1c]              # 0051d46d
    call dword ptr [0x52a404]                    # 0051d470
    push eax                                     # 0051d476
    call FUN_0051abe4                            # 0051d477
    jmp.d8 L_0051d489                            # 0051d47c
L_0051d47e:
    # block 0x0051d47e: entered by jne at 0x0051d467, 4 instruction(s), calls indirect dword ptr [edx + 0x70], falls into the block at 0x0051d489
    mov edx, dword ptr [eax]                     # 0051d47e
    push dword ptr [esp + stk_4]                 # 0051d480
    {load} mov ecx, eax                          # 0051d484
    call dword ptr [edx + field_70]              # 0051d486
L_0051d489:
    # block 0x0051d489: entered by jmp at 0x0051d47c, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051d489

