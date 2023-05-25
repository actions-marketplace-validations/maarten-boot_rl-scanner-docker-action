# rl-scanner-docker-action

This action runs a scan with reversinglabs/rl-scanner on a single provided artifact.
This action expects the artifact to be produced in the current github repo.
Its path relative to the root of the github repo is specified as input to the action.

## Environment
The reversinglabs/rl-scanner will require the licence data to be passed via the environment with the pre set names:
* RLSECURE_SITE_KEY
* RLSECURE_ENCODED_LICENSE

The most secure way is to define secrets on the organisational or repository level.

## Inputs

## `my-artifact-to-scan`

**Required** the relative filepath (relative to your github repo)

## Outputs
* `status` The status from rl-scanner

## Artifact
* the scan action produces a new artifact directory in ./.rl_report/report
anything that is in .rl_report will be deletedd during the scan

## Example usage

### Scan
    # run the action
    - name: run the reversinglabs/rl-scanner
      id: scan
      env: # Or as an environment variable
        RLSECURE_ENCODED_LICENSE: ${{ secrets.RLSECURE_ENCODED_LICENSE }}
        RLSECURE_SITE_KEY: ${{ secrets.RLSECURE_SITE_KEY }}
      uses: maarten-boot/rl-scanner-docker-action@v3.10
      with:
        my-artifact-to-scan: 'README.md'

Will scan the README.md and produce a report in ./.rl_report/report that can be picked up from the repository 

### Status
You can pickup the status of the scan with:
As we always produce a status even when the scan step detects a error (and fails),
you should place a explicit if condition as shown so that the status always gets extracted on PASS and FAIL of the scan.

    # -------------------------------------
    # Use the output from the scan step
    - name: Get the scan status output
      if: success() || failure()
      run: |
        echo "The status is: '${{ steps.scan.outputs.status }}'"

### Report
The report can be extracted as artifact with the upload-artifact action step.
As we always produce a report even when the scan step detects a error (and fails),
you should place a explicit if condition as shown so that the report always gets uploaded on PASS and FAIL of the scan.

    # -------------------------------------
    - name: Archive Report
      if: success() || failure()
      uses: actions/upload-artifact@v3
      with:
        name: report
        path: .rl_report
