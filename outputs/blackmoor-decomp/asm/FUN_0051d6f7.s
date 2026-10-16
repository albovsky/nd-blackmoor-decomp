# FUN_0051d6f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d6f7
# extent:       0x0051d6f7-0x0051d716 (31 code bytes)
# span:         0x0051d6f7-0x0051d716 (code 31, tables 0, padding 0)
# sha256:       d23b3da04e8bdf251e07a5749f32058dd37f01d6406a4f0d3fa491b87f5cd402
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d6f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_34; [ecx + n] field_38; [edx + n] field_8c; [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------

.org 0x0051d6f7 - 0x401000
.globl FUN_0051d6f7
FUN_0051d6f7:
    # block 0x0051d6f7: entry, 2 instruction(s), ends with jne to 0x0051d713 (forward)
    cmp dword ptr [ecx + field_38], 0x0          # 0051d6f7
    jne.d8 L_0051d713                            # 0051d6fb
    # block 0x0051d6fd: entered by fall-through of jne at 0x0051d6fb, 4 instruction(s), ends with je to 0x0051d713 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051d6fd
    mov eax, dword ptr [eax + field_34]          # 0051d701
    test eax, eax                                # 0051d704
    je.d8 L_0051d713                             # 0051d706
    # block 0x0051d708: entered by fall-through of je at 0x0051d706, 4 instruction(s), calls indirect dword ptr [edx + 0x8c], falls into the block at 0x0051d713
    mov edx, dword ptr [eax]                     # 0051d708
    push ecx                                     # 0051d70a
    {load} mov ecx, eax                          # 0051d70b
    call dword ptr [edx + field_8c]              # 0051d70d
L_0051d713:
    # block 0x0051d713: entered by jne at 0x0051d6fb; je at 0x0051d706, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051d713

