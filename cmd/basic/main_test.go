package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestName(t *testing.T) {
	assert := assert.New(t)

	name := Name()

	assert.Equal(name, "Basic", "The name should match exactly")
}
