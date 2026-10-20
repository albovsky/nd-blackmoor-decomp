# FUN_00525b86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525b86
# extent:       0x00525b86-0x00525bb3 (45 code bytes)
# span:         0x00525b86-0x00525bb3 (code 45, tables 0, padding 0)
# sha256:       52dbbc2513aa836c25f7d11e05233cbbff025f07c8825acc48213bf0fc72d98f
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_TlsGetValue
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!TlsGetValue as the only import of the 45-byte function and no callee
# name-note:    A 45-byte leaf function with no direct callee whose only external call is KERNEL32.dll!TlsGetValue
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c
# callees:      calls KERNEL32.dll!TlsGetValue
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00525b86 - 0x401000
.globl FUN_00525b86
FUN_00525b86:
    # block 0x00525b86: entry, 4 instruction(s), ends with je to 0x00525baf (forward)
    push esi                                     # 00525b86
    mov esi, dword ptr [ecx]                     # 00525b87
    test esi, esi                                # 00525b89
    je.d8 L_00525baf                             # 00525b8b
    # block 0x00525b8d: entered by fall-through of je at 0x00525b8b, 3 instruction(s), ends with je to 0x00525baf (forward)
    mov eax, dword ptr [0x63c704]                # 00525b8d
    test eax, eax                                # 00525b92
    je.d8 L_00525baf                             # 00525b94
    # block 0x00525b96: entered by fall-through of je at 0x00525b94, 4 instruction(s), calls KERNEL32.dll!TlsGetValue, ends with je to 0x00525baf (forward)
    push dword ptr [eax]                         # 00525b96
    call dword ptr [0x52a0dc]                    # 00525b98
    test eax, eax                                # 00525b9e
    je.d8 L_00525baf                             # 00525ba0
    # block 0x00525ba2: entered by fall-through of je at 0x00525ba0, 2 instruction(s), ends with jge to 0x00525baf (forward)
    cmp esi, dword ptr [eax + field_8]           # 00525ba2
    jge.d8 L_00525baf                            # 00525ba5
    # block 0x00525ba7: entered by fall-through of jge at 0x00525ba5, 4 instruction(s), ends with ret
    mov eax, dword ptr [eax + field_c]           # 00525ba7
    mov eax, dword ptr [eax + 4*esi]             # 00525baa
    pop esi                                      # 00525bad
    ret                                          # 00525bae
L_00525baf:
    # block 0x00525baf: entered by je at 0x00525b8b; je at 0x00525b94; je at 0x00525ba0; jge at 0x00525ba5, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00525baf
    pop esi                                      # 00525bb1
    ret                                          # 00525bb2

