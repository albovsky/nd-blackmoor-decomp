# Signing setup for Glib

The package can be built locally without signing credentials. That produces an
explicitly labeled ad-hoc DMG, which does not pass Gatekeeper on a fresh Mac.
Do not upload this derived game binary, the DMG or generated C to any public host.

1. Join the [Apple Developer Program](https://developer.apple.com/programs/), or
   use your existing membership. In Xcode's account settings or your developer
   account, create a **Developer ID Application** certificate. Install it with its
   private key in your login keychain. An Apple Development certificate is not
   sufficient. Check available identities:

   ```sh
   security find-identity -v -p codesigning
   ```

2. Store notarization credentials in your own keychain. Choose a profile name
   such as `blackmoor-notary`. Run this locally and answer Apple's prompts for
   your Apple ID, team ID and app-specific password:

   ```sh
   xcrun notarytool store-credentials blackmoor-notary
   ```

   Do not put passwords, API keys or profile contents in this repository, shell
   scripts, chat or build logs. Do not use shell tracing while packaging.

3. Export exactly these two selections, using the certificate's identity hash
   from step 1 and the profile name from step 2:

   ```sh
   export BLACKMOOR_SIGN_IDENTITY="YOUR_DEVELOPER_ID_IDENTITY_HASH"
   export BLACKMOOR_NOTARY_PROFILE="blackmoor-notary"
   ```

4. Build from your own supported GAME.EXE:

   ```sh
   GAME_EXE="/absolute/path/to/your/GAME.EXE" script/package_macos.sh
   ```

   With Developer ID, the script signs every nested binary inside-out with hardened runtime and no
   extra entitlements. It submits to Apple with `notarytool submit --wait`,
   requires **Accepted**, staples and validates the app, makes the DMG, then
   notarizes and staples the DMG. It verifies signatures and Gatekeeper assessment
   and prints the local DMG's path, SHA-256 and size. With both selections absent,
   it produces the ad-hoc fallback. Identity alone produces a signed, unnotarized
   build that still needs notarization; a profile alone or invalid supplied
   credentials fails visibly. Only an exact Developer ID Application name or
   certificate identity hash is accepted.
   The ad-hoc fallback omits hardened runtime: library validation rejects shared
   libraries without a Developer ID team. No entitlement disables library validation.

5. Keep the DMG on your disk for your own Macs and testers you name. Confirm a
   quarantined copy passes Gatekeeper on another Mac before relying on that
   platform result. No account is created and no second Mac is accessed by this
   workflow. Public distribution remains your separate decision.

See Apple's [notarization workflow](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
and [Developer ID guidance](https://developer.apple.com/developer-id/).
