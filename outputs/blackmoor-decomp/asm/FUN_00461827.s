# FUN_00461827
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461827
# extent:       0x00461827-0x00461862 (59 code bytes)
# span:         0x00461827-0x00461862 (code 59, tables 0, padding 0)
# sha256:       1bd18922c37ba4cb8d906cfb0b3783f0529acc9a1e9898b8a0092aafa1a56515
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m461827_cleanup
# naming:       native port src/original_methods_fl17.c:m461827_cleanup (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m461827_cleanup; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 59 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_43; [ecx + n] field_1c, field_47; [edx + n] field_3f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:cpz_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_47, 0x47  # offset +0x47

# --- external targets -----------------------------------------------

.org 0x00461827 - 0x401000
.globl FUN_00461827
FUN_00461827:
    # block 0x00461827: entry, 17 instruction(s), ends with ret
    push ebp                                     # 00461827
    {load} mov ebp, esp                          # 00461828
    push ecx                                     # 0046182a
    mov dword ptr [ebp - local_4], ecx           # 0046182b
    mov eax, dword ptr [ebp - local_4]           # 0046182e
    mov word ptr [eax + field_1e], 0xffff        # 00461831
    mov ecx, dword ptr [ebp - local_4]           # 00461837
    mov word ptr [ecx + field_1c], 0xffff        # 0046183a
    mov edx, dword ptr [ebp - local_4]           # 00461840
    mov dword ptr [edx + field_3f], 0x0          # 00461843
    mov eax, dword ptr [ebp - local_4]           # 0046184a
    mov dword ptr [eax + field_43], 0x0          # 0046184d
    mov ecx, dword ptr [ebp - local_4]           # 00461854
    mov dword ptr [ecx + field_47], 0x0          # 00461857
    {load} mov esp, ebp                          # 0046185e
    pop ebp                                      # 00461860
    ret                                          # 00461861

