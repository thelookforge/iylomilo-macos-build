# Build the iylomilo macOS installer without owning a Mac

This project includes a GitHub Actions workflow that uses a hosted macOS runner to build the installer. The workflow runs only when you start it manually and uploads the finished `.pkg` as an Actions artifact. It does not publish a release.

## What you need

- A GitHub account and a repository you own
- The contents of this project uploaded to that repository

Keep the repository private if you do not want the source and artwork to be public. GitHub's standard macOS runner is free for public repositories; private repositories use the account's included Actions usage, and extra usage can be billed. See [GitHub Actions billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions).

## Run the build

1. Upload the project files to your own GitHub repository, including the `.github/workflows` folder.
2. Open the repository's **Actions** tab.
3. Select **Build iylomilo macOS installer**, then choose **Run workflow**.
4. When the run finishes, download **iylomilo-1.0-macOS-universal-installer** from the run's **Artifacts** section.

The artifact contains `iylomilo-1.0-macOS-universal.pkg`. It offers AU, VST3, and CLAP components for Apple Silicon and Intel Macs. The package is unsigned and not notarized by Apple.
