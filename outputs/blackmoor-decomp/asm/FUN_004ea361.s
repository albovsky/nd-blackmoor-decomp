# FUN_004ea361
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea361
# extent:       0x004ea361-0x004ea3a0 (63 code bytes)
# span:         0x004ea361-0x004ea3a0 (code 63, tables 0, padding 0)
# sha256:       b2a63d0aadbe7c4c446aec6e1794939c62c25d77ec8fd5906ebd594aa8917970
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_timed_dismiss_check
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.c:1077 says "0x4ea361: unsigned "deadline < clock"."; tasks/S05-2-framed-text-box-lifecycle.md:22 says "The timed dismiss on `0x571442` (`0x4ea361`"
# name-note:    Timed dismiss check: true when the armed deadline is below the clock (unsigned).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8256; [ecx + n] field_8286
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8256, 0x8256  # offset +0x8256
.equ field_8286, 0x8286  # offset +0x8286

# --- external targets -----------------------------------------------

.org 0x004ea361 - 0x401000
.globl FUN_004ea361
FUN_004ea361:
    # block 0x004ea361: entry, 7 instruction(s), ends with je to 0x004ea39c (forward)
    push ebp                                     # 004ea361
    {load} mov ebp, esp                          # 004ea362
    push ecx                                     # 004ea364
    mov dword ptr [ebp - local_4], ecx           # 004ea365
    mov eax, dword ptr [ebp - local_4]           # 004ea368
    cmp dword ptr [eax + field_8256], 0x0        # 004ea36b
    je.d8 L_004ea39c                             # 004ea372
    # block 0x004ea374: entered by fall-through of je at 0x004ea372, 4 instruction(s), ends with jae to 0x004ea39c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ea374
    mov edx, dword ptr [ecx + field_8286]        # 004ea377
    cmp edx, dword ptr [0x585d37]                # 004ea37d
    jae.d8 L_004ea39c                            # 004ea383
    # block 0x004ea385: entered by fall-through of jae at 0x004ea383, 3 instruction(s), falls into the block at 0x004ea39c
    mov eax, dword ptr [ebp - local_4]           # 004ea385
    mov dword ptr [eax + field_8256], 0x0        # 004ea388
    mov dword ptr [0x5b1602], 0x1                # 004ea392
L_004ea39c:
    # block 0x004ea39c: entered by je at 0x004ea372; jae at 0x004ea383, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ea39c
    pop ebp                                      # 004ea39e
    ret                                          # 004ea39f

