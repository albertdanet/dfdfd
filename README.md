# STRIKE FORCE — iOS game project

Native SwiftUI arcade target-shooting game for iPhone and iPad.

## Build through GitHub Actions
1. Upload the CONTENTS of this folder into the root of your repository. Keep `.github/workflows/build.yml`.
2. Commit to `main`.
3. Open Actions → Build STRIKE FORCE IPA.
4. Open the successful run and download `STRIKE-FORCE-IPA-UNSIGNED` from Artifacts.

IMPORTANT: this workflow produces an **unsigned IPA**. The artifact is an actual iOS app package, but iOS normally will not install it until it is signed with an Apple Developer certificate and a matching provisioning profile. The workflow builds on GitHub's macOS runner, so you do not need a Mac locally.
