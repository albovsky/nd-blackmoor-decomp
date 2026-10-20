# FUN_0051d526
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d526
# extent:       0x0051d526-0x0051d540 (26 code bytes)
# span:         0x0051d526-0x0051d540 (code 26, tables 0, padding 0)
# sha256:       fc1302e6020eff4721830c7ecd4cdbd7d8d0c5feb74f9d5dc2033987dda7d230
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_GetWindowLongA
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists USER32.dll!GetWindowLongA as the only import of the 26-byte function and no callee
# name-note:    A 26-byte leaf function with no direct callee whose only external call is USER32.dll!GetWindowLongA
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_70
# callees:      calls USER32.dll!GetWindowLongA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------

.org 0x0051d526 - 0x401000
.globl FUN_0051d526
FUN_0051d526:
    # block 0x0051d526: entry, 3 instruction(s), ends with jne to 0x0051d539 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d526
    test eax, eax                                # 0051d529
    jne.d8 L_0051d539                            # 0051d52b
    # block 0x0051d52d: entered by fall-through of jne at 0x0051d52b, 4 instruction(s), calls USER32.dll!GetWindowLongA, ends with ret
    push -0x10                                   # 0051d52d
    push dword ptr [ecx + field_1c]              # 0051d52f
    call dword ptr [0x52a454]                    # 0051d532
    ret                                          # 0051d538
L_0051d539:
    # block 0x0051d539: entered by jne at 0x0051d52b, 3 instruction(s), ends with indirect jump dword ptr [edx + 0x70]
    mov edx, dword ptr [eax]                     # 0051d539
    {load} mov ecx, eax                          # 0051d53b
    jmp dword ptr [edx + field_70]               # 0051d53d

