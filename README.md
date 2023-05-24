# rl-scanner-docker-action

This action runs a scan with reversinglabs/rl-scanner on a single provided artifact.
This action expects the artifact to be produced in the current github repo.
Its path relative to the root of the github repo is specified as input to the action.

## Inputs

## `my-artifact-to-scan`

**Required** the relative filepath (relative to your github repo)

## Outputs
* `status` The status from rl-scanner

## Artifact
* the scan action produces a new artifact directory in ./.rl_report/report
anything that is in .rl_report will be deletedd during the scan

## Example usage

    -uses: actions/rl-scanner-docker-action@v<some version tag>
    with:
      my-artifact-to-scan: 'README.md'

Will scan the README.md and produce a report in ./.rl_report/report that can be picked up from the repository 
