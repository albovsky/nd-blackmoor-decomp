# FUN_004fa658
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa658
# extent:       0x004fa658-0x004fa881 (553 code bytes)
# span:         0x004fa658-0x004fa8d2 (code 553, tables 81, padding 0)
# sha256:       ba2b4e2941a95f25fc13ac7f812156eeaae68898a2e2db743b0aac80718bd1f1
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# name:         CSound::HResultToDSoundErrorName
# arguments:    thiscall: ecx=this; [ebp+8] = HRESULT value (dword, compared as signed 32-bit); callee pops it with ret 0x4; returns eax = this+0x15e, the address of the buffer that now holds the NUL-terminated DirectSound error name copied from the original image strings (DS_OK for 0, DSERR_* names for the DirectSound codes tested below, or Undefined when no code matches); preserves esi and edi (pushed/popped); clobbers eax, ecx, edx. Matched values: 0 DS_OK; 0x8878000a ALLOCATED; 0x8878001e CONTROLUNAVAIL; 0x80070057 INVALIDPARAM; 0x88780032 INVALIDCALL; 0x80004005 GENERIC; 0x88780046 PRIOLEVELNEEDED; 0x8007000e OUTOFMEMORY; 0x88780064 BADFORMAT; 0x80004001 UNSUPPORTED; 0x88780078 NODRIVER; 0x88780082 ALREADYINITIALIZED; 0x80040110 NOAGGREGATION; 0x88780096 BUFFERLOST; 0x887800a0 OTHERAPPHASPRIO; 0x887800aa UNINITIALIZED; 0x80004002 NOINTERFACE; 0x80070005 ACCESSDENIED. The four values 0x88780046, 0x88780064, 0x88780078 and 0x88780082 go through a jump-table switch (see unverified); the rest through a tree of signed compares. The direction flag is assumed clear for the rep string copies (not set by this routine)
# locals:       [ebp-local_name_ptr] = pointer to the selected NUL-terminated name string (initialised to 0, always overwritten before use); [ebp-local_this] = this (spilled from ecx); [ebp-local_hr_or_offset] = the HRESULT argument copy, overwritten in the switch path with hr + 0x7787ffba (that is hr - 0x88780046 modulo 2^32) before the unsigned bound check and the table lookup
# fields:       this+0x15e: character buffer that receives the name (the NUL-terminated string is copied there, at most 25 bytes: the longest name is DSERR_ALREADYINITIALIZED plus its NUL); the address this+0x15e is returned in eax; no other object fields are read or written (the caller FUN_004fa2a8 reads the last HRESULT from this+0x3ca per its pseudocode, not this routine); no globals written; name strings read from the original image at 0x005602a0 (DS_OK), 0x005602a8, 0x005602b8, 0x005602d0, 0x005602e4, 0x005602f8, 0x00560308, 0x00560320, 0x00560334, 0x00560344, 0x00560358, 0x00560368, 0x00560384, 0x00560398, 0x005603ac, 0x005603c4, 0x005603d8, 0x005603ec and 0x00560400 (Undefined); jump table SWTAB_004fa881 (5 case addresses) and index table IDXTAB_004fa895 (61 byte indexes) of this function are read
# callees:      none
# track-n:      host-adapter: none
# unverified:   Name is my label (the bytes and strings show an HRESULT to DSERR_* name lookup, Track N has no counterpart); the receiver class CSound is inferred from neighbouring batch 001 names (CSound::InitSoundSystem, CSound::LoadDIGISound) and from the caller FUN_004fa2a8 (its pseudocode passes the value at its this+0x3ca; the call site bytes show mov edx,[ecx+0x3ca]; push edx; mov ecx,[ebp-0x3c]; call, so the receiver is the caller saved this) and is not otherwise proven. Switch description: the jmp at 0x004fa765 is the only indirect jump; the index byte table IDXTAB_004fa895 (61 entries, indexed by hr - 0x88780046, bound-checked unsigned against 0x3c) maps offsets 0x00 to case 0 (PRIOLEVELNEEDED), 0x1e to case 1 (BADFORMAT), 0x32 to case 2 (NODRIVER), 0x3c to case 3 (ALREADYINITIALIZED) and every other offset to case 4, which SWTAB_004fa881 sends to the Undefined string like the out-of-range default; I read the index values and the five table targets from the bytes but did not execute the dispatch. The constant values and DirectSound/COM names are matched by number and by the string read at each address, the numbers come from the compares and the names from the original strings; I did not check them against a DirectSound header. The size of the destination buffer at this+0x15e is not known (not checked by the original); the native port needs an explicit bound. Which compares are signed (all jg/jl/je use signed conditions except the ja after the rebase) was read from the instructions, but the ordering of the compare tree was only checked by tracing each constant to its label, not by exhaustive enumeration of all 2^32 inputs.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_name_ptr, 0x4  # [ebp - 0x4]: pointer to the selected name string
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ local_hr_or_offset, 0xc  # [ebp - 0xc]: HRESULT copy; after the rebase, hr - 0x88780046 (mod 2^32) for the table lookup
.equ arg_hresult, 0x8  # [ebp + 0x8]: HRESULT to name (dword)

