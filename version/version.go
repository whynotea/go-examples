package version

import (
	"github.com/blang/semver/v4"
)

const rawVersion = "1.0.0"

// Version is the version of the build.
var Version = semver.MustParse(rawVersion)
