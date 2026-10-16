# FUN_0051d540
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d540
# extent:       0x0051d540-0x0051d55a (26 code bytes)
# span:         0x0051d540-0x0051d55a (code 26, tables 0, padding 0)
# sha256:       e35d954a71e0ebae6987651bb5b3b6b5a59caf5b94ab9a7e93e2c531af2f217f
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d540
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_74
# callees:      calls USER32.dll!GetWindowLongA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------

.org 0x0051d540 - 0x401000
.globl FUN_0051d540
FUN_0051d540:
    # block 0x0051d540: entry, 3 instruction(s), ends with jne to 0x0051d553 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d540
    test eax, eax                                # 0051d543
    jne.d8 L_0051d553                            # 0051d545
    # block 0x0051d547: entered by fall-through of jne at 0x0051d545, 4 instruction(s), calls USER32.dll!GetWindowLongA, ends with ret
    push -0x14                                   # 0051d547
    push dword ptr [ecx + field_1c]              # 0051d549
    call dword ptr [0x52a454]                    # 0051d54c
    ret                                          # 0051d552
L_0051d553:
    # block 0x0051d553: entered by jne at 0x0051d545, 3 instruction(s), ends with indirect jump dword ptr [edx + 0x74]
    mov edx, dword ptr [eax]                     # 0051d553
    {load} mov ecx, eax                          # 0051d555
    jmp dword ptr [edx + field_74]               # 0051d557

