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

testInputArtifactToScan()
{
    local item="$1"

    [ ! -f "$item" ] && {
        echo "status=FATAL: no such file: '$item'" >>${GITHUB_OUTPUT}
        exit ${EXIT_FATAL}
    }

    [ ! -r "$item" ] && {
        echo "status=FATAL: file is not readable: '$item'" >>${GITHUB_OUTPUT}
        exit ${EXIT_FATAL}
    }

    [ ! -s "$item" ] && {
        echo "status=FATAL: file has zero length: '$item'" >>${GITHUB_OUTPUT}
        exit ${EXIT_FATAL}
    }

    INPUT_FILE_TO_SCAN="${item}"
}

testEnvVarsMandatory()
{
    [ -z "${RLSECURE_ENCODED_LICENSE}" ] && {
        echo "status=FATAL: no value for environment variable: 'RLSECURE_ENCODED_LICENSE'" >>${GITHUB_OUTPUT}
        exit ${EXIT_FATAL}
    }

    [ -z "${RLSECURE_SITE_KEY}" ] && {
        echo "status=FATAL: no value for environment variable: 'RLSECURE_SITE_KEY'" >>${GITHUB_OUTPUT}
        exit ${EXIT_FATAL}
    }
}

main()
{
    # testEnvVarsMandatory
    testInputArtifactToScan $*

    # we get the input as a parameter
    echo "Hello $1"

    # we produce output via GITHUB_OUTPUT
    time=$(date)
    echo "time=$time" >>${GITHUB_OUTPUT}

    mount
    id
    ls
}

# we pass all args to the function
main $*