# --- external targets -----------------------------------------------

.org 0x004fa658 - 0x401000
.globl FUN_004fa658
FUN_004fa658:
    # block 0x004fa658: entry: save esi and edi, local_this = this, local_name_ptr = 0, local_hr = argument; if hr > 0x88780032 (signed) jump to hr_above_invalidcall (jg)
    push ebp                                     # 004fa658
    {load} mov ebp, esp                          # 004fa659
    sub esp, 0xc                                 # 004fa65b
    push esi                                     # 004fa65e
    push edi                                     # 004fa65f
    mov dword ptr [ebp - local_this], ecx           # 004fa660
    mov dword ptr [ebp - local_name_ptr], 0x0           # 004fa663
    mov eax, dword ptr [ebp + arg_hresult]             # 004fa66a
    mov dword ptr [ebp - local_hr_or_offset], eax           # 004fa66d
    cmp dword ptr [ebp - local_hr_or_offset], 0x88780032    # 004fa670
    jg.d32 hr_above_invalidcall                            # 004fa677
    # block 0x004fa67d: hr <= 0x88780032: if hr == 0x88780032 (DSERR_INVALIDCALL) jump to name_invalidcall (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x88780032    # 004fa67d
    je.d32 name_invalidcall                            # 004fa684
    # block 0x004fa68a: if hr > 0x80070005 (signed) jump to hr_above_accessdenied (jg)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80070005    # 004fa68a
    jg.d8 hr_above_accessdenied                             # 004fa691
    # block 0x004fa693: hr <= 0x80070005: if hr == 0x80070005 (E_ACCESSDENIED) jump to name_accessdenied (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80070005    # 004fa693
    je.d32 name_accessdenied                            # 004fa69a
    # block 0x004fa6a0: if hr > 0x80004005 (signed) jump to hr_above_generic (jg)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80004005    # 004fa6a0
    jg.d8 hr_above_generic                             # 004fa6a7
    # block 0x004fa6a9: hr <= 0x80004005: if hr == 0x80004005 (E_FAIL) jump to name_generic (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80004005    # 004fa6a9
    je.d32 name_generic                            # 004fa6b0
    # block 0x004fa6b6: if hr == 0x80004001 (E_NOTIMPL) jump to name_unsupported (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80004001    # 004fa6b6
    je.d32 name_unsupported                            # 004fa6bd
    # block 0x004fa6c3: if hr == 0x80004002 (E_NOINTERFACE) jump to name_nointerface (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80004002    # 004fa6c3
    je.d32 name_nointerface                            # 004fa6ca
    # block 0x004fa6d0: no match in this range: jump to name_undefined
    jmp.d32 name_undefined                           # 004fa6d0
hr_above_generic:
    # block 0x004fa6d5: 0x80004005 < hr <= 0x80070005 (signed): if hr == 0x80040110 (CLASS_E_NOAGGREGATION) jump to name_noaggregation (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80040110    # 004fa6d5
    je.d32 name_noaggregation                            # 004fa6dc
    # block 0x004fa6e2: no match: jump to name_undefined
    jmp.d32 name_undefined                           # 004fa6e2
hr_above_accessdenied:
    # block 0x004fa6e7: 0x80070005 < hr <= 0x88780032 (signed): if hr > 0x8878000a (signed) jump to hr_above_allocated (jg)
    cmp dword ptr [ebp - local_hr_or_offset], 0x8878000a    # 004fa6e7
    jg.d8 hr_above_allocated                             # 004fa6ee
    # block 0x004fa6f0: hr <= 0x8878000a: if hr == 0x8878000a (DSERR_ALLOCATED) jump to name_allocated (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x8878000a    # 004fa6f0
    je.d32 name_allocated                            # 004fa6f7
    # block 0x004fa6fd: if hr == 0x8007000e (E_OUTOFMEMORY) jump to name_outofmemory (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x8007000e    # 004fa6fd
    je.d32 name_outofmemory                            # 004fa704
    # block 0x004fa70a: if hr == 0x80070057 (E_INVALIDARG) jump to name_invalidparam (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x80070057    # 004fa70a
    je.d32 name_invalidparam                            # 004fa711
    # block 0x004fa717: no match: jump to name_undefined
    jmp.d32 name_undefined                           # 004fa717
