#! /bin/bash -l

# we must have the mandatory environment variables:
# RLSECURE_ENCODED_LICENSE=<base64 encoded license file>
# RLSECURE_SITE_KEY=<site key>

# we may have the environment variables:
# RLSECURE_PROXY_SERVER	Optional. Server URL for local proxy configuration.
# RLSECURE_PROXY_PORT	Optional. Network port for local proxy configuration.
# RLSECURE_PROXY_USER	Optional. User name for proxy authentication.
# RLSECURE_PROXY_PASSWORD	Optional. Password for proxy authentication.

# we need a mandatory input path to a single articat we will scan
# test if the file is readabole and not zero in length

EXIT_FATAL=101

fatal()
{
    local msg="$1"
    echo "status=FATAL: ${msg}" >>${GITHUB_OUTPUT}
    exit ${EXIT_FATAL}
}

testInputArtifactToScan()
{
    local item="$1"

    [ ! -f "$item" ] && {
        fatal "file not found: '$item'"
    }

    [ ! -r "$item" ] && {
        fatal "file not readable: '$item'"
    }

    [ ! -s "$item" ] && {
        fatal "file has zero length: '$item'"
    }

    INPUT_FILE_TO_SCAN="${item}"
}

testEnvVarsMandatory()
{
    [ -z "${RLSECURE_ENCODED_LICENSE}" ] && {
        fatal "no value provided for mandatory environment variable: 'RLSECURE_ENCODED_LICENSE'"
    }

    [ -z "${RLSECURE_SITE_KEY}" ] && {
        echo "no value provided for mandatory environment variable: 'RLSECURE_SITE_KEY'"
    }
}

main()
{
    testEnvVarsMandatory
    testInputArtifactToScan $*

    rm -rf .rl_report
    mkdir .rl_report

    rl-scan \
        --package-path=$1 \
        --report-path=.rl_report \
        --report-format=all 2>/tmp/2 1>/tmp/1
    RR=$?
    cat /tmp/1

    # EOF delim should be random
    EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
    echo "status<<$EOF"         >>${GITHUB_OUTPUT}
    grep "Scan result:" /tmp/1  >>${GITHUB_OUTPUT}
    echo "$EOF"                 >>${GITHUB_OUTPUT}

    exit $RR
}

# we pass all args to the function
main $*
