# FUN_0051b4cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b4cb
# extent:       0x0051b4cb-0x0051b522 (87 code bytes)
# span:         0x0051b4cb-0x0051b522 (code 87, tables 0, padding 0)
# sha256:       40182a457069aec44879727b76a4d7cd31bacd1313fff4b450dc01cebc2d9f9c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b4ac (+0x1f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b4cb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c, field_dc; [esi + n] field_cc, field_108; [esp + n] stk_8
# callees:      calls FUN_0052513f, USER32.dll!SendMessageA, USER32.dll!GetKeyState; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_cc, 0xcc  # offset +0xcc
.equ field_dc, 0xdc  # offset +0xdc
.equ field_108, 0x108  # offset +0x108

# --- external targets -----------------------------------------------
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x0051b4cb - 0x401000
.globl FUN_0051b4cb
FUN_0051b4cb:
    # block 0x0051b4cb: entry, 6 instruction(s), calls FUN_0052513f, ends with je to 0x0051b4f4 (forward)
    push esi                                     # 0051b4cb
    call FUN_0052513f                            # 0051b4cc
    {load} mov esi, eax                          # 0051b4d1
    mov eax, dword ptr [esi + field_cc]          # 0051b4d3
    test eax, eax                                # 0051b4d9
    je.d8 L_0051b4f4                             # 0051b4db
    # block 0x0051b4dd: entered by fall-through of je at 0x0051b4db, 3 instruction(s), ends with je to 0x0051b4f4 (forward)
    mov eax, dword ptr [eax + field_1c]          # 0051b4dd
    test eax, eax                                # 0051b4e0
    je.d8 L_0051b4f4                             # 0051b4e2
    # block 0x0051b4e4: entered by fall-through of je at 0x0051b4e2, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051b4f4
    push 0x0                                     # 0051b4e4
    push 0x0                                     # 0051b4e6
    push 0x401                                   # 0051b4e8
    push eax                                     # 0051b4ed
    call dword ptr [0x52a4c8]                    # 0051b4ee
L_0051b4f4:
    # block 0x0051b4f4: entered by je at 0x0051b4db; je at 0x0051b4e2, 3 instruction(s), ends with je to 0x0051b51e (forward)
    cmp dword ptr [esp + stk_8], 0x0             # 0051b4f4
    mov esi, dword ptr [esi + field_108]         # 0051b4f9
    je.d8 L_0051b51e                             # 0051b4ff
    # block 0x0051b501: entered by fall-through of je at 0x0051b4ff, 2 instruction(s), ends with je to 0x0051b51e (forward)
    test esi, esi                                # 0051b501
    je.d8 L_0051b51e                             # 0051b503
    # block 0x0051b505: entered by fall-through of je at 0x0051b503, 4 instruction(s), calls USER32.dll!GetKeyState, ends with jl to 0x0051b51e (forward)
    push 0x1                                     # 0051b505
    call dword ptr [0x52a4b8]                    # 0051b507
    test ax, ax                                  # 0051b50d
    jl.d8 L_0051b51e                             # 0051b510
    # block 0x0051b512: entered by fall-through of jl at 0x0051b510, 4 instruction(s), calls indirect dword ptr [eax + 0xdc], falls into the block at 0x0051b51e
    mov eax, dword ptr [esi]                     # 0051b512
    push -0x1                                    # 0051b514
    {load} mov ecx, esi                          # 0051b516
    call dword ptr [eax + field_dc]              # 0051b518
L_0051b51e:
    # block 0x0051b51e: entered by je at 0x0051b4ff; je at 0x0051b503; jl at 0x0051b510, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051b51e
    ret 0x4                                      # 0051b51f