hr_above_allocated:
    # block 0x004fa71c: 0x8878000a < hr <= 0x88780032: if hr == 0x8878001e (DSERR_CONTROLUNAVAIL) jump to name_controlunavail (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x8878001e    # 004fa71c
    je.d32 name_controlunavail                            # 004fa723
    # block 0x004fa729: no match: jump to name_undefined
    jmp.d32 name_undefined                           # 004fa729
hr_above_invalidcall:
    # block 0x004fa72e: hr > 0x88780032 (signed): if hr > 0x88780096 (signed) jump to hr_above_bufferlost (jg)
    cmp dword ptr [ebp - local_hr_or_offset], 0x88780096    # 004fa72e
    jg.d8 hr_above_bufferlost                             # 004fa735
    # block 0x004fa737: 0x88780032 < hr <= 0x88780096: if hr == 0x88780096 (DSERR_BUFFERLOST) jump to name_bufferlost (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x88780096    # 004fa737
    je.d32 name_bufferlost                            # 004fa73e
    # block 0x004fa744: switch setup: hr_or_offset = hr + 0x7787ffba (= hr - 0x88780046 mod 2^32); if it is above 0x3c unsigned jump to name_undefined (ja); the offsets 0x00..0x3c select the jump table below
    mov ecx, dword ptr [ebp - local_hr_or_offset]           # 004fa744
    add ecx, 0x7787ffba                          # 004fa747
    mov dword ptr [ebp - local_hr_or_offset], ecx           # 004fa74d
    cmp dword ptr [ebp - local_hr_or_offset], 0x3c          # 004fa750
    ja.d32 name_undefined                            # 004fa754
    # block 0x004fa75a: switch dispatch: edx = byte IDXTAB_004fa895[offset] (61 index bytes; offset 0x00 gives 0, 0x1e gives 1, 0x32 gives 2, 0x3c gives 3, all others 4), then jmp dword [SWTAB_004fa881 + 4*index]; the five table targets are name_priolevelneeded, name_badformat, name_nodriver, name_alreadyinitialized and name_undefined
    mov eax, dword ptr [ebp - local_hr_or_offset]           # 004fa75a
    {load} xor edx, edx                          # 004fa75d
    mov dl, byte ptr [eax + IDXTAB_004fa895_VA]  # 004fa75f
    jmp dword ptr [4*edx + SWTAB_004fa881_VA]    # 004fa765
hr_above_bufferlost:
    # block 0x004fa76c: hr > 0x88780096 (signed, this range also contains 0 and positive values): if hr == 0x887800a0 (DSERR_OTHERAPPHASPRIO) jump to name_otherapphasprio (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x887800a0    # 004fa76c
    je.d32 name_otherapphasprio                            # 004fa773
    # block 0x004fa779: if hr == 0x887800aa (DSERR_UNINITIALIZED) jump to name_uninitialized (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x887800aa    # 004fa779
    je.d32 name_uninitialized                            # 004fa780
    # block 0x004fa786: if hr == 0 (DS_OK) jump to name_ds_ok (je)
    cmp dword ptr [ebp - local_hr_or_offset], 0x0           # 004fa786
    je.d8 name_ds_ok                             # 004fa78a
    # block 0x004fa78c: no match: jump to name_undefined
    jmp.d32 name_undefined                           # 004fa78c
name_ds_ok:
    # block 0x004fa791: name = 0x5602a0 (DS_OK); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602a0      # 004fa791
    jmp.d32 copy_name                           # 004fa798
name_allocated:
    # block 0x004fa79d: name = 0x5602a8 (DSERR_ALLOCATED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602a8      # 004fa79d
    jmp.d32 copy_name                           # 004fa7a4
name_controlunavail:
    # block 0x004fa7a9: name = 0x5602b8 (DSERR_CONTROLUNAVAIL); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602b8      # 004fa7a9
    jmp.d32 copy_name                           # 004fa7b0
name_invalidparam:
    # block 0x004fa7b5: name = 0x5602d0 (DSERR_INVALIDPARAM); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602d0      # 004fa7b5
    jmp.d32 copy_name                           # 004fa7bc
name_invalidcall:
    # block 0x004fa7c1: name = 0x5602e4 (DSERR_INVALIDCALL); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602e4      # 004fa7c1
    jmp.d8 copy_name                            # 004fa7c8
name_generic:
    # block 0x004fa7ca: name = 0x5602f8 (DSERR_GENERIC); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5602f8      # 004fa7ca
    jmp.d8 copy_name                            # 004fa7d1
name_priolevelneeded:
    # block 0x004fa7d3: switch case 0 (hr 0x88780046): name = 0x560308 (DSERR_PRIOLEVELNEEDED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560308      # 004fa7d3
    jmp.d8 copy_name                            # 004fa7da
name_outofmemory:
    # block 0x004fa7dc: name = 0x560320 (DSERR_OUTOFMEMORY); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560320      # 004fa7dc
    jmp.d8 copy_name                            # 004fa7e3
name_badformat:
    # block 0x004fa7e5: switch case 1 (hr 0x88780064): name = 0x560334 (DSERR_BADFORMAT); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560334      # 004fa7e5
    jmp.d8 copy_name                            # 004fa7ec
name_unsupported:
    # block 0x004fa7ee: name = 0x560344 (DSERR_UNSUPPORTED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560344      # 004fa7ee
    jmp.d8 copy_name                            # 004fa7f5
name_nodriver:
    # block 0x004fa7f7: switch case 2 (hr 0x88780078): name = 0x560358 (DSERR_NODRIVER); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560358      # 004fa7f7
    jmp.d8 copy_name                            # 004fa7fe
name_alreadyinitialized:
    # block 0x004fa800: switch case 3 (hr 0x88780082): name = 0x560368 (DSERR_ALREADYINITIALIZED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560368      # 004fa800
    jmp.d8 copy_name                            # 004fa807
name_noaggregation:
    # block 0x004fa809: name = 0x560384 (DSERR_NOAGGREGATION); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560384      # 004fa809
    jmp.d8 copy_name                            # 004fa810
name_bufferlost:
    # block 0x004fa812: name = 0x560398 (DSERR_BUFFERLOST); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560398      # 004fa812
    jmp.d8 copy_name                            # 004fa819
name_otherapphasprio:
    # block 0x004fa81b: name = 0x5603ac (DSERR_OTHERAPPHASPRIO); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5603ac      # 004fa81b
    jmp.d8 copy_name                            # 004fa822
name_uninitialized:
    # block 0x004fa824: name = 0x5603c4 (DSERR_UNINITIALIZED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5603c4      # 004fa824
    jmp.d8 copy_name                            # 004fa82b
name_nointerface:
    # block 0x004fa82d: name = 0x5603d8 (DSERR_NOINTERFACE); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5603d8      # 004fa82d
    jmp.d8 copy_name                            # 004fa834
name_accessdenied:
    # block 0x004fa836: name = 0x5603ec (DSERR_ACCESSDENIED); jump to copy_name
    mov dword ptr [ebp - local_name_ptr], 0x5603ec      # 004fa836
    jmp.d8 copy_name                            # 004fa83d
name_undefined:
    # block 0x004fa83f: default and switch case 4: name = 0x560400 (Undefined); falls into copy_name
    mov dword ptr [ebp - local_name_ptr], 0x560400      # 004fa83f
copy_name:
    # block 0x004fa846: copy_name: strlen by repne scasb over the name (ecx = length including the NUL), copy those bytes to this+0x15e with rep movsd (length >> 2 dwords) then rep movsb (length & 3 bytes), eax = this+0x15e, restore edi and esi, return popping the argument (ret 4)
    mov edi, dword ptr [ebp - local_name_ptr]           # 004fa846
    mov ecx, dword ptr [ebp - local_this]           # 004fa849
    add ecx, 0x15e                               # 004fa84c
    {load} mov edx, ecx                          # 004fa852
    or ecx, -0x1                                 # 004fa854
    {load} xor eax, eax                          # 004fa857
    repne scasb al, byte ptr es:[edi]            # 004fa859
    not ecx                                      # 004fa85b
    {load} sub edi, ecx                          # 004fa85d
    {load} mov esi, edi                          # 004fa85f
    {load} mov eax, ecx                          # 004fa861
    {load} mov edi, edx                          # 004fa863
    shr ecx, 0x2                                 # 004fa865
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fa868
    {load} mov ecx, eax                          # 004fa86a
    and ecx, 0x3                                 # 004fa86c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fa86f
    mov eax, dword ptr [ebp - local_this]           # 004fa871
    add eax, 0x15e                               # 004fa874
    pop edi                                      # 004fa879
    pop esi                                      # 004fa87a
    {load} mov esp, ebp                          # 004fa87b
    pop ebp                                      # 004fa87d
    ret 0x4                                      # 004fa87e

# --- data items (not part of the function) -------------------------
.org 0x004fa881 - 0x401000
SWTAB_004fa881:  # 5 case address(es)
    .long name_priolevelneeded - .text + 0x401000
    .long name_badformat - .text + 0x401000
    .long name_nodriver - .text + 0x401000
    .long name_alreadyinitialized - .text + 0x401000
    .long name_undefined - .text + 0x401000
.org 0x004fa895 - 0x401000
IDXTAB_004fa895:  # index table of FUN_004fa658 for the switch jump at 0x004fa765 (61 byte(s))
    .byte 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3
.set SWTAB_004fa881_VA, SWTAB_004fa881 - .text + 0x401000
.set IDXTAB_004fa895_VA, IDXTAB_004fa895 - .text + 0x401000
